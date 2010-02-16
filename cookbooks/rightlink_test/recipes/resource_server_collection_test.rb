COLLECTION_NAME = "server_tags"
TAG = "rightlink:test="
TAG_COUNT = 10

TAG_COUNT.times do |n|
  my_tag = "#{TAG}resource_server_collection_#{n}"
  log "Tagging server with #{my_tag}"
  right_link_tag my_tag
end

server_collection COLLECTION_NAME do
  tags [ TAG ]
end

ruby_block "display tags" do
  block do
    Chef::Log.info "Displaying Tags..."
    h = node[:server_collection][COLLECTION_NAME]
    tags = h[h.keys[0]]
    Chef::Log.info "tags:#{tags.inspect}"
    result = tags.select { |s| s =~ /#{TAG}/ }
    result.each do |t|
      Chef::Log.info "FOUND TAG: #{t}"
    end    
    raise "FAIL: Unexpected number of tags found.  Expected #{TAG_COUNT}. Found #{result.size}." unless result.size == TAG_COUNT
  end
end
