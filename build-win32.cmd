@echo off
SET JAVA_HOME=C:\jdk
mvn clean install -P full
cd futuresonic-installer-windows
mvn package
pause