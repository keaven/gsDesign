@echo Configuring environment to build gsDesignExplorer with nmake using settings from environment.cmd

@echo off
rem http://www.uberullu.com/alias-in-windows-command-line-ms-dos-how-to/
rem HKEY_CURRENT_USER\Software\Microsoft\Command Processor
rem String value -> autorun = c:\dev\cmd\profile.cmd

rem gsDesignExplorer project base directory
set PROJECTROOT=%CD%

rem ===============================
rem PATH TO VISUAL STUDIO TOOLCHAIN
rem ===============================

rem Visual Studio 2008
set INCLUDE=C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\INCLUDE;C:\Program Files\\Microsoft SDKs\Windows\v6.0A\include;
set LIB=C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\LIB;C:\Program Files\\Microsoft SDKs\Windows\v6.0A\lib;
set LIBPATH=C:\Windows\Microsoft.NET\Framework\v3.5;C:\Windows\Microsoft.NET\Framework\v2.0.50727;C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\LIB;
set VSPATH=C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE;C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\BIN;C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\Tools;C:\Windows\Microsoft.NET\Framework\v3.5;C:\Windows\Microsoft.NET\Framework\v2.0.50727;C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\VCPackages;C:\Program Files\\Microsoft SDKs\Windows\v6.0A\bin;C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\BIN;C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\Tools;C:\Windows\Microsoft.NET\Framework\v4.0.30319;C:\Windows\Microsoft.NET\Framework\v3.5;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\VCPackages;C:\Program Files (x86)\Microsoft Visual Studio 10.0\Team Tools\Performance Tools;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\bin\NETFX 4.0 Tools;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\bin;C:\dev\cmd;C:\QtSDK\Desktop\Qt\4.7.3\msvc2008\bin;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Program Files (x86)\Notepad++;C:\Program Files\SlickEditV16.0.1 x64\win\ ;C:\Program Files\SlickEditV16.0.1 x64\win\;c:\dev\cmd


rem Visual Studio 2010
rem set INCLUDE=C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\INCLUDE;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\ATLMFC\INCLUDE;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\include;
rem set LIB=C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\LIB;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\ATLMFC\LIB;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\lib;
rem set LIBPATH=C:\Windows\Microsoft.NET\Framework\v4.0.30319;C:\Windows\Microsoft.NET\Framework\v3.5;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\LIB;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\ATLMFC\LIB;
rem set VSPATH=C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\BIN;C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\Tools;C:\Windows\Microsoft.NET\Framework\v4.0.30319;C:\Windows\Microsoft.NET\Framework\v3.5;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\VCPackages;C:\Program Files (x86)\Microsoft Visual Studio 10.0\Team Tools\Performance Tools;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\bin\NETFX 4.0 Tools;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\bin;c:\dev\cmd


rem =======================
rem PATH TO INSTALLED TOOLS
rem =======================
set RPATH=C:\dev\tools\R\R-2.13.1
rem set RTOOLS=C:\dev\tools\Rtools
rem set QTDIR=C:\QtSDK\Desktop\Qt\4.7.3\MSVC2008

rem =======================
rem PATH TO VERSIONED TOOLS
rem =======================
set QTDIR=%PROJECTROOT%\libs\msvc\Qt\4.7.3\msvc2008


set PATH=%VSPATH%;%QTDIR%\bin;%RPATH%\bin;%PATH%;C:\dev\tools\cmake\cmake-2.8.4\bin

