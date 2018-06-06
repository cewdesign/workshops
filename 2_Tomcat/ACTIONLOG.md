# Narrative

## Environment Details
- Using my windows laptop as Chef Workstation, mixing between command prompt, power shell and git bash shell
- ChefDK Version 2.5.3
- Chef Client Version 13.8.5
- Berks Version 6.3.1
- Kitchen Version 1.20.0
- Inspec Version 1.51.21

## Getting Started
04-Jun-2018

1. Create default.rb file under 2_Tomcat

2. Let's go back to cookbooks so we can use the java cookbook from the supermarket.

3. Run
   
   > knife ssl check

   Success!

4. ssh to target machine which was previously bootstrapped, run chef-client to test.
   Success!

5. Install the java cookbook from the supermarket

   > knife cookbook site search java
   > git-init
   > knife cookbook site install java

6. Generate a cookbook

   > chef generate cookbook tomcat

7. Upload the java and homebrew cookbooks to chef manage server

   > knife cookbook site install homebrew
   > knife cookbook upload homebrew
   > knife cookbook upload java

8. Update target's run list to include java using chef manage ui. Cloud have also used:
   
   > knife node run_list add NODE_NAME java::openjdk

9. Run chef-client manually via ssh on target
   
   >sudo chef-clint 

   Success. Openjdk installed.

10. Add group creation for tomcat group

        `group 'tomcat' do
            append true
        end`

11. Add user creation for tomcat user

        `user 'tomcat' do
            gid                        'tomcat'
            home                       '/opt/tomcat'
            manage_home                False
            shell                      '/bin/nologin'
        end`

12. Retrieve the file.

        `remote_file 'apache-tomcat-8.5.31.tar.gz' do
            source 'http://mirror.csclub.uwaterloo.ca/apache/tomcat/tomcat-8/v8.5.31/bin/apache-tomcat-8.5.31.tar.gz'
            path '/tmp/apache-tomcat-8.5.31.tar.gz'
            action :create_if_missing
            mode 00644
        end`

13. Expand the file

        `bash 'extract_module' do
            cwd ::'/tmp/'
            code <<-EOH
            mkdir -p '/opt/tomcat'
            tar xvf /tmp/apache-tomcat-8.5.31.tar.gz -C /opt/tomcat --strip-components=1
            EOH
        end`

14. Roll the chmods, chgrp and chown to the bash statement

        `bash 'extract_module' do
            cwd '/opt/tomcat'
            code <<-EOH
            mkdir -p '/opt/tomcat'
            tar xvf /tmp/apache-tomcat-8.5.31.tar.gz -C /opt/tomcat --strip-components=1
            chgrp -R tomcat /opt/tomcat
            sudo chmod -R g+r conf
            sudo chmod g+x conf
            sudo chown -R tomcat webapps/ work/ temp/ logs/
            EOH
        end`

## Tidy up time.
05-Jun-2018

15. Let's roll up the recipe into a cookbook and add the template.

    > chef generate cookbook ./tomcat_cb

16. Now we can generate the template we need

    > chef generate template ./tomcat_cb tomcat.service

17. Populate the template file with contents using vi.

18. Let's try running java from within the tomcat recipe instead of manually adding it to the node's runlist. Edit default.rb to include below at top.

        `# Install Java
        include_recipe 'java::openjdk'`

Then add this in metadata.rb for dependency.

        `#Needs Java
        depends 'java'

19. Upload our tomcat_cb cookbook

  > knife cookbook upload tomcat_cb --cookbook-path ./

20. Run on server

  > sudo chef-client

21. Okay, this isn't working. Time to test manual steps against an identical instance to ensure it works.

# Error Fix
06-Jun-2018

22. AWS console, launch a new one.

22. Run all the steps manually. Success. Kill that machine now.

23. Run the steps manually one-by-one test tomcat after each to see which recipe step wasn't successful.

24. Okay, right away discover that it is the java install that is bad. Let's fix that in the recipe.

25. Noticed that java cookbook is installing java 6 by default, updated the attributes to point to Java 7.

26. Reupload cookbook. Rerun chef-client on target. Success!
