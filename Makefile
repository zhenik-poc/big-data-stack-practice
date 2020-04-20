root_dir 			= $$PWD
current_dir			= $(root_dir)

hive_version 		= 3.1.2
hadoop_version 		= 3.2.1
hive_home 			= $$PWD/apache-hive-$(hive_version)-bin
hadoop_home 		= $$PWD/hadoop-$(hadoop_version)



download-hive:
	wget https://apache.uib.no/hive/hive-${hive_version}/apache-hive-${hive_version}-bin.tar.gz
	tar -xzvf apache-hive-${hive_version}-bin.tar.gz
	rm apache-hive-${hive_version}-bin.tar.gz
download-hadoop:
	wget https://apache.uib.no/hadoop/common/hadoop-${hadoop_version}/hadoop-${hadoop_version}.tar.gz
	tar -xzvf hadoop-${hadoop_version}.tar.gz
	rm hadoop-${hadoop_version}.tar.gz
	#apt-get install ssh
	#apt-get install pdsh
hadoop-standalone-config:
	mkdir input
	cp ${hadoop_home}/etc/hadoop/*.xml input
	${hadoop_home}/bin/hadoop jar ${hadoop_home}/share/hadoop/mapreduce/hadoop-mapreduce-examples-${hadoop_version}.jar grep input output 'dfs[a-z.]+'
	cat output/*
configure-hadoop:
	#Set JAVA_HOME explicitly
	sed -i "s#.*export JAVA_HOME.*#export JAVA_HOME=${JAVA_HOME}#g" ${hadoop_home}/etc/hadoop/hadoop-env.sh
	#Set HADOOP_CONF_DIR explicitly
	sed -i "s#.*export HADOOP_CONF_DIR.*#export HADOOP_CONF_DIR=${hadoop_home}/etc/hadoop#" ${hadoop_home}/etc/hadoop/hadoop-env.sh
	sed -i '/<\/configuration>/i <property><name>fs.defaultFS</name><value>hdfs://localhost:9000</value></property>' ${hadoop_home}/etc/hadoop/core-site.xml
	sed -i '/<\/configuration>/i <property><name>dfs.replication</name><value>1</value></property>' ${hadoop_home}/etc/hadoop/hdfs-site.xml