import sys 
import csv
import requests
from bs4 import BeautifulSoup


#spoof header so they appear to be coming from a browser rather than a bot
headers = { "user-agent": "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.104 Safari/537.36",
			"accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
			"accept-encoding": "gzip,deflate,sdch",
			"accept-language": "en-US,en;q=0.8,pl;q=0.6",
}

 #dynamically build the URL to be making a request to
 #offset is taken manually, by examining the last available site
offset = 0
restHref = []

while offset<556:
	url = "http://www.menupages.ie/Dublin/city_centre/all/all-cuisine/all-star/" + str(offset)

	r = requests.get(url,headers=headers)
	soup = BeautifulSoup(r.content)

	#the link are wrapped in h4 tags with class media-heading
	links = soup.find_all("h4", class_='media-heading')
	#iterate over each tag end extract the urls
	for link in links:
		restHref.append(link.find('a')['href'])

	offset += 15	

#write the links to the menupages.ie restaurant profiles into a restaurantsURLs.csv file	
	
with open('restaurantURLs2.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    for item in restHref:
        writer.writerow([item])
