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

require "rubygems"
require "right_rackspace"

class Chef
  class Provider
    class RemoteStorageCloudFiles < Chef::Provider

      def load_current_resource
        true
      end

      def action_get
        Chef::Log.debug "action_get: get #{@new_resource.object_name} from #{@new_resource.container} to the file #{@new_resource.name}"
        get_file(get_or_create_interface, @new_resource.container, @new_resource.object_name, @new_resource.name)
        true
      end
      
      def action_put
        Chef::Log.debug "action_get: put #{@new_resource.object_name} to #{@new_resource.container} from the file #{@new_resource.name}"
        put_file(get_or_create_interface, @new_resource.container, @new_resource.object_name, @new_resource.name)
        true
      end
      
      def action_delete
        Chef::Log.debug "action_delete: put #{@new_resource.object_name} from #{@new_resource.container}"
        delete_file(get_or_create_interface, @new_resource.container, @new_resource.object_name)
        true
      end
      
      def action_create_container
        Chef::Log.debug "action_create_container: #{@new_resource.container}"
        create_container(get_or_create_interface, @new_resource.container)
        true
      end
      
      def action_delete_container
        Chef::Log.debug "action_delete_container: #{@new_resource.container}"
        delete_container(get_or_create_interface, @new_resource.container)
        true
      end

      def login
        Chef::Log.debug "action:login #{@new_resource.name}"
        interface = Rightscale::Rackspace::CloudFilesInterface::new(@new_resource.user, @new_resource.key, {}) 
        ObjectRegistry.register(@node, "#{@new_resource.name}_interface", interface)
        ObjectRegistry.register(@node, @new_resource.name, @new_resource)
        ObjectRegistry.register(@node, "#{@new_resource.name}_provider", self)
        true
      end

      def find_latest_backup(container, file_prefix, override=nil)
        file_prefix += override unless override.nil?
        all_result = get_or_create_interface.incrementally_list_objects(container)
# prefix is not supported by rackspace. need to sort by hand or use rackspaces 'directories' support
        result = all_result.select { |r| r['name'] =~ /^#{file_prefix}.*\.info/ }
        result.sort! { |a,b| b['last_modified'] <=> a['last_modified'] }
        latest_key = result[0]
        found_name = latest_key['name'].gsub(/\.info$/,'')
        Chef::Log.info "Found Latest Backup: #{found_name}"
        return found_name
      end
      
     
    private
          
      def get_or_create_interface
        interface = ObjectRegistry.lookup(@node, "#{@new_resource.name}_interface")
        unless interface
          login
          interface = ObjectRegistry.lookup(@node, "#{@new_resource.name}_interface")
        end
        interface
      end
      
      def get_file(interface, container, object_name, destination_file)
        file = ::File.new(destination_file, ::File::CREAT|::File::RDWR)
        interface.get_object(container, object_name) do |chunk|
          file.write(chunk)
        end
        file.close
      end
          
      def put_file(interface, container, object_name, source_file)
        interface.put_object(container, object_name,  ::IO.read(source_file))
      end
      
      def delete_file(interface, container, object_name)
        interface.delete_object(container, object_name)
      end
      
      def create_container(interface, container)
        interface.create_container(container)
      end
      
      def delete_container(interface, container)
        interface.delete_container(container)
      end
    
    end
  end
end


