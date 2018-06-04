# See http://docs.chef.io/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "cewdesign"
client_key               "#{current_dir}/cewdesign.pem"
chef_server_url          "https://api.chef.io/organizations/cewdesign"
cookbook_path            ["c:\\users\\cwood\\Documents\\GitHub\\workshops\\1_MongoDB"]
