import requests
from bs4 import BeautifulSoup

# Tutorial Link
TutorialLink = "https://hackernoon.com/getting-the-source-of-a-website-with-pythons-requests-library"


# Return the beautify HTML of a website
def get_clean_html(url):
    response = requests.get(url)
    if response.status_code == 200:
        soup = BeautifulSoup(response.text, 'html.parser')
        # Normalize HTML by removing script and style tags
        for tag in soup(["script", "style"]):
            tag.decompose()
        return soup.prettify()
    return None

# return True and False if the HTML is same or not
def compare_html(html1, html2):
    return html1 == html2

# Define URL
url = "https://mitco.pk"

# Fetch cleaned HTML twice
html_first = get_clean_html(url)
html_second = get_clean_html(url)

if html_first and html_second:
    if compare_html(html_first, html_second):
        print("No Changes Detected")
    else:
        print("Website content has changed!")
else:
    print("Failed to fetch webpage content.")