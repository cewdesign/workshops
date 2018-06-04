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

10. 
