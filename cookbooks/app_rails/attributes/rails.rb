rails Mash.new unless attribute?("rails")
rails[:code] = Mash.new unless rails.has_key?("code")

#
# Required
#
rails[:code][:url] = false            unless rails[:code].has_key?(:url)
rails[:code][:user] =  false          unless rails[:code].has_key?(:user)
rails[:code][:credentials] = false    unless rails[:code].has_key?(:credentials)

rails[:db_app_user] = nil   	      unless rails.has_key?(:db_app_user)
rails[:db_app_passwd] = nil           unless rails.has_key?(:db_app_passwd)
rails[:db_schema_name] = nil          unless rails.has_key?(:db_schema_name)
rails[:db_dns_name] = nil             unless rails.has_key?(:db_dns_name)

#
# Recommended
#
rails[:server_name] = "myserver"       unless rails.has_key?(:server_name)
rails[:application_name] = "myapp"     unless rails.has_key?(:application_name)
rails[:env] = "production"             unless rails.has_key?(:env)

#
# Optional
#
rails[:code][:destination] = "/home/webapp/#{rails[:application_name]}" unless rails[:code].has_key?(:dest)
rails[:code][:branch] = "master" unless rails[:code].has_key?(:branch)
rails[:application_port] = "8000"      unless rails.has_key?(:application_port)
rails[:spawn_method] = "conservative"  unless rails.has_key?(:spawn_method)
rails[:gems_list] = [""]  unless rails.has_key?(:gems_list)

#
# Overrides
#
# default apache is worker model -- use prefork for single thread
apache Mash.new unless attribute?("apache")
apache[:mpm] = "prefork"             unless apache.has_key?(:mpm)

if apache.has_key?(:listen_ports)
     apache[:listen_ports] << rails[:application_port]
else
     apache[:listen_ports] = rails[:application_port]
end




