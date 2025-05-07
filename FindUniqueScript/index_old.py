from urllib.parse import urlparse, urlunparse
import requests
import difflib
import mysql.connector
from datetime import datetime
from bs4 import BeautifulSoup
import re

# Database Connection
mydb = mysql.connector.connect(
    host="localhost",
    user="alihamza",
    password="alihamza",
    database="website_monitoring"
)

# Normalize URL
def normalize_url(url):
    url = url.strip()
    if not url.startswith(("http://", "https://")):
        url = "https://" + url

    parsed = urlparse(url)
    scheme = parsed.scheme
    netloc = parsed.netloc
    path = parsed.path.rstrip('/')  # remove trailing slash
    normalized_url = urlunparse((scheme, netloc, path, '', '', ''))
    return normalized_url

# Fetch HTML
def fetch_html(url):
    headers = {
        "User-Agent": "MyCustomUserAgent/1.0"
    }
    try:
        response = requests.get(url, timeout=10, headers=headers, allow_redirects=True)
        response.raise_for_status()
        return response.text
    except requests.RequestException as e:
        print(f"Error fetching {url}: {e}")
        return None

# Extract meaningful blocks (div, nav, section, etc.) with visible content
def extract_meaningful_blocks(html_text):
    # soup = BeautifulSoup(html_text, "html.parser")
    # soup = BeautifulSoup(html_text, "lxml")  # or "html5lib"
    soup = BeautifulSoup(html_text, "html5lib")

    candidates = []

    # Tags of interest
    for tag in soup.find_all(["div", "section", "nav", "footer", "ul"]):
        text = tag.get_text(strip=True)
        html = tag.prettify()

        # Heuristic: meaningful block = visible, not empty, decent length
        if len(text) > 50 and len(html) > 200:
            candidates.append(html)

    return candidates

# Find most stable block across versions
def find_stable_html_block(html_versions):
    all_candidates = [extract_meaningful_blocks(html) for html in html_versions]
    return all_candidates

    # if not all(all_candidates):
    #     return None

    # min_len = min(len(c) for c in all_candidates)
    # stability_scores = []

    # for i in range(min_len):
    #     versions = [candidates[i] for candidates in all_candidates]
    #     diffs = [difflib.SequenceMatcher(None, versions[0], v).ratio() for v in versions[1:]]
    #     avg_score = sum(diffs) / len(diffs)
    #     stability_scores.append((avg_score, i, versions[0]))

    # stability_scores.sort(reverse=True)
    # best_score, best_index, best_html = stability_scores[0]
    # print(f"Most stable semantic block at index {best_index}, score: {best_score:.3f}")
    # return best_html if best_score > 0.90 else None

# Insert into DB
def insert_into_text_match(cursor, url, text_match):
    now = datetime.now()
    cursor.execute("SELECT COUNT(*) FROM monitored_sites WHERE url = %s", (url,))
    (count,) = cursor.fetchone()

    if count > 0:
        query = """
        UPDATE monitored_sites
        SET text_match = %s,
            last_check_datetime = %s,
            updated_at = %s
        WHERE url = %s
        """
        cursor.execute(query, (text_match, now, now, url))
    else:
        query = """
        INSERT INTO monitored_sites (url, text_match, last_check_datetime, created_at, updated_at)
        VALUES (%s, %s, %s, %s, %s)
        """
        cursor.execute(query, (url, text_match, now, now, now))

    mydb.commit()

def clean_html(html):
    # Match tags vs text
    parts = re.split(r'(<[^<>]+?>)', html)  # safe tag match

    cleaned_parts = []
    for part in parts:
        if part.startswith('<') and part.endswith('>'):
            # It's a tag: preserve it exactly
            cleaned_parts.append(part)
        else:
            # It's text content: remove all whitespace characters
            cleaned_text = re.sub(r'\s+', '', part)
            cleaned_parts.append(cleaned_text)

    return ''.join(cleaned_parts)


# Usage:
url = input("Enter URL: ").strip()
url = normalize_url(url)
# print(f"Normalized URL: {url}")


fetches = [fetch_html(url) for _ in range(5)]
fetches = [f for f in fetches if f]

if len(fetches) < 2:
    print("Not enough successful fetches.")
else:
    stable_html = find_stable_html_block(fetches)
    print(stable_html)
    
    # if stable_html:
    #     print("\n=== Extracted Stable HTML ===\n")
    #     cleaned_html = clean_html(stable_html)
    #     print(cleaned_html)
    #     insert_into_text_match(mydb.cursor(), url, cleaned_html)
    # else:
    #     print("No stable, visible content block found.")

mydb.close()