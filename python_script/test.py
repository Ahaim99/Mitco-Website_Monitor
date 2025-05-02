import requests
import difflib
import mysql.connector
from datetime import datetime
from bs4 import BeautifulSoup

# Database Connection
mydb = mysql.connector.connect(
    host="localhost",
    user="alihamza",
    password="alihamza",
    database="website_monitoring"
)

# Fetch HTML from URL
def fetch_html(url):
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        return response.content  # Return raw bytes
    except requests.RequestException as e:
        print(f"Error fetching {url}: {e}")
        return None

# Divide byte content into windows from the bottom up
def get_byte_windows(content_bytes, window_size=500):
    return [content_bytes[i:i+window_size] for i in range(len(content_bytes)-window_size, -1, -window_size)]

# Compare byte windows across multiple versions and find most stable block
def find_stable_footer_window(byte_fetches, window_size=500):
    num_versions = len(byte_fetches)
    if num_versions < 2:
        return None

    # Divide each fetch into windows
    fetch_windows = [get_byte_windows(fetch, window_size) for fetch in byte_fetches]
    min_windows = min(len(windows) for windows in fetch_windows)

    stability_scores = []
    for i in range(min_windows):
        block_versions = [fetch_windows[j][i] for j in range(num_versions)]
        # Score: how similar all blocks are across fetches
        diffs = [difflib.SequenceMatcher(None, block_versions[0], bv).ratio() for bv in block_versions[1:]]
        avg_score = sum(diffs) / len(diffs)
        stability_scores.append((avg_score, i))

    # Highest similarity = most stable
    stability_scores.sort(reverse=True)
    best_score, best_index = stability_scores[0]
    print(f"Most stable window at index {best_index}, score: {best_score:.3f}")

    # Return best stable window as bytes
    return fetch_windows[0][best_index] if best_score > 0.90 else None

# Convert byte block to text and parse
def decode_and_pretty_print(html_bytes):
    try:
        html_text = html_bytes.decode("utf-8", errors="ignore")
        soup = BeautifulSoup(html_text, "html.parser")
        print("\n=== Extracted Footer Candidate ===\n")
        print(soup.prettify())
        return soup
    except Exception as e:
        print(f"Decoding error: {e}")
        return None

# MAIN
url = input("Enter URL:").replace(" ", "")
if not url.startswith(("http://", "https://")):
    url = "https://" + url


# Fetch site multiple times
fetches = [fetch_html(url) for _ in range(5)]
fetches = [f for f in fetches if f]

print(fetches)

if len(fetches) < 2:
    print("Not enough successful fetches.")
else:
    stable_footer_bytes = find_stable_footer_window(fetches)
    if stable_footer_bytes:
        decode_and_pretty_print(stable_footer_bytes)
    else:
        print("No stable footer-like region found.")