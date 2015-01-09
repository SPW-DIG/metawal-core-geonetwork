## Build the application

```
mvn clean install -DskipTests -Penv-dev,widgets -Dclosure.path=/app/closure-library
```


## Run the application

```
mvn jetty:run -Penv-dev,widgets,ui
```
