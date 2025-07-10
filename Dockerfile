FROM eclipse-temurin:21-jdk-alpine
# FROM eclipse-temurin:21-jdk-jammy # 개발용 도구를 포함한 이미지
COPY build/libs/*SNAPSHOT.jar app.jar
EXPOSE 8080
ENV TZ=Asia/Seoul \
    SPRING_PROFILES_ACTIVE=docker
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENTRYPOINT ["java","-Xmx400M","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
