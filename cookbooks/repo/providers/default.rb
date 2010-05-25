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

action :nothing do
  store_resource(new_resource)
end

action :pull do
  abstract_resource = new_resource
  
  # Lookup concrete resource/provider
  resource = lookup_concrete_resource(abstract_resource)
  
  # Load the provider
  provider = resource.provider.new(resource.node, resource, resource.collection)
  provider.load_current_resource
  Chef::Log.info("Loaded resource into #{resource.provider}")
  provider.action_pull()
  
  # Persist resource to node.
  store_resource(resource)
end

###########################
# Persistent Resource Study

def lookup_concrete_resource(abstract_resource)
  # Does the named provider exist in collection?
  Chef::Log.info("looking for #{abstract_resource.to_s} in collection")
  
  Chef::Log.info ("CKP: before lookup")
  # Find the resource before this one in the collection
  resources = abstract_resource.resources(abstract_resource.to_s)
  Chef::Log.info ("CKP: after lookup.")
  Chef::Log.info ("CKP: after lookup2. #{resources.to_s}")
  Chef::Log.info ("CKP: after lookup3.")
   
  resource = resources[resources.length-1] if resources && resources.is_a?(Array)
  Chef::Log.info("Found #{abstract_resource.to_s} in resource collection! ptype:#{resource.provider}") if resource
     
  # # If not, look in the node for a serialzed resource from a previous converge
  #   unless resource
  #     Chef::Log.info("#{abstract_resource.to_s} not found in resource collection! Looking in node...")  
  #     resource = load_resource(abstract_resource.name)  
  #     Chef::Log.info("Found #{abstract_resource.to_s} in node! ptype:#{resource.inspect}") if resource
  #   end
  raise ("No resource found in collection or node named #{abstract_resource.name}.") unless resource
  
  # Merge attributes from abstract resource to concrete resource
  abstract_resource.instance_variables.each do |iv|
    unless iv == "@source_line" || iv == "@action" || iv == "@provider"
     resource.instance_variable_set(iv, abstract_resource.instance_variable_get(iv))
    end
  end
  
  resource
end

def store_resource(resource)
  resource_copy = resource.clone
  
  # create parent hash if missing
  @node[:resource_store] = Hash.new unless @node[:resource_store]
  
  # don't serialize node
  resource_copy.instance_eval("@node = nil")
  
  # serialize resource to node
  serialized = resource_copy.to_json
  @node[:resource_store][resource_copy.name] = serialized
  Chef::Log.info("Resource persisted in node as @node[:resource_store][#{resource.name}]")
  
  r = load_resource(resource_copy.name)
  p = r.provider.new(@node, r)
    
  true
end

def load_resource(name)
  resource = JSON.parse(@node[:resource_store][name])
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
