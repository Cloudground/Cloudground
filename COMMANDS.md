

Build and push Spring microservice
```
cd Cloudground/spring
docker build --build-arg JAR_FILE=build/libs/spring-0.0.1.jar -t cloudground-spring .
docker run -p 8080:8080 cloudground-spring
```

Build and push Go microservice
```
cd Cloudground/go/src
docker build -t cloudground-go .
docker run -p 8090:8090 cloudground-go
```

Build and push NodeJS microservice
```
cd Cloudground/nodejs
docker build -t cloudground-nodejs .
docker run -p 8070:8070 cloudground-nodejs
```

