# Use a lightweight JRE image
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copy the JAR file into the container
COPY ./dockerfile/backend/backend.jar app.jar

# Expose the application port
EXPOSE 8082

# Run the JAR file
ENTRYPOINT ["java", "-jar", "app.jar"]
