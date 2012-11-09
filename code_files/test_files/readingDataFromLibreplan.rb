 require 'open-uri'

 (1..4).each do |i|
 	puts "#{i}"
 puts open("http://172.16.17.18:8080/libreplan/ws/rest/resources/WORKER000"+"#{i}", :http_basic_authentication=>["wsreader", "wsreader"]){ |f| f.read }
 end	