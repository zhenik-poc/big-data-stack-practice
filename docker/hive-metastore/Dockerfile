FROM bde2020/hadoop-base:2.0.0-hadoop3.2.1-java8

ENV HADOOP_VERSION 3.2.1
ENV HIVE_VERSION 3.1.2
ENV AWS_VERSION=1.11.764

ENV HIVE_HOME /opt/hive
ENV PATH $HIVE_HOME/bin:$PATH
ENV HADOOP_HOME /opt/hadoop-$HADOOP_VERSION

WORKDIR /opt

#Install Hive and PostgreSQL JDBC
RUN apt-get update && apt-get install -y wget procps ca-certificates

COPY  ./*.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

RUN wget https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz && \
	tar -xzvf apache-hive-$HIVE_VERSION-bin.tar.gz && \
	mv apache-hive-$HIVE_VERSION-bin hive && \
	rm apache-hive-$HIVE_VERSION-bin.tar.gz && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*


# Guava S3 compatible
# ref https://github.com/IBM/docker-hive/blob/master/Dockerfile 
RUN rm -f $HIVE_HOME/lib/guava-19.0.jar && \
    	cp $HADOOP_HOME/share/hadoop/common/lib/guava-27.0-jre.jar $HIVE_HOME/lib/

RUN rm $HIVE_HOME/lib/postgresql-9.4.1208.jre7.jar
# postgresql-metadata-storage-0.12.0.jar

RUN wget https://jdbc.postgresql.org/download/postgresql-42.2.12.jar -O $HIVE_HOME/lib/postgresql-42.2.12.jar

#Spark should be compiled with Hive to be able to use it
#hive-site.xml should be copied to $SPARK_HOME/conf folder

#Custom configuration goes here
ADD conf/hive-site.xml $HIVE_HOME/conf
ADD conf/beeline-log4j2.properties $HIVE_HOME/conf
ADD conf/hive-env.sh $HIVE_HOME/conf
ADD conf/hive-exec-log4j2.properties $HIVE_HOME/conf
ADD conf/hive-log4j2.properties $HIVE_HOME/conf
ADD conf/ivysettings.xml $HIVE_HOME/conf
ADD conf/llap-daemon-log4j2.properties $HIVE_HOME/conf

COPY startup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startup.sh

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN curl -L https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk/${AWS_VERSION}/aws-java-sdk-${AWS_VERSION}.jar \ 
	-o $HIVE_HOME/lib/aws-java-sdk-${AWS_VERSION}.jar
RUN curl -L https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-core/${AWS_VERSION}/aws-java-sdk-core-${AWS_VERSION}.jar \ 
	-o $HIVE_HOME/lib/aws-java-sdk-core-${AWS_VERSION}.jar
RUN curl -L https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-s3/${AWS_VERSION}/aws-java-sdk-s3-${AWS_VERSION}.jar \
	-o $HIVE_HOME/lib/aws-java-sdk-s3-${AWS_VERSION}.jar
RUN curl -L https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}/hadoop-aws-${HADOOP_VERSION}.jar \
	-o $HIVE_HOME/lib/hadoop-aws-${HADOOP_VERSION}.jar
RUN curl -L https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-dynamodb/${AWS_VERSION}/aws-java-sdk-dynamodb-${AWS_VERSION}.jar \
	-o $HIVE_HOME/lib/aws-java-sdk-dynamodb-${AWS_VERSION}.jar

# 	curl -L https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-emr/${AWS_VERSION}/aws-java-sdk-emr-${AWS_VERSION} -o $HIVE_HOME/lib/aws-java-sdk-emr-${AWS_VERSION} 
# RUN curl -L https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk/${AWS_VERSION}/aws-java-sdk-${AWS_VERSION}.jar -o $HADOOP_HOME/lib/aws-java-sdk-${AWS_VERSION}.jar && \
#     curl -L https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-core/${AWS_VERSION}/aws-java-sdk-core-${AWS_VERSION}.jar -o $HADOOP_HOME/lib/aws-java-sdk-core-${AWS_VERSION}.jar&& \
#     curl -L https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-s3/${AWS_VERSION}/aws-java-sdk-s3-${AWS_VERSION}.jar -o $HADOOP_HOME/lib/aws-java-sdk-s3-${AWS_VERSION}.jar && \
#     curl -L https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}/hadoop-aws-${HADOOP_VERSION}.jar -o $HADOOP_HOME/lib//hadoop-aws-${HADOOP_VERSION}.jar && \
# 	curl -L https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-emr/${AWS_VERSION}/aws-java-sdk-emr-${AWS_VERSION} -o $HADOOP_HOME/lib/aws-java-sdk-emr-${AWS_VERSION} 


EXPOSE 10000
EXPOSE 10002
EXPOSE 9083

ENTRYPOINT ["entrypoint.sh"]
# CMD startup.sh
