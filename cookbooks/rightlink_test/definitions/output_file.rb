
define :output_file do
  
ruby_block "Output Values" do
  block do
    filename = params[:name]
    raise "ERROR: you must specify a filename for output_file definition." unless filename
    ::File.open(filename) do |infile| 
      while (line = infile.gets) 
        Chef::Log.info(line) 
      end 
    end
  end
end

end