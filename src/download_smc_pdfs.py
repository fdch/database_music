import json, os

with open("./smc_data.json","r") as t:
	data=json.load(t)

for i in data:
	ident="".join(i['id'].split(":")[2:])
	authors=" and ".join(i['author'])
	# print ident,authors.encode("utf-8")
	os.system("sh download_smc_pdfs.sh \""+ident+"\" \""+authors.encode("utf-8")+"\"")

