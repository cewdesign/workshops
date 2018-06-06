# Test Instructions

1. Stand up new RHEL Instance - virtual box or AWS.

2. Install chefdk (e.g.

   > curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chefdk -c stable -v 2.5.3

3. Bootstrap the instance

4. Upload tomcat_cb using berks upload (will upload dependencies as well)

5. Add tomcat_cb to runlist

6. Run chef-client on target machine

7. Test - curl http://localhost:8080 on target.

8. Done.