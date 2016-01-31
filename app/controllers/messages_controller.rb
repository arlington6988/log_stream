class MessagesController < ApplicationController


    def index
    end
    
    def streamfire
     system("ruby public/system/rubyecho.rb >> log/streamtest.log &")
     pid =exec("pidof ruby")
     puts pid
     redirect_to stream_stream_path(:pid => pid, :logfile => "log/streamtest.log")
    end

end
