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
