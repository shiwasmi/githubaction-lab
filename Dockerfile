# Stage 1: Build with Maven
FROM maven:3.9.6-eclipse-temurin-21 AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Deploy with Tomcat
FROM tomcat:9.0.82-jdk21-temurin

# Set maintainer label (optional)
LABEL maintainer="sagar.chattar@example.com"

# Remove default ROOT app
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Create a non-root user
RUN useradd -m githubaction-lab

# Copy the WAR produced by Maven into Tomcat
COPY --from=builder /app/target/githubaction-lab*.jar /usr/local/tomcat/webapps/

# Expose Tomcat port
EXPOSE 8080

# Run as non-root user
USER githubaction-lab

# Default command to run Tomcat
CMD ["catalina.sh", "run"]