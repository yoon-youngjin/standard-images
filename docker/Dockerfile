FROM openjdk:17-jdk-slim AS builder
WORKDIR /app

COPY /api/build/libs/*.jar app.jar
RUN mkdir -p build/extract

WORKDIR /app/build/extract

RUN java -Djarmode=layertools -jar /app/app.jar extract

FROM openjdk:17-jdk-slim

COPY --from=builder /app/build/extract/dependencies/ /app
COPY --from=builder /app/build/extract/spring-boot-loader/ /app
COPY --from=builder /app/build/extract/snapshot-dependencies/ /app
COPY --from=builder /app/build/extract/application/ /app

WORKDIR /app

ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]
