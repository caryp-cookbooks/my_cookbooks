rails Mash.new unless attribute?("rails")
rails[:code] = Mash.new unless rails.has_key?("code")

#
# Required
#
rails[:code][:url] = false            unless rails[:code].has_key?(:url)
rails[:code][:user] =  false          unless rails[:code].has_key?(:user)
rails[:code][:credentials] = false    unless rails[:code].has_key?(:credentials)

#
# Recommended
#
rails[:server_name] = "myserver"       unless rails.has_key?(:server_name)
rails[:application_name] = "myapp"     unless rails.has_key?(:application_name)
rails[:env] = "production"             unless rails.has_key?(:env)

#
# Optional
#
rails[:code][:destination] = "/home/wepapp/#{rails[:application_name]}" unless rails[:code].has_key?(:dest)
rails[:code][:branch] = "master" unless rails[:code].has_key?(:branch)
rails[:application_port] = "8000"      unless rails.has_key?(:application_port)

#
# Overrides
#
# default apache is worker model -- use prefork for single thread
apache Mash.new unless attribute?("apache")
apache[:mpm] = "prefork"             unless apache.has_key?(:mpm)



