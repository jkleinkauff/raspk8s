resource "kubectl_manifest" "debezium-connector" {
  count = var.deploy_debezium_connector ? 1 : 0
  wait              = true
  server_side_apply = true
  yaml_body         = <<-EOF
    apiVersion: kafka.strimzi.io/v1beta2
    kind: KafkaConnector
    metadata:
        name: my-debezium-connector-jhodb
        namespace: ${kubernetes_namespace.kafka.metadata.0.name}
        labels:
            strimzi.io/cluster: my-connect
    spec:
        class: io.debezium.connector.postgresql.PostgresConnector
        tasksMax: 1
        config:
            database.hostname: pg-jhodb.jhodb 
            database.port: 5432
            database.user: postgres
            database.password: super_pwd
            database.dbname: jhodb
            database.server.name: jhodb-debezium
            slot.name: slot_debezium  
            #table.include.list: public.products
            plugin.name: pgoutput
            #topic.creation.enable: true
            #topic.creation.default.replication.factor: 1
            #topic.creation.default.partitions: 1
            #topic.creation.default.cleanup.policy: compact
            #topic.creation.default.compression.type: lz4
            decimal.handling.mode: double
    EOF
}