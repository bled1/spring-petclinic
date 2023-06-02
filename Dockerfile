# syntax=docker/dockerfile:1

FROM eclipse-temurin:17-jdk-jammy AS base
WORKDIR /app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN chmod a+rx ./mvnw
RUN ./mvnw dependency:resolve
COPY src ./src

# FROM base as development
# RUN chmod a+rx ./mvnw
# CMD ["./mvnw", "spring-boot:run", "-Dspring-boot.run.profiles=mysql", "-Dspring-boot.run.jvmArguments='-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8000'"]

FROM base AS build
RUN chmod a+rx ./mvnw
RUN ./mvnw package

FROM eclipse-temurin:17-jre-jammy AS production
EXPOSE 8081
COPY --from=build /app/target/spring-petclinic-*.jar /spring-petclinic.jar
CMD ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/spring-petclinic.jar"]