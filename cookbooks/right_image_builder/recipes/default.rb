#
# Cookbook Name:: right_image_builder
# Recipe:: default
#
# Copyright 2010, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

[ "event_machine", "resat", "json", "right_popen", "rest_connection" ].each { |p| gem_package p }

repo "right_image_builder" do
  destination "~/right_image_builder"
  :pull
end

repo "image_sandbox" do
  destination "~/sandbox_builds"
  :pull
end


