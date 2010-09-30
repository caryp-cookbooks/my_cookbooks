
kiwi_dir = "/mnt/kiwi" 
   
directory kiwi_dir  do
  recursive true
  action :delete
end

directory "#{kiwi_dir}/root" do
  recursive true
  action :create
end

%{include linuxrc preinit}.each do |t| 
  template "#{kiwi_dir}/root/#{t}" do 
    source "#{t}.erb"
  end
end

