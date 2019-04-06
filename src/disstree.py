#
#	CREATE A DISSERTATION OUTLINE FROM THE DIRECTORY TREE
#	READING "structure.csv" FILES IN EACH DIRECTORY AND SUB DIRECTORY
#
#	THIS FILE USES wctex.sh, A TEX FILE WORD COUNTING UTILITY
#
#	$ python disstree.py
#
#
#
from csv import DictReader 	#	FOR IMPORTING CSV FILES
from os import path			#	TO CHECK IF FILE EXIST
import subprocess	 		#	TO CALL wctex.sh (TEX FILE WORD COUNT UTIL)



#	UNNNUMBERED SECTIONS
s=["Introduction","Conclusion","Appendices","Abstract"]

def csv_dict_list(file,path):
    reader = DictReader(open(path+"/"+file, 'rb'))
    dict_list = []
    for line in reader:
        dict_list.append(line)
    return dict_list

def errormess(file,who="disstree.py"):
	print "ERROR: "+who+" could not open " + file

def check_and_write(file,title,sectype,target):
	if path.isfile(file):
		titl="\""+title.title()+"\""
		sect="\""+sectype+"\""
		words=0
		sb=subprocess.Popen(['sh', 'wctex', file],
			stdout=subprocess.PIPE,
			stderr=subprocess.STDOUT)
		stdout,stderr = sb.communicate()
		if not stderr:
			words=stdout.split()[0]
			target.write("\n{} {} {} {}".format(sect,file,titl,words))
		else:
			errormess("wctex subprocess","check_and_write")
		return words




#	LATER: try to make this recursive... should be easy
def traverse_structures(file,target,outline,contentdir):
	sumarray=[]
	chapters  = csv_dict_list(file,contentdir)
	for ch in chapters:
		chfile=ch['filename']
		chtitl=ch['title']
		chtarg=ch['target']
		chpath=contentdir+chfile
		section = csv_dict_list(file,chpath)
		chlen=len(section)-1
		sectar=0
		for se in section:
			sefile=se['filename']
			setitl=se['title']
			spath=chpath+"/"+sefile
			#
			#	assign section hierarchy here
			#
			chatype="part"
			sectype="chapter"
			ssetype="section"
			if chtitl in s:
				chatype="chapter*"
				sectype+="*"
				ssetype+="*"
			try:	
				subsection = csv_dict_list(file,spath)
				sectar=int(float(chtarg)/float(chlen))				
				seclen=len(subsection)-1
				for ss in subsection:
					ssfile=ss['filename']
					sstitl=ss['title']
					try:
						#	WE ARE A SECTION OR SUBSECTION
						texf=spath+"/sub/"+ssfile+".tex"
						if not sstitl:
							sstitl=setitl
							w=check_and_write(texf,sstitl,sectype,target)
							outline.write("\t"+sstitl+" "+w+"\n")
							print "\tCHAPTER: "+sstitl+" "+w
						else:
							sslen=len(ss)-1
							sstar=int(float(sectar)/float(seclen))
							sssss=int(float(sstar)/float(sslen))
							w=check_and_write(texf,sstitl,ssetype,target)
							div=float(w)/float(sssss)
							sumarray.append(div)
							per=str(int(div*100.))+"%"
							outline.write("\t\t"+sstitl+" "+w+" "+per+"\n")
							print "\t\tSECTION: "+sstitl+" "+per
					except:
						errormess(texf,"sections")
			except:
				try:
					#	WE ARE A CHAPTER (abstract)
					texf=spath+".tex"
					w=check_and_write(texf,chtitl,chatype,target)
					outline.write(chtitl+" "+w+"\n")
					print "PART: "+chtitl+" "+w
				except:
					errormess(texf,"chapters")
	return sumarray

#	ROOT DIRECTORY WHERE ALL THE CONTENT RESIDES
contentdir="content/"

structure=open("metadata/structure_array.sh","w")
structure.write("#\tStructure Array\n#\tAutomatically Generated from:\n")
structure.write("#\t<distree.py>\n")
structure.write("STRUCT=(")

with open("output/outline.txt","w") as outline:
	outline.write("Dissertation Outline\n")
	sumarray=traverse_structures("structure.csv",structure,outline,contentdir)

structure.write("\n)\n")
structure.close()

sums=0
for i in sumarray:
	sums+=i
line=''
for i in range(80):
	line+="-"
print line
print "\nProgress: "+str(int(sums/float(len(sumarray))*100))+"% completed.\n"
print line

# contentdir="abstract/"

# abstracta=open("metadata/abstract_array.sh","w")
# abstracta.write("#\tAbstract Array\n#\tAutomatically Generated from:\n")
# abstracta.write("#\t<distree.py>\n")
# abstracta.write("ABSTRACT=(")

# with open("output/abstract.txt","w") as outline:
# 	outline.write("Abstract Outline\n")
# 	traverse_structures("structure.csv",abstracta,outline,contentdir)

# abstracta.write("\n)\n")
# abstracta.close()










