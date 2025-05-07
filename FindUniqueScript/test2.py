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

# Fetch HTML
def fetch_html(url):
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        return response.text
    except requests.RequestException as e:
        print(f"Error fetching {url}: {e}")
        return None

# Extract meaningful blocks (div, nav, section, etc.) with visible content
def extract_meaningful_blocks(html_text):
    # soup = BeautifulSoup(html_text, "html.parser")
    soup = BeautifulSoup(html_text, "lxml")  # or "html5lib"
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


# def clean_html(html):
#     # Remove all whitespace characters including line breaks, tabs, etc.
#     return re.sub(r'\s+', '', html)

# def clean_html(html):
#     soup = BeautifulSoup(html, "html.parser")

#     # Clean text nodes: strip spaces and newlines inside visible content
#     for element in soup.find_all(text=True):
#         cleaned = ' '.join(element.split())  # collapse multiple spaces/newlines into single space
#         element.replace_with(cleaned)

#     return str(soup)


# def clean_html(html):
#     # Preserve tags exactly as-is, only clean between them
#     # Collapse multiple spaces and line breaks between tags
#     html = re.sub(r'>\s+<', '><', html)  # remove whitespace between tags

#     # Clean text content between tags: replace multiple spaces/newlines with a single space
#     def clean_text_between_tags(match):
#         text = match.group(1)
#         cleaned = ' '.join(text.split())  # collapse internal whitespace
#         return f'>{cleaned}<'

#     html = re.sub(r'>([^<]+)<', clean_text_between_tags, html)
#     return html


# def clean_html(html):
#     # This will hold the final cleaned HTML
#     result = []

#     # Pattern to split HTML into tags and text nodes
#     parts = re.split(r'(<[^>]+>)', html)

#     for part in parts:
#         if part.startswith('<') and part.endswith('>'):
#             # It's an HTML tag, leave it untouched
#             result.append(part)
#         else:
#             # It's text content — clean it
#             cleaned_text = ' '.join(part.split())  # remove extra whitespace
#             result.append(cleaned_text)

#     return ''.join(result)

# def clean_html(html):
#     # Split the HTML into tags and non-tag (text) parts
#     parts = re.split(r'(<[^>]+>)', html)  # split on tags

#     cleaned_parts = []
#     for part in parts:
#         if part.startswith('<') and part.endswith('>'):
#             # It's an HTML tag — leave it untouched
#             cleaned_parts.append(part)
#         else:
#             # It's text between tags — remove all whitespace characters
#             cleaned_text = re.sub(r'\s+', '', part)
#             cleaned_parts.append(cleaned_text)

#     return ''.join(cleaned_parts)

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


# MAIN
url = input("Enter URL:").strip()
if not url.startswith(("http://", "https://")):
    url = "https://" + url

fetches = [fetch_html(url) for _ in range(5)]
fetches = [f for f in fetches if f]

if len(fetches) < 2:
    print("Not enough successful fetches.")
else:
    stable_html = find_stable_html_block(fetches)
    if stable_html:
        print("\n=== Extracted Stable HTML ===\n")
        # print(stable_html)
        # insert_into_text_match(mydb.cursor(), url, stable_html)
        cleaned_html = clean_html(stable_html)
        print(cleaned_html)
        insert_into_text_match(mydb.cursor(), url, cleaned_html)
    else:
        print("No stable, visible content block found.")

mydb.close()