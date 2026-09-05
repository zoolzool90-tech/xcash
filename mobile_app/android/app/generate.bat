@echo off
echo Generating key.jks...
keytool -genkey -v -keystore key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key -storepass 123456 -keypass 123456 -dname "CN=Walid, OU=XCash, O=XCash, L=Dubai, ST=Dubai, C=AE"
pause