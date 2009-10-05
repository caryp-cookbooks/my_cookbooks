apache_site "000-default" do
  enable false
end

web_app "http-80-lbhost.vhost" do
  template "http-80-lbhost.vhost.erb"
end

