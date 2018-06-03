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
        gpgcheck = 0
        enabled = 1 
        action :create
    end`

4. Log-in to my free hosted chef-server on manage.chef.io (left over from tutorials)

5. Bootstrap the new EC2 instance to my existing chef-server
   > knife bootstrap ec2-18-218-146-148.us-east-2.compute.amazonaws.com --ssh-user ec2-user --sudo --identity-file workshop_key.pem --node-name workshop_target

6. Confirm connection on chef manage

7. 