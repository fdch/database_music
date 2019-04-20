#!/usr/bin/python
import json, sys, requests, os, csv
try:
	with open("../litrev","r") as ss:
		sheetid=ss.readline()
except:
	print "Need to update sheed id file"
	quit(1)

domain="https://spreadsheets.google.com/feeds/list/"
sheetnum=6
altjson="/public/values?alt=json"
query=domain+sheetid+str(sheetnum)+altjson

try:
	r = requests.get(query)
	data = r.json()
except:
	print "Couldn't make request."
	quit(1)


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
			lng=k["gsx$expansion"]["$t"].encode("utf8")  #.title()
		except:
			print "Malformed expansion:",lng
		try:
			url=k["gsx$url"]["$t"].encode("utf8") # .replace("#","##")
			url="See also: \\url{"+url+"}"
		except:
			print "Malformed url:",url
		# try:
		# 	cit=k["gsx$cite"]["$t"].encode("utf8")
		# except:
		# 	print "Malformed cit:",cit
		try:
			des=k["gsx$description"]["$t"].encode("utf8")
		except:
			print lab,"Malformed description",des
		if des: # it has a description, therefore it has a glossary entry
			#DUALENTRY
			if lng: # it has a 'long' form, therefore it is an acronym
				if url: # it has a 'url'
					# if cit: # it has a \cite command
					# 	des=des+" "+url+" "+cit
					# else: # no \cite
						des=des+" "+url
				# entry="\\newdualentry{"+lab+"}{"+abb+"}\n\t{"+lng+"}\n\t{"+des+"}\n"
				entry="\\newglossaryentry{gls-"+lab+"}{\n\tname={"+abb+"},\n\tdescription={"+des+"}\n}\n"
				entry+="\\makeglossaries\n"
				entry+="\\newacronym[see={[Glossary:]{gls-"+lab+"}}]{"+lab+"}{"+abb+"}{"+lng+"\\glsadd{gls-"+lab+"}}\n"
# \newacronym[see={[Glossary:]{gls-OWD}}]{OWD}{OWD}{One-Way Delay\glsadd{gls-OWD}}

			else: #it does not have a 'long' form, it is not an acronym
			#GLOSSARY ENTRY
				entry="\\newglossaryentry{"+lab+"}{\n\tname={"+abb+"},\n\tdescription={"+des+"}\n}\n"
		else:
			# it does not have description
			#ACRONYM
			# des="\\dots"
			# if url:
			# 	if cit:
			# 		des=url+" "+cit
			# 	else:
			# 		des=url
			entry="\\newacronym{"+lab+"}{"+abb+"}{"+lng+"}\n"

		ldata.append([abb,lab])
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
