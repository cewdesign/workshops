##########################################################################
# Cookbook Name:: mongodb
# Recipe:: install
#
##########################################################################
#
#
#
# set url for baseurl location
Chef::Log.warn("Platform: " + node['platform']) # testing
package_repo_url = case node['platform']
when 'redhat', 'oracle', 'centos' 
    "http://downloads-distro.mongodb.org/repo/redhat/os/#{node['kernel']['machine'] =~ /x86_64/ ? 'x86_64' : 'i686'}"
# when 'fedora'
#  todo
# when 'amazon'
#  todo
end
Chef::Log.warn("package_repo_url: " + package_repo_url) # testing
#
# build yum repo
case node['platform_family']
when 'rhel', 'amazon', 'fedora'
  yum_repository 'mongodb' do
    description 'MongoDB Repository'
    baseurl package_repo_url
    gpgcheck false
    enabled true
  end
end


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