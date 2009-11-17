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

    class RemoteObjectStore < Chef::Resource

     def initialize(name, collection=nil, node=nil)
        super(name, collection, node)
        @resource_name = :remote_object_store
        @user = nil
        @key = nil
        @container = nil
        @object_name = nil    
        @provider_type = nil
        @allowed_actions.push(:get, :put, :delete, :login)
      end

      def user(arg=nil)
        set_or_return(
          :user,
          arg,
          :kind_of => [ String ]
        )
      end

      def key(arg=nil)
        set_or_return(
          :key,
          arg,
          :kind_of => [ String ]
        )
      end

      def container(arg=nil)
        set_or_return(
          :container,
          arg,
          :kind_of => [ String ]
        )
      end

      def object_name(arg=nil)
        set_or_return(
          :object_name,
          arg,
          :kind_of => [ String ]
        )
      end

      def provider_type(arg=nil)
        set_or_return(
            :provider_type,
            arg,
          { :equal_to => [ "S3", "CloudFiles" ], :required => true }
        )
      	ptypes = { "S3" => Chef::Provider::RemoteObjectStoreS3, "CloudFiles" => Chef::Provider::RemoteObjectStoreCloudFiles}
      	provider ptypes[@provider_type]
      end

    end
    
  end
end

Chef::Platform.platforms[:default].merge!(:remote_object_store => Chef::Provider::RemoteObjectStoreS3)

