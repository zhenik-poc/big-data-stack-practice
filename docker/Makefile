
run: storage prepare-storages infrastructure
storage:
	docker-compose up -d minio postgres
prepare-storages:
	docker-compose up db-init
	docker-compose up mc
infrastructure:
	docker-compose up -d hive-server
	docker-compose up -d hive-metastore
	docker-compose up -d presto
create-table:
	docker-compose exec hive-server /opt/hive/bin/beeline jdbc:postgresql://hive:hive@postgres:5432/metastore && \
		create table persons (id string, name string, lastname string) row format delimited fields terminated by ',', lines terminated by "\n" location "s3://hive";

