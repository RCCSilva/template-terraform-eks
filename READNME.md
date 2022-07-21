## Running AWS

```shell
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
```

```shell
kubectl patch deployment coredns \
    -n kube-system \
    --type json \
    -p='[{"op": "remove", "path": "/spec/template/metadata/annotations/eks.amazonaws.com~1compute-type"}]'
```

```shell
kubectl rollout restart -n kube-system deployment coredns
```


### EKS

```shell
kubectl run nginx --image=nginx --restart=Never
```
