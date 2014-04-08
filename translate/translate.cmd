@echo off
native2ascii -encoding utf-8 ResourceBundle_lt.properties failas
del ResourceBundle_lt.properties
ren failas ResourceBundle_lt.properties