#
# Cookbook Name:: virtual_monkey
# Recipe:: default
#
# Copyright 2010, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
["postfix", "mutt", "mailutils"].each { |p| package p }

include_recipe "virtual_monkey::setup_apptest_database"
include_recipe "virtual_monkey::update_test_code"
include_recipe "virtual_monkey::do_tests"
