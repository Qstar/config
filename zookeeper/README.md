# zookeeper
---
## Start Zookeeper  
Once zoo.cfg created for all the server then we can start the Zookeeper Servers. You should run the start command to start server on each machine:  
<b>./[Your path to zookeeper]/zk-server/bin/zkServer.sh start </b>   
After that, you can use status command to see ZooKeeper Server status:  
<b> ./[Your path to zookeeper]/zk-server/bin/zkServer.sh status  </b>   
If you correctly configured Zookeeper Servers, you should get the similar output(s):  
JMX enabled by default  
Using config: /home/junyang/zookeeper/zk-server-1/bin/../conf/zoo.cfg  
Mode: follower  
or:  
JMX enabled by default  
Using config: /home/junyang/zookeeper/zk-server-1/bin/../conf/zoo.cfg  
Mode: leader
We will have one leader and other followers. If any of the nodes in Zookeeper Cluster crush down, even the leader node, the Zookeeper will restart the crushed node and select a new leader automatically.

## Logs  
If you encounter some unexpected problems, always remember to check out the log files or error files. For Zookeeper, you can find them at /var/log/zookeeper/ and [your path to zookeeper]/zookeeper.out.
