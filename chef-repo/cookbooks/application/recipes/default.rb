#
# Cookbook Name:: application
# Recipe:: default
#
# Copyright 2017, Lakshmi Mahabaleshwara
#
# All rights reserved - Do Not Redistribute
#
# Reference from  http://mswiderski.blogspot.se/2015/10/installing-kie-server-and-workbench-on.html
tmp_path = Chef::Config[:file_cache_path]

#Download tomcat archive
remote_file "#{tmp_path}/tomcat8.tar.gz" do
  source node['application']['tomcat8']['download_url']
  owner node['application']['tomcat8']['tomcat_user']
  mode '0644'
  action :create
end

#create tomcat install dir
directory node['application']['tomcat8']['install_location'] do
  owner node['application']['tomcat8']['tomcat_user']
  mode '0755'
  action :create
end

#Extract the tomcat archive to the install location
bash 'Extract tomcat archive' do
  user node['application']['tomcat8']['tomcat_user']
  cwd node['application']['tomcat8']['install_location']
  code <<-EOH
    tar -zxvf #{tmp_path}/tomcat8.tar.gz --strip 1
  EOH
  action :run
end

#Install server.xml from template
template "#{node['application']['tomcat8']['install_location']}/conf/server.xml" do
  source 'server.xml.erb'
  owner node['application']['tomcat8']['tomcat_user']
  mode '0644'
end

# Deploy setenv.sh
template "#{node['application']['tomcat8']['install_location']}/bin/setenv.sh" do
  source 'setenv.sh.erb'
  owner node['application']['tomcat8']['tomcat_user']
  mode '0644'
end

# Deploy kie server specific property files
template "#{node['application']['tomcat8']['install_location']}/conf/btm-config.properties" do
  source "btm-config.properties.erb"
  owner node['application']['tomcat8']['tomcat_user']
  mode '0644'
end

template "#{node['application']['tomcat8']['install_location']}/conf/resources.properties" do
  source "resources.properties.erb"
  owner node['application']['tomcat8']['tomcat_user']
  mode '0644'
end

template "#{node['application']['tomcat8']['install_location']}/conf/tomcat-users.xml" do
  source "tomcat-users.xml.erb"
  owner node['application']['tomcat8']['tomcat_user']
  mode '0644'
end

# Deploy kie web war file
remote_file "#{node['application']['tomcat8']['install_location']}/webapps/kie-wb.war" do
  source "http://repo1.maven.org/maven2/org/kie/kie-wb-distribution-wars/6.4.0.Final/kie-wb-distribution-wars-6.4.0.Final-tomcat7.war"
  owner node['application']['tomcat8']['tomcat_user']
  mode '0644'
end

# Deploy kie server war file
remote_file "#{node['application']['tomcat8']['install_location']}/webapps/kie-server.war" do
  source "http://repo1.maven.org/maven2/org/kie/server/kie-server/6.4.0.Final/kie-server-6.4.0.Final-webc.war"
  owner node['application']['tomcat8']['tomcat_user']
  mode '0644'
end

package 'unzip' do
  action :install
end

# download kie jars into tomcat lib folder. This jar files gets download in the chef-repo pom.xml and copied to cookbooks
# files default folder during runtime in assembly.xml
remote_directory "#{node['application']['tomcat8']['install_location']}/lib" do
  source 'tomcat_kie_lib'
  files_owner node['application']['tomcat8']['tomcat_user']
  files_group node['application']['tomcat8']['tomcat_user']
  files_mode '0644'
  action :create
  recursive true
end

# stop tomcat if  running
execute 'stop-tomcat' do
  command "#{node['application']['tomcat8']['install_location']}/bin/shutdown.sh"
  action :run
end

# start tomcat if not running
execute 'start-tomcat' do
  command "#{node['application']['tomcat8']['install_location']}/bin/startup.sh"
  action :run
end