#
# Cookbook Name:: repo_svn
# Provider:: repo_svn
#
# Copyright (c) 2009 RightScale Inc
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

action :create do
  # place named resource in resource collection 
end

action :pull do
 
  Chef::Log.info "Running repo_svn::do_pull..."

  # setup parameters 
  password = node[:svn][new_resource.name][:password]
  revision = node[:svn][new_resource.name][:revision]
  params = "--no-auth-cache --non-interactive"
  params << " --username #{node[:svn][new_resource.name][:username]} --password #{password}" if "#{password}" != ""
  params << " --revision #{revision}" if "#{revision}" != ""

  # pull repo (if exist)
  ruby_block "pull-exsiting-local-repo" do
    only_if do ::File.directory?(new_resource.destination) end
    block do
      Dir.chdir new_resource.destination
      puts "Updateing existing repo at #{new_resource.destination}"
      puts `svn update #{params} #{node[:svn][new_resource.name][:repository]} #{new_resource.destination}` 
    end
  end

  # clone repo (if not exist)
  ruby_block "create-new-local-repo" do
    not_if do ::File.directory?(new_resource.destination) end
    block do
      puts "Creating new repo at #{new_resource.destination}"
      puts `svn checkout #{params} #{node[:svn][new_resource.name][:repository]} #{new_resource.destination}`
    end
  end
 
end
