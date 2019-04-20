import json

with open("combined.json","r") as f:
	data=json.load(f)

tar=open("data.txt","w")

minyear=1942
stride=10


c="900" # color
s="3" # size

# Pd data template
header=[
"data;",
"template mygrid;",
"float x;",
"symbol xaxis;",
";",
"template mymap;",
"float x;",
"float y;",
"float col;",
"symbol name;",
"symbol title;",
"float s;",
";",
";",
]


for i in header:
	tar.write(i+"\n")

for i in data:
	x=str((int(i['year'])-minyear)*stride+stride)
	n=i['auth'].encode("utf8")
	n+=":"+str(i['year'])[-2:]
	n+=":"+i['titl'].encode("utf8").replace(" ","_")[:15]
	for j in i['freq']:
		y=str(int(j)*stride+stride)
		tar.write("mymap "+x+" "+y+" "+c+" "+n+" "+s+";\n")

for i in range(2019-minyear):
	tar.write("mygrid "+str(i+minyear)+" symbol;\n")
tar.close()