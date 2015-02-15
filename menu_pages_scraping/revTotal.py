import sys
import csv
import re
import requests
import json
import math
from bs4 import BeautifulSoup

#spoof header so they appear to be coming from a browser rather than a bot
headers = { "user-agent": "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.104 Safari/537.36",
			"accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
			"accept-encoding": "gzip,deflate,sdch",
			"accept-language": "en-US,en;q=0.8,pl;q=0.6",
}

#dynamically build the URL to be making a request to
#offset is taken manually, by examining the total review count
offset = 0
i = 1

reviews2 = []

with open('restaurantURLs.csv', 'r', newline='') as f:
	reader = csv.reader(f)
	for item in reader:
		print('in ' + str(i))
		url = item[0] + '/reviews/0'
		offset = 0
		r = requests.get(url,headers=headers)
		# convert the plaintext HTML markup into a DOM-like structure that can be searched
		soup = BeautifulSoup(r.content)
		print(item)
		
		max_offset = soup.find('div', class_='review_total').string     #.strip(' reviews')
		#max_offset = math.ceil((int(max_offset)-10)/15)*15
		print(max_offset)
		break
		
	
		
		
		
		
		
		
		
		