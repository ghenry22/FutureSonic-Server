@echo off
mvn clean install -P full
cd futuresonic-installer-windows
mvn package
pause