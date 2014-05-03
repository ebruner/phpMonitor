class ErrorMonitor
   @@previous_size=0

   def initialize()
       @@previous_size=%x{wc -l #{'/var/log/apache2/error.log'}}.split.first.to_i
   end

   def process
	   new_size = %x{wc -l #{'/var/log/apache2/error.log'}}.split.first.to_i
	   if new_size > @@previous_size
	      for i in @@previous_size..new_size
		tmp = IO.readlines('/var/log/apache2/error.log')[i]
	         %x(notify-send '#{tmp}') 
	      end
           end

	   @@previous_size= %x{wc -l #{'/var/log/apache2/error.log'}}.split.first.to_i
   end
end


# main execution
em = ErrorMonitor.new()
while true
	em.process
	sleep 5
end
