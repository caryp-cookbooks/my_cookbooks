#
# Cookbook Name:: repo_git
# Attributes:: default
#
# Copyright 2009, RightScale, Inc.
#

#
# Default attributes
#
repo_git Mash.new unless attribute?("repo_git")

repo_git[:branch] = "master" unless repo_git.has_key?(:branch)


