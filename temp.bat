@echo off
chcp 65001
:: 配置
set APK=app-release.apk
set DIR=app_decoded
set UNSIGNED=unsigned.apk
set SIGNED=signed.apk
set KEY=test.jks
set ALIAS=test
set PWD=123456

echo 1.解包  2.重编译  3.签名对齐  4.安装  5.一键全流程  6.生成证书
set /p opt=请输入序号:

if %opt%==1 (
java -jar apktool.jar d %APK% -o %DIR%
echo 解包完成，修改 %DIR% 内文件后再打包
pause
)
if %opt%==2 (
java -jar apktool.jar b %DIR% -o %UNSIGNED%
echo 重编译完成，未签名包:%UNSIGNED%
pause
)
if %opt%==3 (
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore %KEY% -storepass %PWD% -keypass %PWD% %UNSIGNED% %ALIAS%
zipalign -v 4 %UNSIGNED% %SIGNED%
echo 签名成品:%SIGNED%
pause
)
if %opt%==4 (
adb install -r %SIGNED%
echo 安装完成，打开APP验证修改效果
pause
)
if %opt%==5 (
echo ====== 开始解包 ======
java -jar apktool.jar d %APK% -o %DIR%
echo 请修改smali/资源文件，改完按回车继续打包
pause
echo ====== 重编译 ======
java -jar apktool.jar b %DIR% -o %UNSIGNED%
echo ====== 签名对齐 ======
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore %KEY% -storepass %PWD% -keypass %PWD% %UNSIGNED% %ALIAS%
zipalign -v 4 %UNSIGNED% %SIGNED%
echo ====== 安装验证 ======
adb install -r %SIGNED%
echo 全部流程执行完毕！成品：%SIGNED%
pause
)
if %opt%==6 (
keytool -genkey -v -keystore %KEY% -alias %ALIAS% -keyalg RSA -keysize 2048 -validity 36500 -storepass %PWD% -keypass %PWD% -dname "CN=Student,OU=Software,O=School,C=CN"
echo 证书 %KEY% 生成完成
pause
)