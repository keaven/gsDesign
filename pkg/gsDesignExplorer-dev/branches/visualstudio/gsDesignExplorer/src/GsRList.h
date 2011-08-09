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
#ifndef _GsRList_H_
#define _GsRList_H_

#include <iostream>
#include <sstream>
#include <string>
#include <list>
#include <map>

#include <stdexcept>
#include <vector>

using namespace std;


#if defined(_USE_R_HEADERS_)
	#include <R.h>
	#include <Rinternals.h>
	#define RListPtr SEXP
#else
	#define RListPtr void*
#endif // defined(_USE_R_HEADERS_)

class GsDesignResults
{
public:
	std::string m_sTextOutput;
	std::string m_sNameOfPlotOutput;
	int m_fixedSampleSize;
	int m_fixedEvents;
        double m_analysisMaxnIPlan;
	double* m_piAnalysisNI;
	int m_iLenAnalysisNI;

	GsDesignResults() :
		m_fixedSampleSize(0),
		m_fixedEvents(0),
		m_piAnalysisNI(NULL),
		m_iLenAnalysisNI(0)
	{
	}

	~GsDesignResults()
	{
		if (m_piAnalysisNI != NULL)
		{
			delete [] m_piAnalysisNI;
		}
	}

	bool FillAnalysisNI(RListPtr sexpAnalysisNI);

};

// Simple class to create an R list; 
// This allows the R headers to be hidden from the code that
// actually uses this class.
class GsRList
{
private:
	RListPtr m_RList;
	RListPtr m_RListNames;
        int m_iNumProtected;
        int m_iCurrentElement;

private:
	// Name of R list object that holds the values of the
	// fields in the interface
	static const char *m_pszListName;

public:
	// Controls whether or not RunDesign() can be called
	static bool m_bAllowRunDesign;

	// Controls whether or not R's eval() can be called
	static bool m_bAllowEval;


public:
	GsRList();
	GsRList(int iNumElements);
	void Init(int iNumElements);

	~GsRList();

	// Add a string element
	void AddElement(const char *pszName, const char *pszElement);

	// Fixes up and returns the list
	RListPtr GetRList();

	bool RunDesign(	GsDesignResults &rgsdResults, 
					const char *pszPlotPath = NULL, // IN: if not empty, will be used as the directory and name of plot
					const char *pszPlotBackground = "transparent" 
					);

	bool ExportDesign(
					GsDesignResults &rgsdResults,
					const char *pszFileName, 
					bool bAppend,
					bool bWriteHeader,
					const char *pszDesignGUIVersion
					);
						

};

// Takes an arbitrary expression, evaluates it in R, and
// converts the result to a string
std::string EvaluateRExpression(const char *pszRCmd);

#endif // _GsRList_H_
