
directory node[:rightimage][:build_dir] do 
  action :delete
  recursive true
end


directory node[:rightimage][:mount_dir] do 
  action :delete
  recursive true
end
