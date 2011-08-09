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
#define _USE_R_HEADERS_
#include "GsRList.h"
#include <R_ext/Parse.h>
#include "Rcpp.hpp"

bool GsRList::m_bAllowRunDesign = false;
bool GsRList::m_bAllowEval = true;

const char *GsRList::m_pszListName = "..xgsDesignListRaw";

// This is a class that guarantees that unprotect will
// be called properly within a function regardless of 
// how the function exits.
class GsRProtect
{
public:
    int m_iProtected;

    GsRProtect():
            m_iProtected(0)
    {
    }

    ~GsRProtect()
    {
        if (m_iProtected > 0)
        {
            UNPROTECT(m_iProtected);
        }
    }


    void Protect(RListPtr ptr)
    {
        PROTECT( ptr );
        m_iProtected++;
    }

};

bool IsRClass(SEXP s, const char *pszClass)
{
    SEXP klass;
    int i;
    if (OBJECT(s)) {
	klass = getAttrib(s, R_ClassSymbol);
	for (i = 0; i < length(klass); i++)
	    if (!strcmp(CHAR(STRING_ELT(klass, i)), pszClass)) 
                return true;
    }
    return false;
}

static inline bool EmptyStr(const char *pszStr)
{
    if (pszStr && *pszStr)
    {
        return false;
    }
    else
        return true;

}

class RcppParamsExt : public RcppParams 
{
public:
    RcppParamsExt(SEXP params) :
            RcppParams( params )
    {
    }

    SEXP getSEXP(string name)
    {
        map<string,int>::iterator iter = pmap.find(name);
        if(iter == pmap.end()) {
            string mesg = "GetSEXP: no such name: ";
            throw std::range_error(mesg+name);
        }
        int posn = iter->second;
        SEXP elt = VECTOR_ELT(_params,posn);
        return elt;

    }
};


GsRList::GsRList() :
	m_RList( 0 ),
	m_RListNames( 0 ),
	m_iNumProtected( 0 ),
	m_iCurrentElement( 0 )
{
}

GsRList::GsRList(int iNumElements) :
	m_RList( 0 ),
	m_RListNames( 0 ),
	m_iNumProtected( 0 ),
	m_iCurrentElement( 0 )
{
	Init(iNumElements);
}

GsRList::~GsRList()
{
	if (m_iNumProtected > 0)
	{
		UNPROTECT(m_iNumProtected);
	}
}

void GsRList::Init(int iNumElements)
{
	if (m_RList != NULL)
	{
		return;
	}
	PROTECT(m_RList = allocVector(VECSXP, iNumElements));
	m_iNumProtected++;

	PROTECT(m_RListNames = allocVector(STRSXP, iNumElements));
	m_iNumProtected++;
}

void GsRList::AddElement(const char *pszName, const char *pszElement)
{
	if (m_RList == NULL)
	{
		return;
	} 
    SEXP strElement = PROTECT(allocVector(STRSXP, 1));
    m_iNumProtected++;
    SET_STRING_ELT(strElement, 0, mkChar(pszElement));
	SET_VECTOR_ELT(m_RList, m_iCurrentElement, strElement);

	SET_STRING_ELT(m_RListNames, m_iCurrentElement, mkChar(pszName));

	m_iCurrentElement++;
}

RListPtr GsRList::GetRList()
{
    setAttrib(m_RList, R_NamesSymbol, m_RListNames);
	return m_RList;
}

// Utility class to prevent re-entering R's eval() function. 
// This does not required knowledge of the threading code being used,
// and does not have the danger of deadlock, but it has the disadvantage
// that the code accessing eval() just returns, as opposed to waiting
// for access. It will set the m_bAllowEval flag to false, and then
// back to true when it is destroyed when the function exists,
// thus temporarily blocking access to this function. 
class DenyEvalAccess
{
public:

    DenyEvalAccess()
    {
        GsRList::m_bAllowEval = false;
    }

    ~DenyEvalAccess()
    {
        GsRList::m_bAllowEval = true;
    }

    static bool Check()
    {
        return !GsRList::m_bAllowEval;
    }

};

std::string EvaluateRExpression(const char *pszRCmd) 
{
    std::string returnString;
    if (DenyEvalAccess::Check())
        return returnString;

    if (!pszRCmd || (strlen(pszRCmd) == 0))
        return returnString;

    DenyEvalAccess denyEvalAccess;

    SEXP rpszRCmd, expr, ans=R_NilValue;
    ParseStatus status;
    int i;

    std::string strFullRCmd = "try(toString(eval(parse(text=\"";
    strFullRCmd.append(pszRCmd);
    strFullRCmd.append("\"))), silent = TRUE)");
    GsRProtect gsrp;

    gsrp.Protect(rpszRCmd = mkString(strFullRCmd.c_str()));
    gsrp.Protect(expr = R_ParseVector(rpszRCmd, -1, &status, R_NilValue));
    if (status == PARSE_OK)
    {
        for(i = 0; i < length(expr); i++)
        {
            ans=eval(VECTOR_ELT(expr, i), R_GlobalEnv);
            returnString.append( std::string((char*)CHAR(STRING_ELT(ans,0))) );
        }
    }

    return returnString;
}


