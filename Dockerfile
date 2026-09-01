# Etapa 1: Construir el proyecto con Maven
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa 2: Usar Tomcat 9 (soporta javax.servlet) para ejecutar el WAR
FROM tomcat:9-jdk17
WORKDIR /usr/local/tomcat/webapps/
COPY --from=build /app/target/*.war ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]