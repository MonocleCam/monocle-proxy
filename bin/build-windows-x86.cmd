@ECHO ON
echo "******************************************************************"
echo "*             __  __  ___  _  _  ___   ___ _    ___              *"
echo "*            |  \/  |/ _ \| \| |/ _ \ / __| |  | __|             *"
echo "*            | |\/| | (_) | .` | (_) | (__| |__| _|              *"
echo "*            |_|  |_|\___/|_|\_|\___/ \___|____|___|             *"
echo "*                                                                *"
echo "******************************************************************"
echo "*                   MONOCLE PROXY SERVER BUILD                   *"
echo "******************************************************************"

SET MONOCLE_CURRENT_DIRECTORY=%CD%
SET MONOCLE_SCRIPTS_DIRECTORY=%~dp0

CD %MONOCLE_SCRIPTS_DIRECTORY%
CD ..
SET MONOCLE_PROJECT_DIRECTORY=%CD%
SET MONOCLE_TARGET_DIRECTORY=%CD%\target
SET MONOCLE_SOURCE_DIRECTORY=%CD%\src
SET MONOCLE_DIST_DIRECTORY=%CD%\dist

SET MONOCLE_OS="windows"
SET MONOCLE_PLATFORM="x86"
SET MONOCLE_ARCH="x86"

SET COMPANY_NAME="shadeBlue, LLC"
SET MONOCLE_PROJECT_NAME="Monocle Proxy (x86)"
SET MONOCLE_PROJECT_DESCRIPTION="Monocle Proxy Service (Windows x86)"
SET /p MONOCLE_PROJECT_VERSION=<%MONOCLE_PROJECT_DIRECTORY%\VERSION
SET /p MONOCLE_PROJECT_COPYRIGHT=<%MONOCLE_PROJECT_DIRECTORY%\COPYRIGHT

echo ""
echo ""
echo "********************************************************************************************"
echo "BUILD FOR OS       : %MONOCLE_OS%"
echo "BUILD FOR PLATFORM : %MONOCLE_PLATFORM%"
echo "BUILD FOR ARCH     : %MONOCLE_ARCH%"
echo "********************************************************************************************"
echo "CWD                : %MONOCLE_CURRENT_DIRECTORY%"
echo "PROJECT DIR        : %MONOCLE_PROJECT_DIRECTORY%"
echo "SCRIPTS DIR        : %MONOCLE_SCRIPTS_DIRECTORY%"
echo "TARGET DIR         : %MONOCLE_TARGET_DIRECTORY%"
echo "SOURCE  DIR        : %MONOCLE_SOURCE_DIRECTORY%"
echo "DIST DIR           : %MONOCLE_DIST_DIRECTORY%"
echo "COMPANY            : %COMPANY_NAME%"
echo "PROJECT NAME       : %MONOCLE_PROJECT_NAME%"
echo "PROJECT DESC       : %MONOCLE_PROJECT_DESCRIPTION%"
echo "PROJECT VERSION    : %MONOCLE_PROJECT_VERSION%"
echo "PROJECT COPYRIGHT  : %MONOCLE_PROJECT_COPYRIGHT%"
echo "********************************************************************************************"

echo ""
echo ""
echo ************************************
echo SETUP BUILD ENVIRONMENT
echo ************************************
call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" x86

echo ""
echo ""
echo ************************************
echo COPY SOURCE TO WORKING TARGET DIR
echo ************************************
mkdir %MONOCLE_TARGET_DIRECTORY%
xcopy /Y /E %MONOCLE_SOURCE_DIRECTORY% %MONOCLE_TARGET_DIRECTORY%  || EXIT /B 1

echo ""
echo ""
echo ************************************
echo GENERATE MAKFILES
echo ************************************
cd %MONOCLE_TARGET_DIRECTORY%                              || EXIT /B 1
call genWindowsMakefiles.cmd                               || EXIT /B 1

echo ""
echo ""
echo ************************************
echo COMPILE LIVE555 SOURCES
echo ************************************

cd %MONOCLE_TARGET_DIRECTORY%\UsageEnvironment             || EXIT /B 1
nmake -f UsageEnvironment.mak clean all                    || EXIT /B 1

cd %MONOCLE_TARGET_DIRECTORY%\groupsock                    || EXIT /B 1
nmake -f groupsock.mak clean all                           || EXIT /B 1

cd %MONOCLE_TARGET_DIRECTORY%\liveMedia || EXIT /B 1
nmake -f liveMedia.mak clean all                           || EXIT /B 1

cd %MONOCLE_TARGET_DIRECTORY%\BasicUsageEnvironment        || EXIT /B 1
nmake -f BasicUsageEnvironment.mak clean all               || EXIT /B 1

echo ""
echo ""
echo ************************************
echo COMPILE LIVE555 PROXY SERVER
echo ************************************
cd %MONOCLE_TARGET_DIRECTORY%\proxyServer                  || EXIT /B 1
nmake -f proxyServer.mak clean all                         || EXIT /B 1

echo ""
echo ""
echo ************************************
echo COMPILE LIVE555 TEST PROGRAMS
echo ************************************
cd %MONOCLE_TARGET_DIRECTORY%\testProgs                    || EXIT /B 1
nmake -f testProgs.mak clean all                           || EXIT /B 1

echo ""
echo ""
echo ************************************
echo COMPILE MONOCLE-PROXY
echo ************************************
cd %MONOCLE_TARGET_DIRECTORY%\monocle-proxy                || EXIT /B 1
nmake -f monocle-proxy.mak clean all                       || EXIT /B 1

echo ""
echo ""
echo ************************************
echo UPDATE MONOCLE-PROXY RESOURCES
echo ************************************
rcedit-x86.exe  ^
     %MONOCLE_TARGET_DIRECTORY%\monocle-proxy\monocle-proxy.exe    ^
     --set-icon "%MONOCLE_SCRIPTS_DIRECTORY%\monocle.ico"          ^
     --set-product-version %MONOCLE_PROJECT_VERSION%               ^
     --set-file-version %MONOCLE_PROJECT_VERSION%                  ^
     --set-version-string "CompanyName" %COMPANY_NAME%             ^
     --set-version-string "ProductName" %MONOCLE_PROJECT_NAME%     ^
     --set-version-string "FileDescription" %MONOCLE_PROJECT_DESCRIPTION% ^
     --set-version-string "OriginalFilename" "monocle-proxy.exe"   ^
     --set-version-string "InternalName" "monocle-proxy"           ^
     --set-version-string "LegalCopyright" %MONOCLE_PROJECT_COPYRIGHT%

echo ""
echo ""
echo ************************************
echo COPY FILES TO FINAL DISTRIBUTION LOCATION
echo ************************************
mkdir %MONOCLE_DIST_DIRECTORY%                             || EXIT /B 1
copy %MONOCLE_TARGET_DIRECTORY%\proxyServer\live555ProxyServer.exe %MONOCLE_DIST_DIRECTORY%\live555ProxyServer-windows-x86.exe || EXIT /B 1
copy %MONOCLE_TARGET_DIRECTORY%\testProgs\openRTSP.exe %MONOCLE_DIST_DIRECTORY%\openRTSP-windows-x86.exe                       || EXIT /B 1
copy %MONOCLE_TARGET_DIRECTORY%\monocle-proxy\monocle-proxy.exe %MONOCLE_DIST_DIRECTORY%\monocle-proxy-windows-x86.exe         || EXIT /B 1

echo ""
echo ""
echo ************************************
echo FINISHED
echo ************************************
cd %MONOCLE_CURRENT_DIRECTORY%
