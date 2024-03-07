ogr:
	javac ogr.java 2>&1 | grep -v Picked || true

run: ogr
	java ogr 2>&1 | grep -v Picked || true

ruler:
	javac ruler.java
	java ruler
