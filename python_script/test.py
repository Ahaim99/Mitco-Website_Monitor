# Only for 2 responses

import requests
import difflib
import mysql.connector
from bs4 import BeautifulSoup


# Database Connection
mydb = mysql.connector.connect(
  host="localhost",
  user="alihamza",
  password="alihamza",
  database="website_monitoring"
)

# # Connection success message
# if mydb.is_connected():
#     print("Connected to MySQL database successfully!")
# else:
#     print("Connection failed!")


# cursor = mydb.cursor()
# cursor.execute("SELECT * FROM monitored_sites")

# for db in cursor:
#     print(db)

# cursor.close()
# mydb.close()


def get_html(url):
    try:
        response = requests.get(url)
        return response.text if response.status_code == 200 else None
    except requests.exceptions.RequestException as e:
        print(f"Error fetching {url}: {e}")  # Print the error for debugging
        return None

def compare_html(html1, html2):
    d = difflib.unified_diff(html1.splitlines(), html2.splitlines(), lineterm='')
    differences = "\n".join(d)
    return differences if differences else "No Changes Detected"

# Take input and save in URL
url = input("Type URL:").replace(" ", "")

if not url.startswith("https://"):
    url = "https://" + url

# print("Formated URL:" + url)

# Fetch HTML twice
html_first = get_html(url)
html_second = get_html(url)

# Beatifulsoup
# soup = BeautifulSoup(html_first)
# claim_sect = soup.find_all('section', attrs={"itemprop":"claims"})
# print(soup.prettify())

# print(html_first)


if html_first is not None and html_second is not None:
# if html_first and html_second:
    changes = compare_html(html_first, html_second)
    # print("Differences:\n", changes)

else:
    print("Failed to fetch webpage content.")