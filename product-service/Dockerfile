FROM maven:3.8.4-openjdk-17-slim AS build
WORKDIR /app
COPY . .
RUN mvn clean package -pl product-service -am -DskipTests

FROM openjdk:17-slim
WORKDIR /app
COPY --from=build /app/product-service/target/product-service-*.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]