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
  
  abstract_resource = new_resource
  
  # Does the named provider exist in collection?
  Chef::Log.info("looking for #{abstract_resource.to_s} in collection")
  # Find the resource before this one in the collection -- maybe look up diff providers with same name?
  curr_resrc = prev_resrc = nil 
  @collection.each do |r|   
    if r.to_s == abstract_resource.to_s then
      Chef::Log.info("resource: #{r}")
      prev_resrc = curr_resrc if curr_resrc
      curr_resrc = r 
    end
  end
  resource = prev_resrc
  Chef::Log.info("Found #{abstract_resource.to_s}in resource collection! ptype:#{resource.provider}") if resource
    
  
  # If not, look in the node for a serialze resource from a previous converge
  ## provider = load_provider_from_node(abstract_resource.name)  
  # unless resource then
  #     # create named provider from node or databag
  #     repo_bag = node[:resource_collection][:repo]
  #     raise("ERROR: unable to find resource named '#{abstract_resource.name}' in collection or node.") unless repo_bag
  # 
  #     repo_bag.each do |name, data|
  #       if name == abstract_resource.name then
  #         pname = data[:provider]
  #         raise("ERROR: you must specify :provider in your resource data.") unless pname
  #         class_name = convert_to_class_name(pname)
  #         provider_klass = Chef::Provider.const_get(class_name)
  #         provider = provider_klass.new(abstract_resource.node, abstract_resource, abstract_resource.collection)
  #         provider.load_current_resource
  #         Chef::Log.info("Loaded data from node into #{provider_klass}")
  #         break;
  #       end
  #     end
  #   end
  
  raise ("No resource found in collection or node named #{abstract_resource.name}.") unless resource   
  
  # Merge attributes from abstract resource to concrete resource
  abstract_resource.instance_variables.each do |iv|
    unless iv == "@source_line" || iv == "@action" || iv == "@provider"
     resource.instance_variable_set(iv, abstract_resource.instance_variable_get(iv))
    end
  end
  
  # Load the provider
  provider = resource.provider.new(resource.node, resource, resource.collection)
  provider.load_current_resource
  Chef::Log.info("Loaded resource into #{resource.provider}")
  provider.action_pull()
  
  ## Persist resource to node.
  # resource.instance_eval("@node = nil")
  # node[:resource_collection][:repo] = resource.to_json

end