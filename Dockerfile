FROM busayr/java-base
COPY target/*.jar /opt/app.jar
ENV HEAP_SIZE 512m
WORKDIR /opt
CMD java -Xms$HEAP_SIZE -Xmx$HEAP_SIZE -jar app.jar