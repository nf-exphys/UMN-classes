import re

infile = open("icd10cm.txt", "r")

user_in = str(input("Enter ICD10 code or description string:"))
user_in = user_in.lower()

out_dict = {}

for line in infile: 
  line = line.strip()
  line = line.lower()
  if user_in in line:
    elements = line.split("\t")
    out_dict[elements[0]] = elements[1]

for values in out_dict.items():
  print(values)
  
input('Press ENTER to exit') #helpful for running file from command line
  
