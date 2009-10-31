
# install subversion client
package "subversion" do
  action :install
end

extra_packages = case node[:platform]
  when "ubuntu","debian"
    if node[:platform_version].to_f < 8.04
      %w{subversion-tools libsvn-core-perl}
    else
      %w{subversion-tools libsvn-perl}
    end
  when "centos","redhat","fedora"
    %w{subversion-devel subversion-perl}
  end

extra_packages.each do |pkg|
  package pkg do
    action :install
  end
end