bool GsDesignResults::FillAnalysisNI(RListPtr sexpAnalysisNI)
{
    if (sexpAnalysisNI!= R_NilValue)
    {
        if (!isReal(sexpAnalysisNI))
        {
            return false;
        }
        int len = length(sexpAnalysisNI);
        m_piAnalysisNI = new double[len];
        m_iLenAnalysisNI = len;
        for (int i = 0; i < len; i++)
        {
            m_piAnalysisNI[i] = REAL(sexpAnalysisNI)[i];
        }

    }
    return true;
}


bool GsRList::RunDesign(GsDesignResults &rgsdResults, 
                        const char *pszPlotPath,
                        const char *pszPlotBackground)

{
    if (!m_bAllowRunDesign || DenyEvalAccess::Check())
        return true;


    DenyEvalAccess denyEvalAccess;

    GsRProtect gsrp;
    bool bRet = false;
    try
    {
        RListPtr rList = GetRList();
        defineVar(install(m_pszListName), rList, R_GlobalEnv);

        SEXP rpszRCmd, expr, ans=R_NilValue;
        ParseStatus status;
        std::string strFullRCmd = "try(eval(parse(text=\"runDesign(";
        strFullRCmd.append(m_pszListName);

        if (!EmptyStr(pszPlotPath))
        {
            strFullRCmd.append(",plotPath='");
            strFullRCmd.append(pszPlotPath);
            strFullRCmd.append("'");
        }
        strFullRCmd.append(",plotBackground='");
        strFullRCmd.append(pszPlotBackground);
        strFullRCmd.append("')\")), silent = TRUE)");

        gsrp.Protect(rpszRCmd = mkString(strFullRCmd.c_str()));
        gsrp.Protect(expr = R_ParseVector(rpszRCmd, -1, &status, R_NilValue));
        if (status == PARSE_OK)
        {
            if (length(expr) == 1)
            {
                ans=eval(VECTOR_ELT(expr, 0), R_GlobalEnv);

                if (IsRClass(ans, "try-error"))
                {
                    rgsdResults.m_sTextOutput = CHAR(STRING_ELT(ans,0));
                    return false;
                }
                else
                {
                    RcppParamsExt rp(ans);

                    rgsdResults.m_sTextOutput = rp.getStringValue("text");
                    rgsdResults.m_sNameOfPlotOutput = rp.getStringValue("plot");
                    rgsdResults.m_fixedSampleSize = rp.getIntValue("fixedSampleSize");
                    rgsdResults.m_fixedEvents = rp.getIntValue("fixedEvents");
                    rgsdResults.m_analysisMaxnIPlan = rp.getDoubleValue("analysisMaxnIPlan");

                    if (!rgsdResults.FillAnalysisNI(rp.getSEXP("analysisNI")))
                    {
                        rgsdResults.m_sTextOutput = "Error in analysisNI vector. Expecting REAL.";
                        return false;
                    }
                    return true;

                }
            }
            else // != 1
            {
                bRet = false;
            }
        }
    }
    catch(...)
    {
        bRet = false;
    }

    if (bRet == false)
    {
        rgsdResults.m_sTextOutput = "Error executing 'runDesign()'.";
    }

    return bRet;
}

bool GsRList::ExportDesign(
        GsDesignResults &rgsdResults,
        const char *pszFileName,
        bool bAppend,
        bool bWriteHeader,
        const char *pszDesignGUIVersion
        )

{
    bool bRet = false;
    if (DenyEvalAccess::Check())
        return bRet;

    DenyEvalAccess denyEvalAccess;

    GsRProtect gsrp;
    try
    {
        RListPtr rList = GetRList();
        defineVar(install(m_pszListName), rList, R_GlobalEnv);

        SEXP rpszRCmd, expr, ans=R_NilValue;
        ParseStatus status;
        std::string strFullRCmd = "try(eval(parse(text=\"exportDesign(";
        strFullRCmd.append(m_pszListName);

        // file
        if (!EmptyStr(pszFileName))
        {
            strFullRCmd.append(",file='");
            strFullRCmd.append(pszFileName);
            strFullRCmd.append("'");
        }
        else
        {
            rgsdResults.m_sTextOutput = "Error: No file name has been specified for 'exportDesign()'";
            return false;

        }

        // append
        strFullRCmd.append(",append=");
        strFullRCmd.append(bAppend ? "TRUE" : "FALSE");

        // writeHeader
        strFullRCmd.append(",writeHeader=");
        strFullRCmd.append(bWriteHeader ? "TRUE" : "FALSE");

        if (!EmptyStr(pszDesignGUIVersion))
        {
            strFullRCmd.append(",gsDesignGUIVersion='");
            strFullRCmd.append(pszDesignGUIVersion);
            strFullRCmd.append("'");
        }

        // terminate command
        strFullRCmd.append(")\")), silent = TRUE)");

        gsrp.Protect(rpszRCmd = mkString(strFullRCmd.c_str()));
        gsrp.Protect(expr = R_ParseVector(rpszRCmd, -1, &status, R_NilValue));
        if (status == PARSE_OK)
        {
            if (length(expr) == 1)
            {
                ans=eval(VECTOR_ELT(expr, 0), R_GlobalEnv);

                if (IsRClass(ans, "try-error"))
                {
                    rgsdResults.m_sTextOutput = CHAR(STRING_ELT(ans,0));
                    return false;
                }
                else
                {
                    return true;

                }
            }
            else // != 1
            {
                bRet = false;
            }
        }
    }
    catch(...)
    {
        bRet = false;
    }

    if (bRet == false)
    {
        rgsdResults.m_sTextOutput = "Error: There was an error executing 'exportDesign()'.";
    }

    return bRet;
}

