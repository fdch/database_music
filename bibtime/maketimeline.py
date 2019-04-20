import json

with open("main.json", "r") as f:
	data=json.load(f)

# print data[0]['issued']['date-parts'][0][0]
# print data[0]['author'][0]['family']
# print data[0]['title-short']

with open("timeline.csv","w") as t:
	t.write("year,auth,titl\n")
	for i in data:
		try:
			year=str(i['issued']['date-parts'][0][0])
		except:
			print "YEAR error",i['id']
			quit(1)
		try:
			auth=i['author'][0]['family'].encode("utf8")
		except:
			try:
				auth=i['editor'][0]['family'].encode("utf8")
			except:
				print "NO AUTHOR error",i['id']
				auth=''
		try:
			titl=i['title'].encode("utf8")
		except:
			print "TITLE error", i['id']
			quit(1)
		t.write(year+","+auth+","+titl)
		t.write("\n")