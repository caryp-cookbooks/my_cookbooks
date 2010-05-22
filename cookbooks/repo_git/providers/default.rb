#
# Cookbook Name:: repo_git
# Provider:: repo_git
#
# Copyright (c) 2020 RightScale Inc
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

action :nothing do
  store_resource(new_resource)
end

action :pull do
 
 Chef::Log.info "Running repo_git::do_pull..."
 
  # add ssh key and exec script
  keyfile = nil
  keyname = new_resource.ssh_key
  if "#{keyname}" != ""
    keyfile = "/tmp/gitkey"
    bash 'create_temp_git_ssh_key' do
      code <<-EOH
        echo -n '#{keyname}' > #{keyfile}
        chmod 700 #{keyfile}
        echo 'exec ssh -oStrictHostKeyChecking=no -i #{keyfile} "$@"' > #{keyfile}.sh
        chmod +x #{keyfile}.sh
      EOH
    end
  end 

  # pull repo (if exist)
  ruby_block "pull-exsiting-local-repo" do
    only_if do ::File.directory?(new_resource.destination) end
    block do
      Dir.chdir new_resource.destination
      puts "Updating existing repo at #{new_resource.destination}"
      ENV["GIT_SSH"] = "#{keyfile}.sh" unless ("#{keyfile}" == "")
      puts `git pull` 
    end
  end

  # clone repo (if not exist)
  ruby_block "create-new-local-repo" do
    not_if do ::File.directory?(new_resource.destination) end
    block do
      puts "Creating new repo at #{new_resource.destination}"
      ENV["GIT_SSH"] = "#{keyfile}.sh" unless ("#{keyfile}" == "")
      puts `git clone #{new_resource.repository} -- #{new_resource.destination}`
      branch = new_resource.revision
      if "#{branch}" != "master" 
        dir = "#{new_resource.destination}"
        Dir.chdir(dir) 
        puts `git checkout --track -b #{branch} origin/#{branch}`
      end
    end
  end

  # delete SSH key & clear GIT_SSH
  if keyfile != nil
     bash 'delete_temp_git_ssh_key' do
       code <<-EOH
         rm -f #{keyfile}
         rm -f #{keyfile}.sh
       EOH
     end
  end
 
end

def store_resource(resource)
  resource_copy = resource.clone
  
  # create parent hash if missing
  @node[:resource_store] = Hash.new unless @node[:resource_store]
  
  # don't serialize node
  resource_copy.instance_eval("@node = nil")
  
  Chef::Log.info "CKP: serialzed #{resource} resource: #{resource_copy.inspect}"
  
  # serialize resource to node
  serialized = resource_copy.to_json
  Chef::Log.info "CKP: serialzed #{resource} resource: #{serialized}"
  @node[:resource_store][resource_copy.name] = serialized
  Chef::Log.info("Resource persisted in node as @node[:resource_store][#{resource.name}]")
  
  r = load_resource(resource_copy.name)
  p = r.provider.new(@node, r)
  
  
  true
end

def load_resource(name)
  resource = JSON.parse(@node[:resource_store][name])
  Chef::Log.info "CKP: unserialzed #{resource} resource: #{resource.inspect}" if @node[:resource_store] && @node[:resource_store][name] 
  Chef::Log.info("Resource loaded from @node[:resource_store][#{name}]") if resource
  
  # add node
  current_node = @node
  resource.instance_eval { @node = current_node }
  
  # constantize provider string
  resource.provider = to_const(resource.provider) if resource.provider.is_a?(String)
  
  resource
end

# Convert constant name to constant
#
#    "FooBar::Baz".to_const => FooBar::Baz
#
# @return [Constant] Constant corresponding to given name or nil if no
#   constant with that name exists
#
# @api public
def to_const(class_name)
  names = class_name.split('::')
  names.shift if names.empty? || names.first.empty?

  constant = Object
  names.each do |name|
    # modified to return nil instead of raising an const_missing error
    constant = constant && constant.const_defined?(name) ? constant.const_get(name) : nil
  end
  constant
end


