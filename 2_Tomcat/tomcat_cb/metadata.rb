name 'tomcat_cb'
maintainer 'Colin Wood'
maintainer_email 'colin@cewdesign.com'
license 'Apache-2.0'
description 'Installs/Configures tomcat_cb'
long_description 'Installs/Configures tomcat_cb'
version '0.3.0'
chef_version '>= 12.14' if respond_to?(:chef_version)
issues_url 'https://github.com/cewdesign/workshops/issues'
source_url 'https://github.com/cewdesign/workshops'
supports 'redhat'

# Include the Java cookbook
depends 'java'