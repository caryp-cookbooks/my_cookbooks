server_collection "master_servers" do
  tags [ "rs_dbrepl:" ]
end

ruby_block "display tags" do
  block do
    Chef::Log.info "Displaying Tags..."
    node[:server_collection][:master_servers].each do |ms|
      Chef::Log.info "FOUND TAG: #{ms.inspect}"
    end
    raise "NOT ENOUGH TAGS FOUND #{node[:server_collection][:master_servers].size}" unless node[:server_collection][:master_servers].size > 0
  end
end
