FROM gradle:latest AS build
WORKDIR /home/gradle/project
COPY . .
RUN mkdir -p /root/.gradle && \
    echo -e "systemProp.http.proxyHost=krmp-proxy.9rum.cc\nsystemProp.http.proxyPort=3128\nsystemProp.https.proxyHost=krmp-proxy.9rum.cc\nsystemProp.https.proxyPort=3128" > /root/.gradle/gradle.properties

RUN chmod +x ./gradlew && \
    ./gradlew clean build

FROM openjdk:21-slim AS final
WORKDIR /app
COPY --from=build /home/gradle/project/libs /home/gradle/project/libs
COPY --from=build /home/gradle/project/build/libs/deploy-0.0.1-SNAPSHOT.jar app.jar
CMD ["java", "-jar", "app.jar"]
