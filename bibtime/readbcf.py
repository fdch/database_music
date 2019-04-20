import xml.etree.ElementTree as ET
import json


data = ET.parse("../temp/main.bcf")
root = data.getroot()
data_dict={}
f = open("bibused.csv", "w")
f.write("id,idx\n")
for i in root[19]: # advance index to '<bcf:section number="0">' child node
	idd=i.text
	idx=i.attrib['order']
	if idd in data_dict:
		data_dict[idd].append(idx)
	else:
		data_dict[idd]=[]
		data_dict[idd].append(idx)
	f.write(idd+","+idx+"\n")
f.close()

with open("freq.json","w") as f:
	f.write(json.dumps(data_dict, indent=4))

# print data_dict
# for i in data_dict:
	# print i
