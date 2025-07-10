# kafka-docker
kafka 를 docker 로 띄우기 위한 보일러 플레이트 저장소

# Initialize Setting
- Project: Gradle - Groovy
- Language: Java
- Spring Boot: 3.5.3
- Project Metadata:
    - Group: com.example
    - Artifact: gateway
    - Name: gateway
    - Description: Gateway project for Kafka Spring Boot
    - Package name: com.example.gateway
    - Packaging: JAR
    - Java: 21
- Dependencies:
    - Spring for Apache Kafka
    - Lombok
    - Gateway

# 사전 준비
- docker: v28.x ('25.7.7 기준 lts)
- docker compose: v2.x ('25.7.7 기준 lts)
- java: v21.x ('25.7.7 기준 lts)

# 사용법

## 실행

```
bash ./scripts/docker-run.sh <DOCKER HUB ID>
```
- 위 명령어 사용시 `java 빌드 -> docker 빌드 -> docker push -> docker run` 순서로 진행됩니다.

```
cd docker
docker compose up -d
```
- 위 명령어 사용시 kafka, kafka-ui 가 동작합니다.

## 서비스 추가

- `src/main/java/com/example/gateway/resources/application.yml` 파일을 수정해주세요.
    - 사용 방법은 주석을 참고하시면 됩니다.

# 배포 (쿠버네티스)

## 사전 설정

### azure 설치

```
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

### azure 로그인

```
az login --use-device-code
```

### 쿠버네티스 클러스터 연결

```
az aks get-credentials --resource-group <마이크로소프트 리소스 그룹> --name <마이크로소프트 쿠버네티스 클러스터>
```

### 쿠버네티스 CLI 도구 설치
- 링크 참조: https://kubernetes.io/ko/docs/tasks/tools/install-kubectl-linux/

## 쿠버네티스 설정 실행

```
bash scripts/kube-run.sh <DOCKER HUB ID>
```

- 각 설정에 따라 `kubernetes/gateway.yml` 을 수정해주세요.
- image 는 docker hub에 올린 이미지 사용 (기본: `chldlsrb1000/gateway:latest`)

```
# 이 명령어는 kube-run.sh 에 포함되어 있습니다.
kubectl apply -f kubernetes/kafka.yml
kubectl apply -f kubernetes/kafka-ui.yml
```

- 기본 설정이 되어있는 kafka, kafka-ui 를 추가합니다.

```
# 이 명령어는 kube-run.sh 에 포함되어 있습니다.
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/cloud/deploy.yaml
```

- kubernetes 의 ingress 설정을 추가합니다.

```
kubectl get ingress
kubectl get svc -n ingress-nginx
kubectl describe svc ingress-nginx-controller -n ingress-nginx
```

- 위 명령어들로 ingress 상태를 확인하세요.

### 추가 명령어

```
# 제거하기
kubectl delete -f kubernetes/gateway.yml

# 확인하기 (pods, services, deployments..)
kubectl get all

# 로그확인(-f: 실시간 옵션)
kubectl logs <POD NAME>
```
