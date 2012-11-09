class HW    
  def call(env)  
    [200,{"Content-Type"=> "text/html"},StringIO.new(env.inspect) ]
  end  
end  
run HW.new