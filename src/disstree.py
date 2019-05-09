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
import dissroutines

#	ROOT DIRECTORY WHERE ALL THE CONTENT RESIDES
contentdir="content/"

structure=open("metadata/structure_array.sh","w")
structure.write("#\tStructure Array\n#\tAutomatically Generated from:\n")
structure.write("#\t<distree.py>\n")
structure.write("STRUCT=(")

with open("output/outline.txt","w") as outline:
	outline.write("Dissertation Outline\n")
	sumarray=dissroutines.traverse_structures2("structure.csv",structure,outline,contentdir)
	# sumarray=dissroutines.traverse_structures("structure.csv",structure,outline,contentdir)

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










