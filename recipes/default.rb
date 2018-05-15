#
# Author:: Kyle Evans (<kylebe@gmail.com)
# Cookbook Name:: kbe_ddg_search
# Recipe:: default
# Copyright Holder:: Kyle Evans
# Copyright Holder Email:: kylebe@gmail.com
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'kbe_role_ubuntu_1604_base'
include_recipe 'kbe_nginx'

template '/var/www/ddgsearch.pl' do
  source 'ddgsearch.pl.erb'
  owner 'root'
  group 'www-data'
  mode '0750'
end

execute 'ddg_search_app' do
  command 'uwsgi --socket 127.0.0.1:3031 --psgi /var/www/ddgsearch.pl'
  not_if 'ps auxww | grep ddgsearch.pl'
end