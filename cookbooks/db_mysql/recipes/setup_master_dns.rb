# configure master DB DNS record 
Chef::Log.info "Configuring DNS for ID: #{node[:dns][:master_id]} -> #{node[:cloud][:private_ip][0]}"
dns node[:dns][:master_id] do
  user node[:dns][:user]
  passwd node[:dns][:password]
  ip_address node[:cloud][:private_ip][0]
end
