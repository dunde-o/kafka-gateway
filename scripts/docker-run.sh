#!/bin/bash

# 공통 설정
NETWORK="kafka_docker_network" # 도커 네트워크 이름(kafka + docker compose 네트워크)
PROFILE="docker"

# 사용자명 인자 체크
if [ -z "$1" ]; then
  echo "❌ Docker Hub 사용자명을 인자로 입력해주세요."
  echo "예시: bash ./scripts/docker-run.sh chldlsrb1000"
  exit 1
fi

DOCKER_HUB_ID="$1"

# 네트워크 생성
docker network create "$NETWORK" 2>/dev/null || echo "네트워크 '$NETWORK'이 이미 존재합니다."

echo ""
echo "🚀 [gateway] 빌드 및 컨테이너 실행 중..."

# Maven 빌드
./gradlew build -x test || { echo "❌ Gradle 빌드 실패"; exit 1; }

TAG="${DOCKER_HUB_ID}/gateway:dev"

# 도커 이미지 빌드
docker build -t "$TAG" . || { echo "❌ Docker 빌드 실패: $TAG"; exit 1; }

# Docker Hub에 푸시
docker push "$TAG" || { echo "❌ Docker 푸시 실패: $TAG"; exit 1; }

# 기존 컨테이너 삭제
docker rm -f "gateway" 2>/dev/null

# 도커 실행
docker run -d --name "gateway" \
  -p "8080:8080" \
  --network "$NETWORK" \
  -e SPRING_PROFILES_ACTIVE="$PROFILE" \
  "$TAG"

# 불필요한 이미지 및 컨테이너 정리
docker image prune -f

echo ""
echo "✅ gateway 서비스가 실행되었습니다."
