##########################################################################
# Cookbook Name:: mongodb
# Recipe:: install
#
# Not sure how to get started?
#
# You could:
# 1.  copy the relevant commands from http://docs.mongodb.org/manual/tutorial/install-mongodb-on-red-hat-centos-or-fedora-linux/
# 2.  comment out everything
# 3.  add the Chef resources and other Chef code necessary
#
# This file is an example of steps 1 and 2 above.
##########################################################################
#

# Create a /etc/yum.repos.d/mongodb.repo file to hold the following configuration information for the MongoDB repository:
#
# If you are running a 64-bit system, use the following configuration:
#
# [mongodb]
# name=MongoDB Repository
# baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/
# gpgcheck=0
# enabled=1
# If you are running a 32-bit system, which is not recommended for production deployments, use the following configuration:
#
# [mongodb]
# name=MongoDB Repository
# baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/i686/
# gpgcheck=0
# enabled=1

Chef::Log.warn("Platform: " + platform)
package_repo_url = case node['platform']
when 'redhat', 'oracle', 'centos' 
    "https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/#{package_version_major}/#{node['kernel']['machine'] =~ /x86_64/ ? 'x86_64' : 'i686'}"
# when 'fedora'
#  "https://repo.mongodb.org/yum/redhat/7/mongodb-org/#{package_version_major}/#{node['kernel']['machine'] =~ /x86_64/ ? 'x86_64' : 'i686'}"
# when 'amazon'
#    "https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/#{package_version_major}/x86_64/"
end
Chef::Log.warn("package_repo_url: " + package_repo_url)

case node['platform_family']
# when 'debian'
#   # Ubuntu: https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/
#   # Debian: https://docs.mongodb.com/manual/tutorial/install-mongodb-on-debian/
#   apt_repository 'mongodb' do
#     uri node['mongodb']['repo']
#     distribution "#{node['lsb']['codename']}/mongodb-org/#{package_version_major}"
#     components node['platform'] == 'ubuntu' ? ['multiverse'] : ['main']
#     key "https://www.mongodb.org/static/pgp/server-#{package_version_major}.asc"
#   end
when 'amazon', 'fedora', 'rhel'
    # RHEL: https://docs.mongodb.com/manual/tutorial/install-mongodb-on-red-hat/
#   # Amazon: https://docs.mongodb.com/manual/tutorial/install-mongodb-on-amazon/
#   yum_repository 'mongodb' do
#     description 'mongodb RPM Repository'
#     baseurl package_repo_url
#     gpgcheck false
#     enabled true
#   end
# else
#   # pssst build from source
#   Chef::Log.warn("Adding the #{node['platform_family']} mongodb-org repository is not yet not supported by this cookbook")
# end
# yum_repository 'mongodb' do
#     description "Mongo DB Repo"
#     baseurl "http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/"
#     gpgcheck false
#     enabled = 1 
#     action :create
# end


# Install the MongoDB packages and associated tools.
#
# sudo yum install mongodb-org
#
#
# Start MongoDB.
#
# sudo service mongod start
#
# ensure that MongoDB will start following a system reboot by issuing the following command:
#
# sudo chkconfig mongod on#