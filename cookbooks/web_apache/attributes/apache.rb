#
# Cookbook Name:: web_apache
# Attributes:: apache
#
# Copyright 2009, RightScale, Inc.
#

apache Mash.new unless attribute?("apache")

#
# General settings
#
apache[:contact] = "root@localhost" unless apache.has_key?(:contact)
# Turning off Keepalive to prevent conflicting HAproxy
apache[:keepalive] = "Off"          unless apache.has_key?(:keepalive)
# Turn on generation of "full" apache status
apache[:extended_status] = "On"     unless apache.has_key?(:extended_status)
#  worker = multithreaded
#  prefork = single-threaded (use for php)
apache[:mpm] = "worker"             unless apache.has_key?(:mpm)

#
# Security
#
# Configuring Server Signature
apache[:serversignature] = "Off " unless apache.has_key?(:serversignature)


