import re
from html.parser import HTMLParser

# TODO: add file TM_FILENAME

# sample input
# append(xs:[any], ys:[any]) -> [any]
#TODO: did not worktype_field_count(obj) -> int
def json_fmt(name, prefix, body, desc):
    # new_body = re.sub("\w*:\w*",f"{{${1}:{2}}}",body)
    arr = re.split("(\w*):\w*", body)
    new_body = arr[0]
    if len(arr) != 1:
        j = 0
        for i in range(1,len(arr[:-1])):
            if i % 2 == 0:
                continue
            j+=1
            new_body += f'${{{j}:{arr[i]}}}, '

        new_body = new_body[:-2]
        new_body += ')'#arr[-1]


    return f"""
    "{name}": {{
        "scope": "lobster",
        "prefix": "{prefix}",
        "body": ["{new_body}"],
        "description": "{body} \\n {desc}"
    }},
    """


class MyHTMLParser(HTMLParser):
    read = False
    half_way_point = False
    buf = ""
    json_output = ""
    input_arr = ["", "", "", ""]
    arg_num = 0

    def handle_starttag(self, tag, attrs):
        if tag == "tr":
            self.read = True
            self.buf = ""
            print("==start==", tag)

    def handle_endtag(self, tag):
        if tag == "tr":
            self.input_arr[3] = self.buf
            self.read = False
            self.half_way_point = False
            self.arg_num+=0
            print("==end==", tag)
            self.json_output += json_fmt(self.input_arr[0], self.input_arr[1], self.input_arr[2], self.input_arr[3])
        elif tag == "tt":
            self.half_way_point = True
            self.input_arr[2] = self.buf
            print("----", self.buf)
            self.buf = ""

    def handle_data(self, data):
        if self.read:
            self.arg_num+=1
            if self.buf == "" and not self.half_way_point:
                self.input_arr[0] = data
                self.input_arr[1] = data
            self.buf += data
            print(data)


parser = MyHTMLParser()
with open('./input.html') as f:
    parser.feed(f.read())
    print(parser.json_output)
    json_f = open("output.json", "w")
    json_f.write(parser.json_output)
    json_f.close()

