#
# Cookbook Name:: rs_tools
# Recipe:: default
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#


define :rs_tools, :action => :install do
  # Gem requirements
  ["right_aws", "rest-client", "json", "terminator"].each { |p|  gem_package  p }

  directory "/opt/rightscale" do
    recursive true
  end

  toolname=params[:name]
  if params[ :action ] == :install
    remote_file "/opt/rightscale/#{toolname}" do
      source "#{toolname}"
    end

    bash "unpack #{toolname}" do
      user "root"
      cwd "/opt/rightscale"
      code <<-EOH
        tar xzf #{toolname}
        tar -tf #{toolname} | xargs chmod ug+x
      EOH
    end
  end
end
