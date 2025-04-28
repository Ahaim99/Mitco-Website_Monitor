import requests
import difflib
import mysql.connector
from bs4 import BeautifulSoup
from datetime import datetime
import hashlib


# Database Connection
mydb = mysql.connector.connect(
    host="localhost",
    user="alihamza",
    password="alihamza",
    database="website_monitoring"
)

# Function to fetch HTML content
def get_html(url):
    try:
        response = requests.get(url)
        return response.text if response.status_code == 200 else None
    except requests.exceptions.RequestException as e:
        print(f"Error fetching {url}: {e}")
        return None

# Function to compare multiple HTML contents
def compare_multiple_html(*htmls):
    differences = []
    for i in range(len(htmls)):
        for j in range(i + 1, len(htmls)):
            if htmls[i] is None or htmls[j] is None:
                continue
            diff = difflib.unified_diff(
                htmls[i].splitlines(),
                htmls[j].splitlines(),
                lineterm='',
                fromfile=f"Fetch {i+1}",
                tofile=f"Fetch {j+1}"
            )
            diff_text = "\n".join(diff)
            if diff_text:
                differences.append(f"Difference between Fetch {i+1} and Fetch {j+1}:\n{diff_text}\n")
    return differences if differences else ["All fetched versions are identical."]



# def extract_unique_content(html, element_id):
#     if not html:
#         return None

#     soup = BeautifulSoup(html, "html.parser")

#     # Dynamically find element by ID
#     unique_div = soup.find(id=element_id)

#     unique_content = unique_div.decode_contents() if unique_div else None
#     return unique_content




# # Function to extract unique content using BeautifulSoup
# def extract_unique_content(html):
#     soup = BeautifulSoup(html, "html.parser")
    

#     # footer = soup.title.string if soup.find(attrs={'id':'TP_footer'}) else None
    
#     # Example: Extract a specific <div> with a unique ID or class
#     unique_div = soup.find("div", {"id": "footermenu"})  # Replace "unique-id" with the actual ID or class
#     unique_content = unique_div.get_text() if unique_div else None
    
#     return unique_content



def extract_unique_content(html, marker_start=None, marker_end=None):
    if not html:
        return None

    # Narrow down by string markers (optional)
    if marker_start and marker_end and marker_start in html and marker_end in html:
        start = html.index(marker_start) + len(marker_start)
        end = html.index(marker_end, start)
        html_slice = html[start:end]
    else:
        html_slice = html

    # Normalize whitespaces
    normalized = " ".join(html_slice.split())

    # Return SHA256 hash as a "fingerprint"
    return hashlib.sha256(normalized.encode("utf-8")).hexdigest()



def insert_into_text_match(cursor, url, text_match):
    now = datetime.now()

    # Check if URL exists
    cursor.execute("SELECT COUNT(*) FROM monitored_sites WHERE url = %s", (url,))
    (count,) = cursor.fetchone()

    if count > 0:
        # Update existing
        query = """
        UPDATE monitored_sites
        SET text_match = %s,
            last_check_datetime = %s,
            updated_at = %s
        WHERE url = %s
        """
        cursor.execute(query, (text_match, now, now, url))
    else:
        # Insert new
        query = """
        INSERT INTO monitored_sites (url, text_match, last_check_datetime, created_at, updated_at)
        VALUES (%s, %s, %s, %s, %s)
        """
        cursor.execute(query, (url, text_match, now, now, now))

    mydb.commit()

# Take input and save in URL
url = input("Type URL:").replace(" ", "")

if not url.startswith(("http://", "https://")):
    url = "https://" + url

# Fetch HTML 5 times
fetches = [get_html(url) for _ in range(5)]

# Compare all fetches
differences = compare_multiple_html(*fetches)

# for diff in differences: # just For testing
#     print(diff)

if fetches[0]:
    content = extract_unique_content(fetches[0])
    if content:
        insert_into_text_match(mydb.cursor(), url, content)

mydb.close()