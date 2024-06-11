mongopod=$(kubectl get pods --selector=app=mongodb  --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
kubectl exec $mongopod -- mongorestore --drop /AcmeAirDBBackup
