#!/usr/bin/env python
import re
import json
from datetime import datetime

def ts2seconds(str):
    h, m, s = str.split(':')
    return int(h) * 3600 + int(m) * 60 + float(s)

data = {
    "data": [
        {
            "start": [],
            "end": [],
            "str": [],
        },
    ]
}

filepath = 'assets/captions.sbv' 
firstTime = True 
currIdx = 0
startToAdd = ""
endToAdd = ""
with open(filepath) as f:  
   for line in f:
        # print(line.strip())
        line = line.strip('\n')
        if line == '':
            continue
        m = re.findall(r"(\d:\d{2}:\d{2}\.\d{3})", line)
        if m:
            startToAdd = m[0]
            endToAdd = m[1]

            if firstTime:
                data["data"][0]["start"] = ts2seconds(startToAdd)
                data["data"][0]["end"] = ts2seconds(endToAdd)
                data["data"][0]["str"] = ""
            else:
                data["data"].append({
                        "start": ts2seconds(startToAdd),
                        "end": ts2seconds(endToAdd),
                        "str": "",
                    })
                currIdx += 1

        else:
            if data["data"][currIdx]["str"] == "":
                data["data"][currIdx]["str"] = line
            else:
                data["data"][currIdx]["str"] = data["data"][currIdx]["str"] + "\n" + line
        
        firstTime = False

with open('assets/subs.json', 'w') as outfile:
    json.dump(data, outfile, indent = 4, ensure_ascii=False)
