#
# Cookbook Name:: remote_recipe
# Recipe:: default
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

right_link_tag "test:ping=sender"

# send ping to receiver
remote_recipe "pong sender" do
  :recipe "ping_pong::do_ping"
  :recipients_tags "test:ping=reciever"
end

