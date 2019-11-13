FROM busayr/java-base
ADD app.jar .
ENV HEAP_SIZE 256m
CMD java -Xms$HEAP_SIZE -Xmx$HEAP_SIZE -jar app.jar