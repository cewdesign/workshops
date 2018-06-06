# How to Test

## Target

* Target environment must be RHEL
* Target environment must have up-to-date chefdk installed

## Testing

1. Install chefdk on target environment

   > curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chefdk -c stable -v 2.5.3

2. Copy recipe (default.rb) to target machine

3. Run recipe on target using local-mode

   > chef-client --local-mode default.rb