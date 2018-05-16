#
# Author:: Kyle Evans (<kylebe@gmail.com)
# Cookbook Name:: kbe_ddg_search
# Recipe:: default
# Copyright Holder:: Kyle Evans
# Copyright Holder Email:: kylebe@gmail.com
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'kbe_role_ubuntu_1604_base'
include_recipe 'kbe_perl'
include_recipe 'kbe_nginx'

template '/var/www/ddgsearch.pl' do
  source 'ddgsearch.pl.erb'
  owner 'root'
  group 'www-data'
  mode '0750'
  notifies :reload, 'execute[restart_uwsgi]'
end

execute 'ddg_search_app' do
  command 'uwsgi --plugins psgi --socket 127.0.0.1:3031 --psgi /var/www/ddgsearch.pl --master --logger syslog:uwsgi --pidfile /run/uwsgi.pid &'
  not_if "ps auxww | grep -v grep | grep 'uwsgi --plugins psgi --socket 127.0.0.1:3031 --psgi /var/www/ddgsearch.pl --master'"
  notifies :reload, 'service[nginx]'
end

execute 'restart_uwsgi' do
  command 'kill -HUP $(cat /run/uwsgi.pid)'
  only_if "ps auxww | grep -v grep | grep 'uwsgi --plugins psgi'"
  action :nothing
end

