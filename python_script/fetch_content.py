import requests


# Tutorial Link
print("https://hackernoon.com/getting-the-source-of-a-website-with-pythons-requests-library")

# Define the URL of the website you want to scrape
url = 'https://mitco.pk'

# Send an HTTP GET request to the URL
response = requests.get(url)

# Check if the request was successful (status code 200)
if response.status_code == 200:
    # Print the HTML source code
    print(response.text)
else:
    print('Failed to retrieve the webpage. Status code:', response.status_code)