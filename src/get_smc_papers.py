import requests as r
import json, textwrap
import xml.etree.ElementTree as ET

keyword = "data"

targets=[]

url = "https://zenodo.org/oai2d"

params={
	'verb': "ListRecords",
	'metadataPrefix' : "oai_datacite",
	'set' : "user-smc"
}

# the first record
try:
	record = r.get(url, params=params)
except:
	print "Couldn't make request"
	quit(1)


def getrecord (token):
	return r.get(url, params={
		'verb':"ListRecords",
		'resumptionToken':token
	})


while True:
	data = ET.fromstring(record.text.encode("utf-8")) # convert to xml tree
	rec=[]
	for i in data[2]:
		try:
			target = {}
			ident = i[0][0].text # the <identifier> field
			resource = i[1][0][3] # the <resource> field
			# the <title> field
			titl = resource[0][2][0].text.lower().replace('-',' ') 
			if keyword in titl:
				print textwrap.wrap(titl, 60)[0], "..."
				target['id'] = ident # add identifier to list
				authlist=[]
				for x in resource[0][1]:
					try:
					    authlist.append(x[0].text.decode())
					except:
						print "warning --> couldn't decode", x[0].text
						continue
				target['author'] = authlist  # add author list to same index
				target['title'] = titl
				targets.append(target)
				continue
		except:
			rec=i
			break
	try:
		record = getrecord(rec.text)
	except:
		break



with open("./smc_data.json", 'w') as f:
	f.write(json.dumps(targets, indent=4))



