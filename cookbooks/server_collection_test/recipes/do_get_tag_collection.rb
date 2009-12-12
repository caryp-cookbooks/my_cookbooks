server_collection "master_servers" do
  tags [ "db:master*" ]
end

ruby_block "display tags" do
  block do
    node[:server_collection][:master_servers].each do |ms|
      Chef::Log.info "FOUND: #{ms.inspect}"
    end
  end
end
