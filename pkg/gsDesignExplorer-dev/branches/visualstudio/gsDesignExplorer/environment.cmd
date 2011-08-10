@echo Configuring environment to build gsDesignExplorer with nmake using settings from environment.cmd

@echo off
rem http://www.uberullu.com/alias-in-windows-command-line-ms-dos-how-to/
rem HKEY_CURRENT_USER\Software\Microsoft\Command Processor
rem String value -> autorun = c:\dev\cmd\profile.cmd

rem use %CWD% as a prefix to create fully-qualified paths
set CWD=echo cd

rem PATH TO VISUAL STUDIO TOOLCHAIN
rem ===============================
set INCLUDE=C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\INCLUDE;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\ATLMFC\INCLUDE;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\include;
set LIB=C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\LIB;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\ATLMFC\LIB;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\lib;
set LIBPATH=C:\Windows\Microsoft.NET\Framework\v4.0.30319;C:\Windows\Microsoft.NET\Framework\v3.5;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\LIB;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\ATLMFC\LIB;
set VSPATH=C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\BIN;C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\Tools;C:\Windows\Microsoft.NET\Framework\v4.0.30319;C:\Windows\Microsoft.NET\Framework\v3.5;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\VCPackages;C:\Program Files (x86)\Microsoft Visual Studio 10.0\Team Tools\Performance Tools;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\bin\NETFX 4.0 Tools;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\bin;


rem PATH TO INSTALLED TOOLS
rem =======================
set RPATH=C:\dev\tools\R\R-2.13.1
rem set RTOOLS=C:\dev\tools\Rtools
rem set QTDIR=C:\QtSDK\Desktop\Qt\4.7.3\MSVC2008

rem PATH TO VERSIONED TOOLS
rem =======================
set QTDIR=%CWD%\libs\msvc\Qt\4.7.3\msvc2008



set PATH=%VSPATH%;%QTDIR%\bin;%RPATH%\bin;%PATH%;C:\dev\tools\cmake\cmake-2.8.4\bin

