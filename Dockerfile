# syntax=docker/dockerfile:1

# cached dependencies

FROM eclipse-temurin:17-jdk-jammy as base
WORKDIR /app
COPY .mvn/ .mvn
COPY mvnw ./
COPY pom.xml ./
RUN chmod a+rx ./mvnw
RUN ./mvnw dependency:go-offline
COPY src ./src

FROM base as build
RUN chmod a+rx ./mvnw
RUN ./mvnw package

FROM eclipse-temurin:17-jre-jammy as production
EXPOSE 8081
COPY --from=build /app/target/spring-petclinic-*.jar /spring-petclinic.jar
CMD ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/spring-petclinic.jar"]
