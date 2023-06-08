"""
" 
"
"""

from fileinput import close
import math
import sys
import re
import os


def beautify_name(name:str):
	"""
	String left and right " and then convert it to lower case
	"""
	return name.lstrip('"').rstrip('"').lower()


"""
" Based on the object type choose the file extension. Default extension
" is .sql
"""
def get_file_extension(name:str) -> str:
	if name == "PACKAGE":
		return ".pls"
	elif name == "PACKAGE BODY":
		return ".plb"
	else:
	 	return ".sql"



def read_file(filename:str):
	def_started = False
	stripped_line =''
	END_PATTERN = "/"
	object_name = ''

	dirname = ''
	filename_object = ''
	f_object = None

	with open(filename) as f:
		for line in f:
			# Remove leading and trailing spaces			
			line = line.rstrip().lstrip()		
			start_pattern=re.compile(r"^create",flags=re.IGNORECASE)

			if start_pattern.match(line) and not def_started:                
				def_started = True
				
				try:
					"""
					Check if the pattern matches create or replace ... syntax
					"""
					pattern_before_object = re.compile(r"create\s+(or\s+replace\s+(?:force\s+)?)?(\w+)(\s+)((\w+\s+)+)(\".+?\")", flags=re.IGNORECASE)
					match = pattern_before_object.match(line)
				except AttributeError:
					print("Can't make group")
				

				if match:
					try:
						print(match.group(2))							

						if match.group(2).upper() == "TABLE":
							continue

						if match.group(2).upper() == "INDEX":
							continue

						#print(match.group(2)) #Editionable
						#print(match.group(4)) #Object type
						
						dirname = match.group(4).strip()
						
						if not os.path.exists(dirname):
							os.mkdir(dirname.lower())

						file_ext = get_file_extension(dirname)
						
						filename_object = dirname + "/" + beautify_name(match.group(6)) + file_ext		
						f_object = open(filename_object,"w")																									
						#print(beautifyName(match.group(6)))	# Object name
					except :
						print("Group not available")
						

			if def_started:
				if not f_object == None:
					print(line.replace('"',''))				
					f_object.write(line.replace('"','') + "\n")
					


			if line == END_PATTERN:
				#print(line)
				def_started = False

				if not f_object == None:
					f_object.close()
					f_object = None
			
											
read_file(sys.argv[1])
