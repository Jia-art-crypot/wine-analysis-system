FROM maven:3.9-openjdk-17-slim AS build
WORKDIR /app
COPY pom.xml .
COPY mvnw .
COPY src ./src
RUN chmod +x mvnw && ./mvnw clean package -DskipTests

FROM openjdk:17-slim
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]