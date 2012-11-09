import json
import urllib2

#Socket client example in python

import socket	#for sockets
import sys	#for exit

#create an INET, STREAMing socket
try:
	s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
except socket.error:
	print 'Failed to create socket'
	sys.exit()
	
print 'Socket Created'

host = 'localhost';
port = 2005;

try:
	remote_ip = socket.gethostbyname( host )

except socket.gaierror:
	#could not resolve
	print 'Hostname could not be resolved. Exiting'
	sys.exit()

#Connect to remote server
s.connect((remote_ip , port))

print 'Socket Connected to ' + host + ' on ip ' + remote_ip

#Send some data to remote server
message = "GET / HTTP/1.1\r\n\r\n"

try :
	#Set the whole string
	s.sendall(message)
except socket.error:
	#Send failed
	print 'Send failed'
	sys.exit()

print 'Message send successfully'

#Now receive data
employees_info= json.loads(s.recv(4096))
print employees_info
print("<html><head><title>fun.......hohoho </title></head><body>")
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