if [[ -z "$db_service_name" ]]; then
    echo "please, fill db_service_name variable "
    return
fi

if [[ -z "$db_service_replica_name" ]]; then
    echo "plrease, fill db_service_replica_name variable"
    return
fi

if [[ -z "$db_namespace" ]]; then
    echo "please, fill db_namespace variable"
    return
fi

service_uid="$(kjho get service $db_service_name -n $db_namespace -o jsonpath='{.metadata.ownerReferences[0].uid}')"
service_uid_replica="$(kjho get service $db_service_replica_name -n $db_namespace -o jsonpath='{.metadata.ownerReferences[0].uid}')"
echo $service_uid_replica

service_port="$(shuf -i 30000-32767 -n 1)"
service_master_text="$(cat ./service-master.yaml)"
sed  -e 's|@service-name|'$db_service_name'|g' -e 's|@service-uid|'$service_uid'|g' -e 's|@service-ns|'$db_namespace'|g' -e 's|@service-port|'$service_port'|g'  service-master.yaml > tmp_service_master_apply.yaml
sed  -e 's|@service-name|'$db_service_name'|g' -e 's|@service-uid|'$service_uid_replica'|g' -e 's|@service-ns|'$db_namespace'|g' -e 's|@service-port|'$service_port'|g'  service-replica.yaml > tmp_service_replica_apply.yaml
sed  's|@service-uid|'$service_uid'|g' service-master.yaml
