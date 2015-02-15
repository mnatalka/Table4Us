import sys
import csv
import re
import requests
import json
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
url = ''
restaurants = []

i=1

with open('restaurantURLs2.csv', 'r', newline='') as f:
	reader = csv.reader(f)
	for item in reader:
		url = item[0]
		r = requests.get(url,headers=headers)

		# convert the plaintext HTML markup into a DOM-like structure that can be searched
		soup = BeautifulSoup(r.content)

		#extract restaurant attributes:

		name = soup.find('div', class_='rest_name').find("h1").text
		full_address = soup.find('div', class_='rest_name').find("p", class_='title small').text
		stars = soup.find('i', class_='stars')['class'][1]
		stars = int(stars.strip('star_'))
		price_range = soup.find('i', class_='price')['class'][1]
		total_reviews = soup.find('div', class_='review_total').text
		match = re.search('\d+',total_reviews)
		review_count = int(match.group())
		website = soup.find('div', class_='block border').find('a')['href']

		#because restaurant categories are in one of many p tags we have to navigate between page elements that are on the same level of the parse tree:
		cuisinesList=[]
		cuisines = soup.find('div', class_='block border').find_all('strong')
		for p in cuisines:
			new = p.string
			if(new=='CUISINES'):
				cuisines = p.next_sibling.next_sibling.next_sibling
				cuisines = str(cuisines)
				#remove white spaces
				cuisines = cuisines.strip()
				#split categories and create a list with different categories as elements
				cuisinesList = cuisines.split(',')
				#remove left over white spaces
				cuisinesList = [s.strip() for s in cuisinesList]

		#navigate to web page with restaurant location in order to extract longitude and latitude

		url = url + '/location'
		r = requests.get(url,headers=headers)
		soup = BeautifulSoup(r.content)

		#find all scripts tag that have LatLng string in them, that is where the latitude and longitude is stored
		for s in soup.find_all("script",text=re.compile("LatLng")):
			#find the coordinates in the text that starts with google.maps.LatLng and is followed by coordinates
			match = re.search(r'google.maps.LatLng([\S,.]+)',s.text)
			#extract string with coordinates and strip of characters ( ) ;
			if match:
				location = match.group(1)
				location = location.strip("();")
				#extract and separate the coordinates and convert into floats
				loc = location.split(',')
				lat = float(loc[0])
				long = float(loc[1])
			else:
				lat = None
				long = None

		#create a dictionary with all the restaurant attributes
		

		rest = {}


		rest['BusinessID'] = 'Dub' + str(i).zfill(5)
		rest['name'] = name
		rest['address'] = full_address
		rest['city'] = 'Dublin'
		rest['rating'] = stars
		rest['review_count'] = review_count
		rest['website'] = website
		rest['category'] = cuisinesList
		rest['latitude'] = lat
		rest['longitude'] = long
		
		i = i + 1
		print(i)
		restaurants.append(rest)

with open('restJson2.json', 'w') as outfile:
    json.dump(restaurants, outfile)





