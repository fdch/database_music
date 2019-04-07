#
#	reverse a dissertation
#
#
from csv import DictReader 

files = [
"part-3/section-4/structure.csv",
"part-3/section-3/structure.csv",
"part-3/section-2/structure.csv",
"part-3/section-1/structure.csv",
# "part-2/section-4/structure.csv",
"part-2/section-3/structure.csv",
"part-2/section-2/structure.csv",
"part-2/section-1/structure.csv"
]
dall=[]
for i in files:
	dict_list=[]
	try:
		reader = DictReader(open("../content/"+i, 'r'))
		for line in reader:
		    dict_list.insert(0,line)
	except:
		print i,"nofile"
	dall.append(dict_list)
ind=0
paths=[]
for i in dall:
	for j in i:
		paths.append("../content/"+files[ind][:17]+"sub/"+j['filename']+".tex")
	ind+=1

with open("../temp/niam.tex","w") as tf:
	for i in paths:
		with open(i,"r") as f:
			for line in reversed(list(f)):
				tf.write(line+"\n")









# structure.write("\n)\n")
# structure.close()