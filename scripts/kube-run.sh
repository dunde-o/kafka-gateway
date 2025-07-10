#!/bin/bash

# 사용자명 인자 체크
if [ -z "$1" ]; then
  echo "❌ Docker Hub 사용자명을 인자로 입력해주세요."
  echo "예시: bash ./scripts/kube-run.sh chldlsrb1000"
  exit 1
fi

DOCKER_HUB_ID="$1"

echo ""
echo "🚀 [gateway] 빌드 및 컨테이너 실행 중..."

# Maven 빌드
./gradlew build -x test || { echo "❌ Gradle 빌드 실패"; exit 1; }

TAG="${DOCKER_HUB_ID}/gateway:latest"

# 도커 이미지 빌드
docker build -t "$TAG" . || { echo "❌ Docker 빌드 실패: $TAG"; exit 1; }

# Docker Hub에 푸시
docker push "$TAG" || { echo "❌ Docker 푸시 실패: $TAG"; exit 1; }

# 불필요한 이미지 및 컨테이너 정리
docker image prune -f

kubectl apply -f kubernetes/gateway.yml || { echo "❌ Kubernetes gateway 배포 실패"; exit 1; }

echo "✅ kubernetes gateway 서비스가 실행되었습니다."
echo ""

kubectl apply -f kubernetes/kafka.yml || { echo "❌ Kubernetes kafka 배포 실패"; exit 1; }

echo "✅ kubernetes kafka 서비스가 실행되었습니다."
echo ""

kubectl apply -f kubernetes/kafka-ui.yml || { echo "❌ Kubernetes kafka-ui 배포 실패"; exit 1; }

echo "✅ kubernetes kafka-ui 서비스가 실행되었습니다."
echo ""

kubectl apply -f kubernetes/ingress.yml || { echo "❌ Kubernetes ingress 배포 실패"; exit 1; }  

echo "✅ kubernetes ingress 서비스가 실행되었습니다."
echo ""

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/cloud/deploy.yaml || { echo "❌ Kubernetes ingress-nginx 배포 실패"; exit 1; }  

echo "✅ kubernetes ingress-nginx 서비스가 실행되었습니다."
echo ""
