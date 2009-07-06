#
# Cookbook Name:: auth_ssh
# Attributes:: default
#
# Copyright 2009, RightScale, Inc.
#

#
# Default attributes
#
ssh Mash.new unless attribute?("ssh")
ssh[:dir] = "/root/.ssh" unless ssh.has_key?(:dir)
ssh[:config_dir] = "#{ssh[:dir]}/config.d" unless ssh.has_key?(:config_dir)
ssh[:keyfile] = "#{ssh[:dir]}/id_rsa" unless ssh.has_key?(:keyfile)

