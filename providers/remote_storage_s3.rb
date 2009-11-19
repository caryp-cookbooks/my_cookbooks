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
require "right_aws"

class Chef
  class Provider
    class RemoteStorageS3 < Chef::Provider

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

      def find_latest_backup(bucket, file_prefix, override=nil)
        file_prefix += override unless override.nil?
        all_bucket_keys = []
        interface = get_or_create_interface
        interface.incrementally_list_bucket(s3bucket, { :marker => "", :prefix => file_prefix }) do |res|
          all_bucket_keys += res[:contents]
        end

        # only use backups with .info (valid backups)
        selected_keys = all_bucket_keys.select { |hsh| hsh[:key] =~ /\.info$/ }
        selected_keys.sort! { |a,b| b[:last_modified] <=> a[:last_modified] }
        latest_key = selected_keys[0]
        latest_key.gsub!(/\.info$/,'')
      end

      def login
        Chef::Log.debug "action:login #{@new_resource.name}"
        interface = RightAws::S3Interface.new( @new_resource.user, @new_resource.key, {} )
        ObjectRegistry.register(@node, "#{@new_resource.name}_interface", interface)
        ObjectRegistry.register(@node, @new_resource.name, @new_resource)
        ObjectRegistry.register(@node, "#{@new_resource.name}_provider", self)
        true
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
      
      def get_file(interface, bucket, object_name, destination_file)
        file = ::File.new(destination_file, ::File::CREAT|::File::RDWR)
        interface.get(bucket, object_name) do |chunk|
          file.write(chunk)
        end
        file.close
      end
          
      def put_file(interface, bucket, object_name, source_file)
        interface.put(bucket, object_name,  ::File.open(source_file))
      end
      
      def delete_file(interface, bucket, object_name)
        interface.delete(bucket, object_name)
      end
      
      def create_container(interface, container)
        interface.create_bucket(container)
      end
      
      def delete_container(interface, container)
        interface.delete_bucket(container)
      end
    
    end
  end
end


