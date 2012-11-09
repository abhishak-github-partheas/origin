import json
from urllib import urlopen
 
def getPage():
    url="http://localhost:2003"
    return  urlopen(url).read()
 
employees_info = getPage()
print employees_info
# employees_info={
#  "employees": [
#  { "username":"John" , "earned":5 ,"taken" : 7 , "remaining":2},
#  { "username":"Anna" , "earned":5 ,"taken" : 7 , "remaining":2 },
#  { "username":"Peter" , "earned":5 ,"taken" : 7 , "remaining":2 }
#  ]
#  }
print("<html><head><tite>fun.......hohoho </title></head><body>")
print('''<table>
            <tr>
                <td><b>Emplayee Name</td>
                <td><b>Holidays Earned</td>
                <td><b>Holidays Taken</td>
                <td><b>Remaining Holidays</td>
            </tr>
     ''')
for employee in employees_info["employees"]: 
    print("<tr>")
    print ("<td><font color='red'>"  + str( employee["username"] )+ " </font></td>")  
    print ("<td><font color='red'>"  + str( employee["earned"]) + " </font></td>") 
    print ("<td><font color='red'>"  + str(employee["taken"] )+ " </font></td>") 
    print ("<td><font color='red'>"  + str(employee["remaining"]) + " </font></td>") 
    print("</tr>")

print("</table></body></html>")