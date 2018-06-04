##########################################################################
# Recipe to install mongodb
#
##########################################################################
#
#
#
# set url for baseurl location
package_repo_url = case node['platform']
when 'redhat', 'oracle', 'centos' 
    "https://repo.mongodb.org/yum/redhat/#{node['platform_version'][0]}/mongodb-org/3.6/#{node['kernel']['machine'] =~ /x86_64/ ? 'x86_64' : 'i686'}"
# when 'fedora'
#  todo
# when 'amazon'
#  todo
end
#
#
#
# build yum repo
case node['platform_family']
when 'rhel', 'amazon', 'fedora'
  yum_repository 'mongodb-org-3.6' do
    description 'MongoDB Repository'
    baseurl package_repo_url
    gpgcheck false
    enabled true
  end
end
#
#
#
# install mongo db
yum_package 'mongodb-org'
#
#
#
# start the mongod service
service 'mongod' do
  action :start
end