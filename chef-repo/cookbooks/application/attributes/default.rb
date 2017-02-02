#
# Cookbook Name:: application
# Attributes:: default
#
# Copyright 2017, Lakshmi Mahabaleshwara
#

default['application']['tomcat8']['download_url'] = "http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33.tar.gz"
default['application']['tomcat8']['install_location'] = '/usr/local/tomcat'
default['application']['tomcat8']['port'] = 8080
default['application']['tomcat8']['ssl_port'] = 8443
default['application']['tomcat8']['ajp_port'] = 8009
default['application']['tomcat8']['java_options'] = "-Xmx128M"
default['application']['tomcat8']['tomcat_user'] = "root"

# Kie Web and Server Configuration

default['application']['kie-web']=false
default['application']['kie-btm-config']['serverId']='tomcat-btm-node0'
default['application']['kie-resource']['className']='bitronix.tm.resource.jdbc.lrc.LrcXADataSource'
default['application']['kie-resource']['uniqueName']='jdbc/jbpm'
default['application']['kie-resource']['minPoolSize']='10'
default['application']['kie-resource']['maxPoolSize']='20'
default['application']['kie-resource']['driverClassName']='org.h2.Driver'
default['application']['kie-resource']['url']='jdbc:h2:mem:jbpm'
default['application']['kie-resource']['user']='sa'
default['application']['kie-resource']['allowLocalTransactions']=true
default['application']['kie-server']['valveClassName']='org.kie.integration.tomcat.JACCValve'
default['application']['kie-tomcat']['userName']='workbench'
default['application']['kie-tomcat']['password']='workbench1!'
default['application']['kie-server']['controller']='http://localhost:8080/kie-wb/rest/controller'
default['application']['kie-server']['location']='http://localhost:8080/kie-server/services/rest/server'