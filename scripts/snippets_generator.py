import re
import json

def builtin():
    output_json = {}
    # Opening JSON file
    with open('./builtin_functions_reference.json') as f:
        # returns JSON object as 
        # a dictionary
        data = json.load(f)
        for d in data:
            name = d["funcname"]

            output_json[name]={
                "scope":"lobster",
                "prefix": name,
                "body":[
                    f"{name}()"
                ],
                "description": d["doc"]+'\n'
            }
    # Convert and write JSON object to file
    with open("lobster.code-snippets", "w") as outfile: 
        json.dump(output_json, outfile,indent=4)

def parse_args(arg_string):
    res = ""
    for i,arg in enumerate(arg_string.split(",")):
        res += "${"+str(i+1)+":"+arg+"}, "
    return res[:-2]

def std():
    output_json = {}
    with open("../../lobster/modules/std.lobster") as f:
        data = f.read().split("\n")
        last_comment = ""
        for line in data[1:]:
            # print(line)
            if (match_obj:=re.search("(def ((.*)<?.*>?\((.*)\))):(.*//(.*))?" ,line)) != None:

                if match_obj.group(6):
                    last_comment += match_obj.group(6)
                output_json[match_obj.group(2)] = {
                    "scope":"lobster",
                    "prefix": match_obj.group(3),
                    "body":[
                        match_obj.group(3)+"("+parse_args(match_obj.group(4))+")"
                    ],
                    "description": f"(from std) \n {match_obj.group(0)[4:]} \n {last_comment} \n ",
                }
                last_comment = ""
            elif (match_obj:=re.search("^//",line))!=None:
                last_comment = line[2:]
        # Convert and write JSON object to file
        with open("lobster_std.code-snippets", "w") as outfile: 
            json.dump(output_json, outfile,indent=4)

std()

