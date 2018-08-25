FROM zenika/alpine-kotlin

VOLUME /tmp
COPY build/libs/spring-*.jar cloudground-spring.jar
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/cloudground-spring.jar"]

EXPOSE 8080
