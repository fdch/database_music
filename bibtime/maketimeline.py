import json, re

with open("main.json", "r") as f:
	data=json.load(f)

with open("freq.json", "r") as f:
	fdata=json.load(f)

cleanr = re.compile('<.*?>')
# print data[0]['issued']['date-parts'][0][0]
# print data[0]['author'][0]['family']
# print data[0]['title-short']

ddata=[]
with open("timeline.csv","w") as t:
	t.write("id,year,auth,titl\n")
	for i in data:
		d={}
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
		if "<span" in titl:
			titl=re.sub(cleanr, '', titl)
		try:
			idd=i['id']
		except:
			print "ID error", i
			quit(1)
		freq=fdata.get(idd)
		d["id"]=idd
		d["year"]=year
		d["auth"]=auth
		d["titl"]=titl
		d["freq"]=freq
		t.write(idd.encode("utf8")+","+year+","+auth+",\""+titl+"\"")
		t.write("\n")
		if freq:
			ddata.append(d)

with open("combined.json","w") as f:
	f.write(json.dumps(ddata, indent=4))
