FROM maven:3.8.4-openjdk-17-slim AS build
WORKDIR /app
COPY . .
RUN mvn clean package -pl service-registry -am -DskipTests

FROM openjdk:17-slim
WORKDIR /app
COPY --from=build /app/service-registry/target/service-registry-*.jar app.jar
EXPOSE 8761
ENTRYPOINT ["java", "-jar", "app.jar"] 