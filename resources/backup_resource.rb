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

class Chef
  class Resource
    class Backup < Chef::Resource

     def initialize(name, collection=nil, node=nil)
        super(name, collection, node)
        @resource_name = :backup      
        @provider_type = nil
        @mount_point = nil
        @data_dir = nil
        @restore_dir = nil
        @file_list = []
        @storage_resource_name = nil
        @lineage = nil
        @allowed_actions.push(:prepare_backup, :backup, :cleanup_backup, :restore)
      end

      def mount_point(arg=nil)
        set_or_return(
          :mount_point,
          arg,
          :kind_of => [ String ]
        )
      end
     
      def data_dir(arg=nil)
        set_or_return(
          :data_dir,
          arg,
          :kind_of => [ String ]
        )
      end
      
      def restore_dir(arg=nil)
        set_or_return(
          :restore_dir,
          arg,
          :kind_of => [ String ]
        )
      end
      
      def file_list(arg=nil)
        set_or_return(
          :file_list,
          arg,
          :kind_of => [ String ]
        )
      end
            
      def storage_resource_name(arg=nil)
        set_or_return(
          :storage_resource_name,
          arg,
          { :kind_of => [ String ], :required => true }
        )
      end
      
      def lineage(arg=nil)
        set_or_return(
          :lineage,
          arg,
          :kind_of => [ String ]
        )
      end
      
      def provider_type(arg=nil)
        set_or_return(
            :provider_type,
            arg,
          { :equal_to => [ "LVM" ], :required => true }
        )
      	ptypes = { "LVM" => Chef::Provider::Backup::LVMROS }
      	provider ptypes[@provider_type]
      end

    end
  end
end

Chef::Platform.platforms[:default].merge!(:backup => Chef::Provider::Backup::LVMROS)