class StreamController < ApplicationController
     include ActionController::Live



    def stream(pid, logfile)
        old_last = "first"
	old_number_of_lines = 0
	response.header['Content-Type'] = 'text/event'
	#100.times {
	while `ps -ef | grep #{pid} | grep -v grep` != "" do
          number_of_lines = `wc -l #{logfile} | awk -F" " '{print $1}'`
	  if old_last == "first"
	    last_line = File.open(logfile) { |f| f.read }
	  else
	    n = number_of_lines.to_i - old_number_of_lines.to_i 
	    last_line = `tail -"#{n}" #{logfile}`
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
