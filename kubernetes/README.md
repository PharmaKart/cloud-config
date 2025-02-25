#### Kubernetes configurations for Pharmakart Web Application
This repository contains the Kubernetes configurations for the Pharmakart Web Application.

### Prerequisites
- Kubernetes Cluster
- kubectl
- aws-cli

### Steps to deploy the application
1. Clone the repository
2. add the following secrets to the kubernetes cluster
**bash**
```bash
kubectl create secret docker-registry regcred --docker-server=${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com --docker-username=AWS --docker-password=$(aws ecr get-login-password)
```
**powershell**
```powershell
kubectl delete secret regcred
$PASSWORD = aws ecr get-login-password --region ca-central-1
kubectl create secret docker-registry regcred --docker-server=${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com --docker-username=AWS --docker-password=$PASSWORD
```

3. Deploy frontend deployment
```bash
kubectl apply -f frontend/deployment.yaml
```
4. Deploy frontend service
```bash
kubectl apply -f frontend/service.yaml
```
