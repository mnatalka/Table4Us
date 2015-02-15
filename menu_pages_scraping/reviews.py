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

with open('restaurantURLs2.csv', 'r', newline='') as f:
	reader = csv.reader(f)
	for item in reader:
		print('in ' + str(i))
		url = item[0] + '/reviews/0'
		offset = 0
		r = requests.get(url,headers=headers)
		# convert the plaintext HTML markup into a DOM-like structure that can be searched
		soup = BeautifulSoup(r.content)
		max_offset = soup.find('div', class_='review_total').text.strip(' reviews')
		max_offset = math.ceil((int(max_offset)-10)/15)*15
		
		while(offset<=max_offset):
			url = item[0] + '/reviews/' + str(offset)
			r = requests.get(url,headers=headers)
			# convert the plaintext HTML markup into a DOM-like structure that can be searched
			soup = BeautifulSoup(r.content)		
			reviews = soup.find_all("div",class_='row listing_review')
			for review in reviews:
				name = review.find("span",class_='green').text
				star = review.find("i")['class'][1]
				star = star.strip('star_')
				score = review.find('div',class_='score').find('p').text
				score = score.strip('Credibility Score:%')
				date = review.find('i').parent.text
				match = re.search(r'visited(.*)',date)
				visited = match.group(1)
				visited = visited.strip(') ')
				text = review.find('p',class_='read_more').next_element
				text = str(text).strip()
				rev = {}
				rev['BusinessID'] = 'Dub' + str(i).zfill(5)
				rev['UserID']=name
				rev['stars']=star
				rev['credibility']=score
				rev['date']=visited
				rev['text']=text
				reviews2.append(rev)
				
				
				
			offset = offset+15
		i = i + 1	
		

with open('reviewJson2.json', 'w') as outfile:
    json.dump(reviews2, outfile)
