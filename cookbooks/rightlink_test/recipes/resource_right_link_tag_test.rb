#
# Cookbook Name:: remote_recipe
# Recipe:: do_tag_test
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
COLLECTION_NAME = "tag_test"
TAG = "test:foo=bar"

log "Add tag: #{TAG}"
right_link_tag "#{TAG}"

log "Verify tag exists"
server_collection COLLECTION_NAME do
  tags [ TAG ]
end

ruby_block "tags exists?" do
  block do
    h = node[:server_collection][COLLECTION_NAME]
    tags = h[h.keys[0]]
    result = []
    if tags
      result = tags.select { |s| s =~ /#{TAG}/ }
    end
    raise "ERROR: right_link_tag resource failed to add tag." if result.empty?
    Chef::Log.info "#{TAG} tag added."
  end
end

log "Remove tag: #{TAG}"
right_link_tag "test:foo=bar" do
  action :remove
end

log "Verify tag is gone"
server_collection COLLECTION_NAME do
  tags [ TAG ]
end
  
ruby_block "tags gone?" do
  block do
    require 'timeout'
    
    TIMEOUT_SEC = 4 * 60 # 4min
    resrc = Chef::Resource::ServerCollection.new(COLLECTION_NAME)
    resrc.tags [ TAG ]
    provider = Chef::Provider::ServerCollection.new(node, resrc)
    tags = ["bogus_seed"]
    
    begin
      status = Timeout::timeout(TIMEOUT_SEC) do
        until tags == nil
          provider.send("action_load")
          h = node[:server_collection][COLLECTION_NAME]
          tags = h[h.keys[0]]
          unless tags
            sleep 10
            Chef::Log.info "  Tag still exists.  Retry..."
          end
        end
      end
    rescue Timeout::Error => e
      raise "ERROR: right_link_tag resource failed to remove a tag after #{TIMEOUT_SEC/60} minutes."
    end
    Chef::Log.info "#{TAG} tag removed."
  end
end
