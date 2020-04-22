root_dir 			= $$PWD
current_dir			= $(root_dir)

hive_version 		= 3.1.2
hadoop_version 		= 3.2.1
hive_home 			= $$PWD/apache-hive-$(hive_version)-bin
hadoop_home 		= $$PWD/hadoop-$(hadoop_version)


exports:
	source .env
# Hadoop
hadoop-download:
	wget https://apache.uib.no/hadoop/common/hadoop-${hadoop_version}/hadoop-${hadoop_version}.tar.gz
	tar -xzvf hadoop-${hadoop_version}.tar.gz
	rm hadoop-${hadoop_version}.tar.gz
	#apt-get install ssh
hadoop-standalone-operation:
	mkdir input
	cp ${hadoop_home}/etc/hadoop/*.xml input
	${hadoop_home}/bin/hadoop jar ${hadoop_home}/share/hadoop/mapreduce/hadoop-mapreduce-examples-${hadoop_version}.jar grep input output 'dfs[a-z.]+'
	cat output/*
hadoop-configure:
	#Set JAVA_HOME explicitly
	sed -i "s#.*export JAVA_HOME.*#export JAVA_HOME=${JAVA_HOME}#g" ${hadoop_home}/etc/hadoop/hadoop-env.sh
	sed -i '/<\/configuration>/i <property><name>fs.defaultFS</name><value>hdfs://0.0.0.0:9000</value></property>' ${hadoop_home}/etc/hadoop/core-site.xml
	sed -i '/<\/configuration>/i <property><name>dfs.replication</name><value>1</value></property>' ${hadoop_home}/etc/hadoop/hdfs-site.xml

	#Set user
# 	sed -i "s#.*export HDFS_NAMENODE_USER.*#export HDFS_NAMENODE_USER=${USER}#g" ${hadoop_home}/etc/hadoop/hadoop-env.sh
# 	grep 'export HDFS_DATANODE_USER' ${hadoop_home}/etc/hadoop/hadoop-env.sh && \
# 		sed -i "s#.*export HDFS_DATANODE_USER.*#export HDFS_DATANODE_USER=${USER}#g" ${hadoop_home}/etc/hadoop/hadoop-env.sh || \
# 		echo 'export HDFS_DATANODE_USER=${USER}' >> ${hadoop_home}/etc/hadoop/hadoop-env.sh
# 	grep 'export HDFS_SECONDARYNAMENODE_USER' ${hadoop_home}/etc/hadoop/hadoop-env.sh && \
# 		sed -i "s#.*export HDFS_SECONDARYNAMENODE_USER.*#export HDFS_SECONDARYNAMENODE_USER=${USER}#g" ${hadoop_home}/etc/hadoop/hadoop-env.sh || \
# 		echo 'export HDFS_SECONDARYNAMENODE_USER=${USER}' >> ${hadoop_home}/etc/hadoop/hadoop-env.sh
	#Set HADOOP_CONF_DIR explicitly
	#sed -i "s#.*export HADOOP_CONF_DIR.*#export HADOOP_CONF_DIR=${hadoop_home}/etc/hadoop#" ${hadoop_home}/etc/hadoop/hadoop-env.sh
format:
	${hadoop_home}/bin/hdfs namenode -format
start:
	${hadoop_home}/sbin/start-dfs.sh
stop:
	${hadoop_home}/sbin/stop-dfs.sh
hadoop-test:
	${hadoop_home}/bin/hdfs dfs -mkdir /user
	${hadoop_home}/bin/hdfs dfs -mkdir /user/$${USER}
	${hadoop_home}/bin/hdfs dfs -mkdir -p input
	${hadoop_home}/bin/hdfs dfs -put ${hadoop_home}/etc/hadoop/*.xml input
	${hadoop_home}/bin/hadoop jar ${hadoop_home}/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.1.jar grep input output 'dfs[a-z.]+'
	${hadoop_home}/bin/hdfs dfs -get output output
	cat output/*

# Hive
download-hive:
	wget https://apache.uib.no/hive/hive-${hive_version}/apache-hive-${hive_version}-bin.tar.gz
	tar -xzvf apache-hive-${hive_version}-bin.tar.gz
	rm apache-hive-${hive_version}-bin.tar.gz
local:	
	cp -f ./config/hdfs-site.xml ${hadoop_home}/etc/hadoop/hdfs-site.xml
add-s3-hive-lib:
	curl -L https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-hdfs/3.2.1/hadoop-hdfs-3.2.1.jar \
		-o ${hive_home}/lib/hadoop-hdfs-3.2.1.jar
	curl -L https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk/1.11.765/aws-java-sdk-1.11.765.jar \
		-o ${hive_home}/lib/aws-java-sdk-1.11.765.jar
dirs:
	${hadoop_home}/bin/hadoop fs -mkdir       /tmp
	${hadoop_home}/bin/hadoop fs -mkdir       /user/hive/warehouse
	${hadoop_home}/bin/hadoop fs -chmod g+w   /tmp
	${hadoop_home}/bin/hadoop fs -chmod g+w   /user/hive/warehouse

