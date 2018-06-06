name 'tomcat_cb'
maintainer 'The Authors'
maintainer_email 'you@example.com'
license 'All Rights Reserved'
description 'Installs/Configures tomcat_cb'
long_description 'Installs/Configures tomcat_cb'
version '0.3.0'
chef_version '>= 12.14' if respond_to?(:chef_version)

# Include the Java cookbook
depends 'java'