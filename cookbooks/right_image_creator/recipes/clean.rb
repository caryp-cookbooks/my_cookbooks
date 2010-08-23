
directory node[:right_image_creator][:build_dir] do 
  action :delete
  recursive true
end


directory node[:right_image_creator][:mount_dir] do 
  action :delete
  recursive true
end
