import json
import sys

f = open(sys.argv[1], 'r')
data = f.read()

dict = json.loads(data)
print(dict)
