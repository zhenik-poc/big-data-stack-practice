# Hadoop, Hive, Metastore, S3, Postgres
Practising with big data stack

## Setup

## Minio required bucket and sub-dir

```bash
mc config host add my-local-conf http://127.0.0.1:9000 minio minio123
mc mb my-local-conf/hive
mc cp myobject.csv my-local-conf/hive/warehouse/myobject.csv
```

## Links
* [modern-data-lake-with-minio](https://blog.minio.io/modern-data-lake-with-minio-part-2-f24fb5f82424)
* [presto-modern-interactive-sql-query-engine-for-enterprise](https://blog.minio.io/presto-modern-interactive-sql-query-engine-for-enterprise-ce56d7aea931)
* [big-data-stack-running-sql-queries](https://johs.me/posts/big-data-stack-running-sql-queries/)

## Additional links
* [IBM/docker-hive guave lib update](https://github.com/IBM/docker-hive/blob/master/Dockerfile#L12)
* [Amazon EMR & additional sdk](https://aws.amazon.com/emr/)