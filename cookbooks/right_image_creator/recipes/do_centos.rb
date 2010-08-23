#
# Cookbook Name:: right_image_creator
# Recipe:: default
#
# Copyright 2010, Example Com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

node[:right_image_creator][:host_packages].each { |p| package p }

include_recipe "right_image_creator::clean"
include_recipe "right_image_creator::bootstrap_centos"
include_recipe "right_image_creator::install_rightscale"
