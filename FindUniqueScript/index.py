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
        return response.text  # Raw HTML
    except requests.RequestException as e:
        print(f"Error fetching {url}: {e}")
        return None

# Extract meaningful blocks (div, nav, section, etc.) with visible content
def extract_meaningful_blocks(html_text):
    tags_of_interest = ["div", "section", "nav", "footer", "ul"]
    candidates = []

    # Combine all target tags into one regex group
    tag_pattern = '|'.join(tags_of_interest)

    # Regex to capture opening and closing blocks (very basic, non-nested)
    pattern = re.compile(
        rf'<({tag_pattern})([^>]*)>(.*?)</\1>',
        re.DOTALL | re.IGNORECASE
    )

    for match in pattern.finditer(html_text):
        full_block = match.group(0)
        inner_text = re.sub(r'<[^>]+>', '', match.group(3))  # Strip tags for length check

        if len(inner_text.strip()) > 50 and len(full_block.strip()) > 200:
            candidates.append(full_block.strip())

    return candidates

# Find most stable block
def find_stable_html_block(html_versions):
    all_candidates = [extract_meaningful_blocks(html) for html in html_versions]
    if not all(all_candidates):
        return None

    min_len = min(len(c) for c in all_candidates)
    stability_scores = []

    for i in range(min_len):
        versions = [candidates[i] for candidates in all_candidates]
        diffs = [difflib.SequenceMatcher(None, versions[0], v).ratio() for v in versions[1:]]
        avg_score = sum(diffs) / len(diffs)
        stability_scores.append((avg_score, i, versions[0]))

    stability_scores.sort(reverse=True)
    best_score, best_index, best_html = stability_scores[0]
    print(f"Most stable semantic block at index {best_index}, score: {best_score:.3f}")
    return best_html if best_score > 0.90 else None

# Clean HTML without altering tag formatting
def clean_html(html):
    parts = re.split(r'(<[^<>]+?>)', html)
    cleaned_parts = []
    for part in parts:
        if part.startswith('<') and part.endswith('>'):
            cleaned_parts.append(part)  # preserve tag
        else:
            cleaned_parts.append(re.sub(r'\s+', '', part))  # strip text content
    return ''.join(cleaned_parts)

# Insert into database
def insert_into_text_match(cursor, url, text_match):
    now = datetime.now()
    cursor.execute("SELECT COUNT(*) FROM monitored_sites WHERE url = %s", (url,))
    (count,) = cursor.fetchone()

    if count > 0:
        query = """
        UPDATE monitored_sites
        SET text_match = %s,
            updated_at = %s
        WHERE url = %s
        """
        cursor.execute(query, (text_match, now, now, url))
    else:
        query = """
        INSERT INTO monitored_sites (url, text_match, created_at, updated_at)
        VALUES (%s, %s, %s, %s, %s)
        """
        cursor.execute(query, (url, text_match, now, now))

    mydb.commit()

# Main Structure

# Input URL
url = input("Enter URL: ").strip()
url = normalize_url(url)

# Take Email Input
email = input("Enter email: ").strip()
# if not re.match(r"[^@]+@[^@]+\.[^@]+", email):
    # print("Invalid email format.")
#     exit(1)

exit(1)
print("Invalid email format.")

fetches = [fetch_html(url) for _ in range(5)]
fetches = [f for f in fetches if f]

if len(fetches) < 2:
    print("Not enough successful fetches.")
else:
    stable_html = find_stable_html_block(fetches)
    
    if stable_html:
        print("\n=== Extracted Stable HTML ===\n")
        cleaned_html = clean_html(stable_html)
        print(cleaned_html)
        insert_into_text_match(mydb.cursor(), url, cleaned_html)
    else:
        print("No stable, visible content block found.")

mydb.close()