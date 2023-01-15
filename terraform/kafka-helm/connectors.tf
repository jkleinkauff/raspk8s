# resource "kubectl_manifest" "debezium-connector" {
#   count             = var.deploy_debezium_connector ? 1 : 0
#   wait              = true
#   server_side_apply = true
#   yaml_body         = <<-EOF
#     apiVersion: kafka.strimzi.io/v1beta2
#     kind: KafkaConnector
#     metadata:
#         name: my-debezium-connector-jhodb
#         namespace: ${kubernetes_namespace.kafka.metadata.0.name}
#         labels:
#             strimzi.io/cluster: my-connect
#     spec:
#         class: io.debezium.connector.postgresql.PostgresConnector
#         tasksMax: 1
#         config:
#             database.hostname: pg-jhodb.jhodb 
#             database.port: 5432
#             database.user: postgres
#             database.password: super_pwd
#             database.dbname: jhodb
#             database.server.name: jhodb-debezium
#             slot.name: slot_debezium  
#             #table.include.list: public.products
#             plugin.name: pgoutput
#             #topic.creation.enable: true
#             #topic.creation.default.replication.factor: 1
#             #topic.creation.default.partitions: 1
#             #topic.creation.default.cleanup.policy: compact
#             #topic.creation.default.compression.type: lz4
#             decimal.handling.mode: double
#     EOF
# }

# resource "kubectl_manifest" "sink-s3" {
#   count             = var.deploy_sink_s3 ? 1 : 0
#   wait              = true
#   server_side_apply = true
#   depends_on = [
#     kubernetes_secret.aws-secret
#   ]
#   yaml_body = <<-EOF
#     apiVersion: kafka.strimzi.io/v1beta2
#     kind: KafkaConnector
#     metadata:
#         name: my-sink-s3-connector
#         namespace: ${kubernetes_namespace.kafka.metadata.0.name}
#         labels:
#             strimzi.io/cluster: my-connect
#     spec:
#         class: io.confluent.connect.s3.S3SinkConnector
#         tasksMax: 1
#         config:
#             key.converter.schemas.enable: true
#             value.converter.schemas.enable: true
#             #key.converter: io.confluent.connect.avro.AvroConverter
#             #value.converter: io.confluent.connect.avro.AvroConverter
#             #key.converter.schemas.enable: false
#             #value.converter: org.apache.kafka.connect.avro.AvroConverter
#             #value.converter.schemas.enable: true
#             connector.class: io.confluent.connect.s3.S3SinkConnector
#             # topics: jhodb-debezium.ecommerce*
#             topics.regex: "jhodb-debezium.ecommerce.(.*)"
#             table.name.format: "$${topic}"
#             s3.region: us-east-1
#             s3.bucket.name: ${aws_s3_bucket.sink-bucket.id}
#             s3.part.size: 5242880
#             flush.size: 100
#             rotate.schedule.interval.ms: 60000
#             storage.class: io.confluent.connect.s3.storage.S3Storage
#             format.class: io.confluent.connect.s3.format.json.JsonFormat
#             #format.class: io.confluent.connect.s3.format.parquet.ParquetFormat
#             schema.generator.class: io.confluent.connect.storage.hive.schema.DefaultSchemaGenerator
#             partitioner.class: io.confluent.connect.storage.partitioner.DefaultPartitioner
#             schema.compatibility: NONE
#             timezone: "UTC"
#         EOF
# }