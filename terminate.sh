for ns in $(kjho get ns --field-selector status.phase=Terminating -o jsonpath='{.items[*].metadata.name}')
do
  kjho get ns $ns -ojson | jq '.spec.finalizers = []' | kjho replace --raw "/api/v1/namespaces/$ns/finalize" -f -
done

for ns in $(kjho get ns --field-selector status.phase=Terminating -o jsonpath='{.items[*].metadata.name}')
do
  kjho get ns $ns -ojson | jq '.metadata.finalizers = []' | kjho replace --raw "/api/v1/namespaces/$ns/finalize" -f -
done
