#!/usr/bin/python
import json, sys, requests, os, csv
domain="https://spreadsheets.google.com/feeds/list/"
sheetid="1tMkdssQlN_wbGS1SjfORS7AOBspKvvun7_AvzxctMrE/"
sheetnum=6
altjson="/public/values?alt=json"
query=domain+sheetid+str(sheetnum)+altjson

r = requests.get(query)
data = r.json()

#	WRITE REQUEST FOR LATER USE

with open("./glossary/glossary.json", 'w') as gloss:
	gloss.write(json.dumps(data, indent=4))

ldata=[['acronym','label']]


# FROM: https://en.wikibooks.org/wiki/LaTeX/Glossary
# \newdualentry{OWD} % label
#   {OWD}            % abbreviation
#   {One-Way Delay}  % long form
#   {The time a packet uses through a network from one host to another} % description

with open("./glossary/definitions.tex", "w") as g:
	for k in data['feed']['entry']:
		try:
			lab=k["gsx$label"]["$t"].encode("utf8")
		except:
			print "Malformed label:",lab
		try:
			abb=k["gsx$acronym"]["$t"].encode("utf8")
		except:
			print "Malformed abbreviation:",abb
		try:
			lng=k["gsx$expansion"]["$t"].encode("utf8").title()
		except:
			lng=abb
			# print "Malformed expansion:",lng
		
		try:
			url=k["gsx$url"]["$t"].encode("utf8") # .replace("#","##")
			url="See also: \\url{"+url+"}"
		except:
			print "Malformed url:",url
		try:
			cit=k["gsx$cite"]["$t"].encode("utf8")
		except:
			print "Malformed cit:",cit
		try:
			des=k["gsx$description"]["$t"].encode("utf8")
			if url:
				if cit:
					des=des+" "+url+" "+cit
				else:
					des=des+" "+url
		except:
			print lab,"has no description........................"
			des="\\dots"
			if url:
				if cit:
					des=url+" "+cit
				else:
					des=url
		ldata.append([abb,lab])
		entry="\\newdualentry{"+lab+"}{"+abb+"}\n\t{"+lng+"}\n\t{"+des+"}\n"
		try:
			g.write(entry.encode("utf8"))
		except:
			print "************[       get_glossary.py         ]***********"
			print "************[ CAN'T DECODE WEIRD CHARACTER  ]***********"
			print lab,":",lng,":",des
			print "*******************************************************"

with open("./glossary/labels.csv","w") as lb:
	writer = csv.writer(lb)
	writer.writerows(ldata)

g.close()
quit()
