@echo off
taskkill /f /im explorer.exe
attrib "%userprofile%\appdata\local\iconcache.db" -s -r -h
del /q "%userprofile%\appdata\local\iconcache.db"
start explorer.exe
exit
