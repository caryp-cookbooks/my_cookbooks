define :db_mysql_setup_privileges, preset => "administrator", username => nil, password => nil do

  priv_preset = params[:preset]
  username = params[:username]
  password = params[:password]
  
  ruby "set admin credentials" do
   # environment 'DBADMIN_USER' => username, 'DBADMIN_PASSWORD' => password
    code <<-EOH
      require 'rubygems'
      require 'mysql'

      con = Mysql.new("", "root" )
    
      case '#{priv_preset}'
      when 'administrator'
        con.query("GRANT ALL PRIVILEGES on *.* TO '#{username}'@'%' IDENTIFIED BY '#{password}' WITH GRANT OPTION")
        con.query("GRANT ALL PRIVILEGES on *.* TO '#{username}'@'localhost' IDENTIFIED BY '#{password}' WITH GRANT OPTION")
      when 'user'
        con.query("GRANT ALL PRIVILEGES on *.* TO '#{username}'@'%' IDENTIFIED BY '#{password}'")
        con.query("GRANT ALL PRIVILEGES on *.* TO '#{username}'@'localhost' IDENTIFIED BY '#{password}'")
        con.query("REVOKE SUPER on *.* FROM '#{username}'@'%' IDENTIFIED BY '#{password}'")
        con.query("REVOKE SUPER on *.* FROM '#{username}'@'localhost' IDENTIFIED BY '#{password}'")
      else
        raise "only 'administrator' and 'user' type presets are supported!"
      end
      
      con.query("FLUSH PRIVILEGES")
      con.close
    EOH
  end

end
