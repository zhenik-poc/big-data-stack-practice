hive_image = homemade/hive:3.1.0

.PHONY: build create-docker-network persistence-up sleep10 minio-provision metastore-up hive-server-up \
	metastore-create-table presto-up presto-query-example up down

build:
	docker build -f docker/hive.dockerfile  -t ${hive_image} ./docker
create-docker-network:
	docker network create -d bridge hive-test || docker network ls | grep hive-test
persistence-up:
	docker-compose up -d minio database
# presto and hive needs time to spin up
# if services are fail due to not ready, increase waiting time
sleep10:
	sleep 10
sleep20:
	sleep 20
minio-provision:
	docker-compose -f docker-compose.s3-provision.yml up
metastore-up:
	docker-compose up -d hive-metastore
hive-server-up:
	docker-compose up -d hive-server
# create external table
metastore-create-table:
	docker-compose exec hive-metastore beeline -u jdbc:hive2:// -f /tmp/create-table.hql
presto-up:
	docker-compose up -d presto
presto-query-example:
	docker-compose exec presto presto -f /tmp/query-example.sql

# automate
up: build create-docker-network persistence-up sleep10 minio-provision metastore-up \
	hive-server-up presto-up sleep20 metastore-create-table presto-query-example
down:
	docker-compose -f docker-compose.s3-provision.yml down
	docker-compose down
	docker network rm hive-test
