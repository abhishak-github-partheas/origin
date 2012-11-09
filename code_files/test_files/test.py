#import json
from urllib import urlopen
 
def getPage():
    url="http://localhost:2000"
    return  urlopen(url).read()

employees_info = getPage()
print employees_info