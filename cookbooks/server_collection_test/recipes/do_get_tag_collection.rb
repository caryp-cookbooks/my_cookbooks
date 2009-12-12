server_collection "master_servers" do
  tags [ "db:master*" ]
end

ruby_block "display tags" do
  block do
    Chef::Log.info "Displaying Tags..."
    node[:server_collection]['master_servers'].each do |ms|
      Chef::Log.info "FOUND TAG: #{ms.inspect}"
    end
  end
end
