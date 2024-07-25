
import json

# Opening JSON file
f = open('data.json')

# returns JSON object as 
# a dictionary
data = json.load(f)

# Iterating through the json
# list
for i in range(len(data)):
    del data[i]['action']

# Serializing json
json_object = json.dumps(data, indent=4)
 
# Writing to sample.json
with open("out.json", "w") as outfile:
    outfile.write(json_object)

# Closing file
f.close()