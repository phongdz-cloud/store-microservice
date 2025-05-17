FROM maven:3.8.4-openjdk-17-slim AS build
WORKDIR /app
COPY . .
RUN mvn clean package -pl identity-service -am -DskipTests

FROM openjdk:17-slim
WORKDIR /app
COPY --from=build /app/identity-service/target/identity-service-*.jar app.jar
EXPOSE 8082
ENTRYPOINT ["java", "-jar", "app.jar"] 