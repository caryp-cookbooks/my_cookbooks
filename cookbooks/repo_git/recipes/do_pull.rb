include_recipe "repo_git::install_prerequisites"

repo "pull git repository" do
  destination @node[:git][:destination]
  action :pull
  provider "repo_git"
end