
define :do_mysqldump_restore,  url => nil, branch => 'master', user => nil, credentials => nil, file_path => nil, schema_name => nil, tmp_dir => '/tmp' do

  repo_params = params # see http://tickets.opscode.com/browse/CHEF-422
  
  dir = "#{params[:tmp_dir]}/do_mysqldump_restore"
  dumpfile = "#{dir}/#{params[:file_path]}"
  schema_name = params[:schema_name]

  log "dir: #{dir}"
  log "tmp_dir: #{params[:tmp_dir]}"

  # grab mysqldump file from remote repository
  repo_git_pull "Get mysqldump from git repository" do
    url repo_params[:url]
    branch repo_params[:branch] 
    user repo_params[:user]
    dest dir
    cred repo_params[:credentials]
  end

  bash "unpack mysqldump file: #{dumpfile}" do
    user "root"
    cwd dir
    code <<-EOH
      set -e
      if [ ! -f #{dumpfile} ] 
      then 
        echo "ERROR: MySQL dumpfile not found! File: '#{dumpfile}'" 
        exit 1
      fi 
      mysqladmin -u root create #{schema_name}
      gunzip < #{dumpfile} | mysql -u root #{schema_name}
    EOH
  end

end
