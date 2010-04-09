#
# Cookbook Name:: repo
# Provider:: repo
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

require 'chef/mixin/convert_to_class_name'

action :pull do
  
  # does the named provider exist in collection?
  begin
 #   Chef::Log.info("looking for name #{new_resource.name} in collection #{new_resource.collection.inspect}")
    resource = new_resource.collection.lookup(new_resource.name)
    provider = resource.provider if resource
  rescue ArgumentError
    Chef::Log.info("No resource found in collection named #{new_resource.name}.")
  end
  
  # provider = load_provider_from_node(new_resource.name)  
  unless provider then
    # create named provider from node or databag
    repo_bag = node[:repo]
    raise("ERROR: unable to find resource named '#{new_resource.name}' in collection or node.") unless repo_bag

    repo_bag.each do |name, data|
      if name == new_resource.name then
        pname = data[:provider]
        raise("ERROR: you must specify :provider in your resource data.") unless pname
        class_name = convert_to_class_name(pname)
        provider_klass = Chef::Provider.const_get(class_name)
        provider = provider_klass.new(new_resource.node, new_resource, new_resource.collection)
        provider.load_current_resource
        Chef::Log.info("Loaded data from node into #{provider_klass}")
        break;
      end
    end
  end
  
  raise ("ERROR: no provider named '#{new_resource.name}' found for repo resource.") unless provider
  provider.action_pull()

end