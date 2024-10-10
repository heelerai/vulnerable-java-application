FROM gradle:8.7.0-jdk21 AS builder
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle bootJar --no-daemon


FROM amazoncorretto:21-alpine-jdk
LABEL org.opencontainers.image.source="https://github.com/DataDog/vulnerable-java-application/"
EXPOSE 8080
RUN mkdir /app
WORKDIR /app
COPY --from=builder /home/gradle/src/build/libs/*.jar /app/spring-boot-application.jar

# Utility
RUN apk add curl wget
RUN mkdir -p /tmp/files && echo "hello" > /tmp/files/hello.txt && echo "world" > /tmp/files/foo.txt

CMD ["java", "-jar", "/app/spring-boot-application.jar"]
