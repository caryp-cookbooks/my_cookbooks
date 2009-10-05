
apache_module "proxy_http"

web_app "rightscale-reverse-proxy.vhost" do
  template "rightscale-reverse-proxy.vhost.erb"
end

