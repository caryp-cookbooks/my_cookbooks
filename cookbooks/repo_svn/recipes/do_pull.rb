include_recipe "repo_svn::install_prerequisites"

repo "pull subversion repository" do
  destination @node[:svn][:destination]
  action :pull
  provider "repo_svn"
end