// Copyright (C) 2009 Merck Research Laboratories and REvolution Computing, Inc.
//
//	This file is part of gsDesignExplorer.
//
//  gsDesignExplorer is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.

//  gsDesignExplorer is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

//  You should have received a copy of the GNU General Public License
//  along with gsDesignExplorer.  If not, see <http://www.gnu.org/licenses/>.
#ifndef _GS_DESIGNGUI_H_
#define _GS_DESIGNGUI_H_


#if defined( _MSC_VER )

	#define WIN32_LEAN_AND_MEAN             // Exclude rarely-used stuff from Windows headers
	// Windows Header Files:
	#include <windows.h>

	#ifdef ERROR
		#undef ERROR
	#endif


	#if defined(GSDESIGNGUI_EXPORTS)

		#define Gsd_Export_C extern "C"  __declspec( dllexport ) 
		#define Gsd_Export __declspec( dllexport ) 

	#else // !defined(GSDESIGNGUI_EXPORTS)

		#define Gsd_Export_C extern "C" __declspec( dllimport )
		#define Gsd_Export __declspec( dllimport )

	#endif // defined(GSDESIGNGUI_EXPORTS)


#else // !(defined(_MSC_VER)

	#define Gsd_Export_C extern "C" 
	#define Gsd_Export 

#endif // defined(_MSC_VER)

#include <iostream>
#include <sstream>
#include <string>
#include <list>
#include <map>

#include <stdexcept>
#include <vector>

using namespace std;

#include <R.h>
#include <Rinternals.h>

Gsd_Export_C SEXP LaunchGSDesignExplorer();

#if defined( _GSDESIGNGUI_EXE_) || defined( GSDESIGNGUI_EXPORTS )
// The functions are seen by the .EXE for testing
Gsd_Export int GsdStartup();
#endif // defined( _GSDESIGNGUI_EXE_ || GSDESIGNGUI_EXPORTS )


#endif // _GS_DESIGNGUI_H_
