# Narrative

## Environment Details
- Using my windows laptop as Chef Workstation, mixing between command prompt, power shell and git bash shell
- ChefDK Version 2.5.3
- Chef Client Version 13.8.5
- Berks Version 6.3.1
- Kitchen Version 1.20.0
- Inspec Version 1.51.21

## Getting Started
01-Jun-2018

0. Ignore the fact that there is a fully working mongodb install recipe in the supermarket.

1. Copy the provided install.rb file contents into my new default.rb as suggested starting point.

2. Stand up a new AWS EC2 instance (ami-03291866, t2.micro) to be the new RHEL7 target for the Mongodb install

3. SSH to EC2 instance
   > ssh -i "workshop_key.pem" ec2-user@ec2-18-218-146-148.us-east-2.compute.amazonaws.com

4. Install chefdk on instance to test locally
   >curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chefdk -c stable -v 2.5.3

5. Create test.rb
   > mkdir chef-repo
   > cd chef-repo
   > vi test.rb

        `file '/etc/yum.repos.d/mongodb.repo' do
            content 'Test'
        end`

6. Test
   > sudo chef-client --local-mode test.rb
   > cat /etc/yum.repos.d/mongodb.repo
   Success!

## Continuing
03-Jun-2018

7. Modify test.rb with correct content

       `file '/etc/yum.repos.d/mongodb.repo' do
            content '[mongodb]
            name=MongoDB Repository
            baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/
            gpgcheck=0
            enabled=1'
        end`

8. Test
   > sudo chef-client --local-mode test.rb
   > cat /etc/yum.repos.d/mongodb.repo
   Success!

9. Let's assume 64-bit target only for right now.

10. Discovered yum_repository resource (https://docs.chef.io/resource_yum_repository.html), let's switch to that:

        `yum_repository 'mongodb' do
            description "Mongo DB Repo"
            baseurl "http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/"
            gpgcheck false
            enabled true 
            action :create
        end`

11. Seem to be encountering a conflict between my recipe and my yum repo. Keeps saying no suitable version. Let's try to mitigate that problem by adding some versioning logic. No longer need to assum 64-bit target as we are catching this now. Found some help in the office mongo cookbook in the supermarket. 

12. Added versioning logic, build structure but limit case to rhel for now

13. Tested as:

        `Chef::Log.warn("Platform: " + node['platform']) # testing
        Chef::Log.warn("Platform Version: " + node['platform_version'])
        package_repo_url = case node['platform']
        when 'redhat', 'oracle', 'centos' 
            "https://repo.mongodb.org/yum/redhat/#{node['platform_version'][0]}/mongodb-org/3.6/#{node['kernel']['machine'] =~ /x86_64/ ? 'x86_64' : 'i686'}"
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
            yum_repository 'mongodb-org-3.6' do
                description 'MongoDB Repository'
                baseurl package_repo_url
                gpgcheck false
                enabled true
            end
        end`

    Working!

14. Now need to start it. Add

        `service 'mongod' do
            action :start
        end`

    Sucess!

15. Now ensure it is enable to survive a restart.

        `service 'mongod' do
            action [ :enable, :start ]
        end`

    And follow the instructions in the exercise issue the following command
        
        `execute 'chkconfig_mongod' do
            command 'chkconfig mongod on'
        end`

16. Done basic recipe Dev.



