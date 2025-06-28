import sys

file = open('xprof_output.txt', 'r')
 
string_to_cr = ""
    
while True:

    # read a char
    char = file.read(1) 

    if not char:
        sys.exit()
    
    if ord(char) != 10:
        string_to_cr = str(string_to_cr) + str(char)
        #print(char, ord(char), string_to_cr)
    else:
        if string_to_cr[0:8] == "filename":
            print(string_to_cr)
        string_to_cr = ""
    
file.close()
