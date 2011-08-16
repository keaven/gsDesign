# =========================================================
# Environment macros
# =========================================================

# gsDesignExplorer project base directory
PROJECTROOT=$(MAKEDIR)

# PATH TO VISUAL STUDIO TOOLCHAIN
# ===============================
INCLUDE=C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\INCLUDE;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\ATLMFC\INCLUDE;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\include;
LIB=C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\LIB;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\ATLMFC\LIB;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\lib;
LIBPATH=C:\Windows\Microsoft.NET\Framework\v4.0.30319;C:\Windows\Microsoft.NET\Framework\v3.5;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\LIB;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\ATLMFC\LIB;
VSPATH=C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\BIN;C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\Tools;C:\Windows\Microsoft.NET\Framework\v4.0.30319;C:\Windows\Microsoft.NET\Framework\v3.5;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\VCPackages;C:\Program Files (x86)\Microsoft Visual Studio 10.0\Team Tools\Performance Tools;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\bin\NETFX 4.0 Tools;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\bin;

# PATH TO INSTALLED TOOLS
# =======================
RPATH=C:\dev\tools\R\R-2.13.1
# RTOOLS=C:\dev\tools\Rtools
# QTDIR=C:\QtSDK\Desktop\Qt\4.7.3\MSVC2008

# PATH TO VERSIONED TOOLS
# =======================
QTDIR=$(PROJECTROOT)\libs\msvc\Qt\4.7.3\msvc2008

# Final path
PATH=$(VSPATH);$(QTDIR)\bin;$(RPATH)\bin;$(PATH);C:\dev\tools\cmake\cmake-2.8.4\bin


# =========================================================
# Targets
# =========================================================

all : setenv
	cd ..
	R CMD INSTALL --no-clean-on-error gsDesignExplorer

# Ensure that we set the shell environment to match
setenv :
	set INCLUDE=$(INCLUDE)
	set LIB=$(LIB)
	set LIBPATH=$(LIBPATH)
	set PATH=$(PATH)
	set QTDIR=$(QTDIR)
	set RPATH=$(RPATH)
	set VSPATH=$(VSPATH)

# Display the shell environment for this make session
dispenv : setenv
	@echo =========================
	@echo nmake session environment
	@echo =========================
	set

create-r-import-lib : setenv
	pushd $(RPATH)\bin\i386
	$(PROJECTROOT)\tools\DLLImportTool\ImgDef.exe R.dll > R.def
	popd
	mv $(RPATH)\bin\i386\R.def $(PROJECTROOT)\libs\msvc\R\R-2.13.1
	lib /machine:x86 /subsystem:windows /def:$(PROJECTROOT)\libs\msvc\R\R-2.13.1\R.def /out:$(PROJECTROOT)\libs\msvc\R\R-2.13.1\R.lib


