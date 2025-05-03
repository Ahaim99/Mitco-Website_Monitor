import requests
import mysql.connector
from datetime import datetime
from bs4 import BeautifulSoup

# DB connection
mydb = mysql.connector.connect(
    host="localhost",
    user="alihamza",
    password="alihamza",
    database="website_monitoring"
)

def fetch_html(url):
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        return response.text
    except requests.RequestException as e:
        print(f"Error fetching {url}: {e}")
        return None

def extract_html_slice(html_text, start_ratio=0.7, end_ratio=0.9):
    soup = BeautifulSoup(html_text, "html.parser")

    # Remove noisy tags
    for tag in soup(['script', 'style', 'noscript', 'meta', 'link']):
        tag.decompose()

    # Convert cleaned soup back to full HTML string
    cleaned_html = str(soup)

    # Get total length and calculate slice range
    total_len = len(cleaned_html)
    start_index = int(total_len * start_ratio)
    end_index = int(total_len * end_ratio)
    sliced_html = cleaned_html[start_index:end_index]

    # Try to prettify sliced HTML
    try:
        sliced_soup = BeautifulSoup(sliced_html, "html.parser")
        return sliced_soup.prettify()
    except Exception:
        return sliced_html  # Fallback

def insert_into_text_match(cursor, url, html_block):
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
        cursor.execute(query, (html_block, now, now, url))
    else:
        query = """
        INSERT INTO monitored_sites (url, text_match, last_check_datetime, created_at, updated_at)
        VALUES (%s, %s, %s, %s, %s)
        """
        cursor.execute(query, (url, html_block, now, now, now))

    mydb.commit()

# MAIN
url = input("Enter URL:").strip()
if not url.startswith(("http://", "https://")):
    url = "https://" + url

html_text = fetch_html(url)
if html_text:
    html_block = extract_html_slice(html_text, start_ratio=0.7, end_ratio=0.9)
    print("\n=== Extracted HTML Block ===\n")
    print(html_block[:1000])  # Preview only first 1000 characters
    insert_into_text_match(mydb.cursor(), url, html_block)
else:
    print("Failed to fetch site.")

mydb.close()
