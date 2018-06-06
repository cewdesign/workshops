#
# Cookbook:: tomcat_cb
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
##################################################################### Downloaded Java cookbook from supermarket, added to runlist of node.
#
# Install Java
include_recipe 'java'
#
#
# Create working dir
#
bash 'create_dir' do
    cwd '.'
    code <<-EOH
    mkdir -p '/opt/tomcat'
    EOH
end
#
# Create a group and user for tomcat
group 'tomcat' do
    append true
end
user 'tomcat' do
    gid 'tomcat'
    home '/opt/tomcat'
    manage_home false
    shell '/bin/nologin'
end
#
# Download the Tomcat Binary
remote_file 'apache-tomcat-8.5.31.tar.gz' do
    source 'http://mirror.csclub.uwaterloo.ca/apache/tomcat/tomcat-8/v8.5.31/bin/apache-tomcat-8.5.31.tar.gz'
    path '/tmp/apache-tomcat-8.5.31.tar.gz'
    action :create_if_missing
    mode 00644
end
#
# Expand it
bash 'extract_module' do
    cwd '/opt/tomcat'
    code <<-EOH
    tar xvf /tmp/apache-tomcat-8.5.31.tar.gz -C /opt/tomcat --strip-components=1
    chgrp -R tomcat /opt/tomcat
    sudo chmod -R g+r conf
    sudo chmod g+x conf
    sudo chown -R tomcat webapps/ work/ temp/ logs/
    EOH
end
#
# Install the Systemd Unit File
template '/etc/systemd/system/tomcat.service' do
    source 'tomcat.service.erb'
end
#
# Reload Systemd to load the Tomcat Unit file
# Ensure `tomcat` is started and enabled
# Verify that Tomcat is running by visiting the site
#
bash 'reload_system' do
    cwd '/opt/tomcat'
    code <<-EOH
    sudo systemctl daemon-reload
    sudo systemctl start tomcat
    sudo systemctl enable tomcat
    EOH
end


# ```
# $ curl http://localhost:8080
# ```
