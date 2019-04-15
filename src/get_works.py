#!/usr/bin/python
import json, sys, requests, os, csv
try:
	with open("../../works","r") as ss:
		sheetid=ss.readline()
except:
	print "Need to update sheed id file"
	quit(1)

domain="https://spreadsheets.google.com/feeds/list/"
sheetnum=1
altjson="/public/values?alt=json"
query=domain+sheetid+str(sheetnum)+altjson

try:
	r = requests.get(query)
	data = r.json()
except:
	print "Couldn't make request."
	quit(1)

with open("../portfolio/works.json", 'w') as gloss:
	gloss.write(json.dumps(data, indent=4))

def wwriter(target,entry,field):
	content=entry["gsx$"+field]["$t"].encode("utf8")
	if content:
		target.write(field.title())
		target.write(": ")
		target.write(content)
		target.write("\n")

kk=[ "title","description", "category", "performers", "videourl", "scoreurl", "imageurl", "date", "duration", "location", "programnotes" ]

with open("../portfolio/works_full.md", "w") as w:
	w.write("#Portfolio\n")
	w.write("##Federico Nicolás Cámara Halac\n")
	for e in data['feed']['entry']:
		w.write("\n-----------------------\n")
		for k in kk:
			wwriter(w,e,k)