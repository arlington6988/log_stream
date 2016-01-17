class StreamController < ApplicationController
     include ActionController::Live



    def stream
        old_last = "first"
	old_number_of_lines = 0
	response.header['Content-Type'] = 'text/event'
	#100.times {
	while `ps -ef | grep 9472 | grep -v grep` != "" do
          number_of_lines = `wc -l /home/jjones2/filetail.txt | awk -F" " '{print $1}'`
	  if old_last == "first"
	    last_line = File.open('/home/jjones2/filetail.txt') { |f| f.read }
	  else
	    n = number_of_lines.to_i - old_number_of_lines.to_i 
	    last_line = `tail -"#{n}" /home/jjones2/filetail.txt`
	  end
	  if old_last == last_line 
		  write_line = ""
	  else
        	  write_line = "#{last_line}"
	  end
       	  response.stream.write "#{write_line}" 
	  old_last = last_line 
	  old_number_of_lines = number_of_lines
	  sleep 1
        end	
     ensure 
	response.stream.close
     end
end
