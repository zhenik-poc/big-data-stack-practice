# Hadoop, Hive, Metastore, S3, Postgres
Practising with big data stack

## Setup

## Minio required bucket and sub-dir

```bash
mc config host add my-local-conf http://127.0.0.1:9000 minio minio123
mc mb my-local-conf/hive
mc cp myobject.csv my-local-conf/hive/warehouse/myobject.csv
```
