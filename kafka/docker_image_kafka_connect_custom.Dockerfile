FROM confluentinc/cp-kafka-connect:6.2.5 as cp
RUN confluent-hub install --no-prompt debezium/debezium-connector-postgresql:1.4.2 \
  && confluent-hub install --no-prompt confluentinc/kafka-connect-avro-converter:6.2.0
FROM quay.io/strimzi/kafka:0.29.0-kafka-3.2.0
USER root:root
RUN mkdir -p /opt/kafka/plugins/snowflake && mkdir -p /opt/kafka/plugins/avro/
#COPY --from=cp /usr/share/confluent-hub-components/snowflakeinc-snowflake-kafka-connector/lib /opt/kafka/plugins/snowflake/
COPY --from=cp /usr/share/confluent-hub-components/confluentinc-kafka-connect-avro-converter/lib /opt/kafka/plugins/avro/
USER 1001
