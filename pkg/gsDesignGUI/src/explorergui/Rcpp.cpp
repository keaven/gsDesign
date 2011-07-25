// Rcpp.cpp: Part of the R/C++ interface class library, Version 5.0
//
// Copyright (C) 2005-2006 Dominick Samperi
//
// This library is free software; you can redistribute it and/or modify it 
// under the terms of the GNU Lesser General Public License as published by 
// the Free Software Foundation; either version 2.1 of the License, or (at 
// your option) any later version.
//
// This library is distributed in the hope that it will be useful, but 
// WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
// or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public 
// License for more details.
//
// You should have received a copy of the GNU Lesser General Public License 
// along with this library; if not, write to the Free Software Foundation, 
// Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA 

#include "Rcpp.hpp"

RcppParams::RcppParams(SEXP params) {
    if(!isNewList(params))
	throw std::range_error("RcppParams: non-list passed to constructor");
    int len = length(params);
    SEXP names = getAttrib(params, R_NamesSymbol);
    if(names == R_NilValue)
	throw std::range_error("RcppParams: list must have named elements");
    for(int i = 0; i < len; i++) {
	string nm = string(CHAR(STRING_ELT(names,i)));
	if(nm.size() == 0)
	    throw std::range_error("RcppParams: all list elements must be named");
	pmap[nm] = i;
    }
    _params = params;
}

void RcppParams::checkNames(char *inputNames[], int len) {
    for(int i = 0; i < len; i++) {
	map<string,int>::iterator iter = pmap.find(inputNames[i]);
	if(iter == pmap.end()) {
	    string mesg = "checkNames: missing required parameter ";
	    throw range_error(mesg+inputNames[i]);
	}
    }
}

RcppFrame::RcppFrame(SEXP df) {
    if(!isNewList(df))
	throw std::range_error("RcppFrame::RcppFrame: invalid data frame.");
    int ncol = length(df);
    SEXP names = getAttrib(df, R_NamesSymbol);
    colNames.resize(ncol);
    SEXP colData = VECTOR_ELT(df,0); // First column of data.
    int nrow = length(colData);
    if(nrow == 0)
	throw std::range_error("RcppFrame::RcppFrame: zero lenth column.");

    // Allocate storage for table.
    table.resize(nrow);
    for(int r = 0; r < nrow; r++)
	table[r].resize(ncol);
    
    for(int i=0; i < ncol; i++) {
	colNames[i] = string(CHAR(STRING_ELT(names,i)));
	SEXP colData = VECTOR_ELT(df,i);
	if(!isVector(colData) || length(colData) != nrow)
	    throw std::range_error("RcppFrame::RcppFrame: invalid column.");

	// Check for Date class. Currently R stores the date ordinal in a
	// real value. We check for Date under both Real and Integer values
	// as insurance against future changes.
	bool isDateClass = false;
	SEXP classname = getAttrib(colData, R_ClassSymbol);
	if(classname != R_NilValue)
	    isDateClass = (strcmp(CHAR(STRING_ELT(classname,0)),"Date") == 0);

	if(isReal(colData)) {
	    if(isDateClass) {
		for(int j=0; j < nrow; j++) // Column of Date's
		    table[j][i].setDateValue(RcppDate((int)REAL(colData)[j]));
	    }
	    else // Column of REAL's
		for(int j=0; j < nrow; j++)
		    table[j][i].setDoubleValue(REAL(colData)[j]);
	}
	else if(isInteger(colData)) {
	    if(isDateClass) {
		for(int j=0; j < nrow; j++) // Column of Date's
		    table[j][i].setDateValue(RcppDate(INTEGER(colData)[j]));
	    }
	    else
		for(int j=0; j < nrow; j++)
		    table[j][i].setIntValue(INTEGER(colData)[j]);
	}
	else if(isString(colData)) { // Non-factor string column
	    for(int j=0; j < nrow; j++)
		table[j][i].setStringValue(string(CHAR(STRING_ELT(colData,j))));
	}
	else if (isFactor(colData)) { // Factor column.
	    SEXP names = getAttrib(colData, R_LevelsSymbol);
	    int numLevels = length(names);
	    string *levelNames = new string[numLevels];
	    for(int k=0; k < numLevels; k++)
		levelNames[k] = string(CHAR(STRING_ELT(names,k)));
	    for(int j=0; j < nrow; j++)
		table[j][i].setFactorValue(levelNames, numLevels,
					   INTEGER(colData)[j]);
	    delete [] levelNames;
	}
	else if(isLogical(colData)) {
	    for(int j=0; j < nrow; j++) {
		table[j][i].setLogicalValue(INTEGER(colData)[j]);
	    }
	}
	else
	    throw std::range_error("RcppFrame::RcppFrame: unsupported data frame column type.");
    }
}

double RcppParams::getDoubleValue(string name) {
    map<string,int>::iterator iter = pmap.find(name);
    if(iter == pmap.end()) {
	string mesg = "getDoubleValue: no such name: ";
	throw std::range_error(mesg+name);
    }
    int posn = iter->second;
    SEXP elt = VECTOR_ELT(_params,posn);
    if(!isNumeric(elt) || length(elt) != 1) {
	string mesg = "getDoubleValue: must be scalar ";
	throw std::range_error(mesg+name);
    }
    if(isInteger(elt))
	return (double)INTEGER(elt)[0];
    else if(isReal(elt))
	return REAL(elt)[0];
    else {
	string mesg = "getDoubleValue: invalid value for ";
	throw std::range_error(mesg+name);
    }
    return 0; // never get here
}

int RcppParams::getIntValue(string name) {
    map<string,int>::iterator iter = pmap.find(name);
    if(iter == pmap.end()) {
	string mesg = "getIntValue: no such name: ";
	throw std::range_error(mesg+name);
    }
    int posn = iter->second;
    SEXP elt = VECTOR_ELT(_params,posn);
    if(!isNumeric(elt) || length(elt) != 1) {
	string mesg = "getIntValue: must be scalar: ";
	throw std::range_error(mesg+name);
    }
    if(isInteger(elt))
	return INTEGER(elt)[0];
    else if(isReal(elt))
	return (int)REAL(elt)[0];
    else {
	string mesg = "getIntValue: invalid value for: ";
	throw std::range_error(mesg+name);
    }
    return 0; // never get here
}

bool RcppParams::getBoolValue(string name) {
    map<string,int>::iterator iter = pmap.find(name);
    if(iter == pmap.end()) {
	string mesg = "getBoolValue: no such name: ";
	throw std::range_error(mesg+name);
    }
    int posn = iter->second;
    SEXP elt = VECTOR_ELT(_params,posn);
    if(isLogical(elt))
	return INTEGER(elt)[0];
    else {
	string mesg = "getBoolValue: invalid value for: ";
	throw std::range_error(mesg+name);
    }
    return false; // never get here
}

string RcppParams::getStringValue(string name) {
    map<string,int>::iterator iter = pmap.find(name);
    if(iter == pmap.end()) {
	string mesg = "getStringValue: no such name: ";
	throw std::range_error(mesg+name);
    }
    int posn = iter->second;
    SEXP elt = VECTOR_ELT(_params,posn);
    if(isString(elt))
		return string(CHAR(STRING_ELT(elt,0)));
    else {
	string mesg = "getStringValue: invalid value for: ";
	throw std::range_error(mesg+name);
    }
    return ""; // never get here
}

RcppDate RcppParams::getDateValue(string name) {
    map<string,int>::iterator iter = pmap.find(name);
    if(iter == pmap.end()) {
	string mesg = "getDateValue: no such name: ";
	throw std::range_error(mesg+name);
    }
    int posn = iter->second;
    SEXP elt = VECTOR_ELT(_params,posn);
    if(!isNumeric(elt) || length(elt) != 1) {
	string mesg = "getDateValue: invalide date: ";
	throw std::range_error(mesg+name);
    }

    int d;
    if(isReal(elt)) // R stores julian value in a double.
	d = (int)REAL(elt)[0];
    else {
	string mesg = "getDateValue: invalid value for: ";
	throw std::range_error(mesg+name);
    }
    return RcppDate(d);
}

RcppDateVector::RcppDateVector(SEXP vec) {
    int i;
    if(!isNumeric(vec) || isMatrix(vec) || isLogical(vec))
	throw std::range_error("RcppVector: invalid numeric vector in constructor");
    int len = length(vec);
    if(len == 0)
	throw std::range_error("RcppVector: null vector in constructor");
    v = new RcppDate[len];
    for(i = 0; i < len; i++)
	v[i] = RcppDate((int)REAL(vec)[i]);
    length = len;
}

RcppStringVector::RcppStringVector(SEXP vec) {
    int i;
    if(isMatrix(vec) || isLogical(vec))
	throw std::range_error("RcppVector: invalid numeric vector in constructor");
    if(!isString(vec))
	throw std::range_error("RcppStringVector: invalid string");
    int len = length(vec);
    if(len == 0)
	throw std::range_error("RcppVector: null vector in constructor");
    v = new string[len];
    for(i = 0; i < len; i++)
	v[i] = string(CHAR(STRING_ELT(vec,i)));
    length = len;
}

template <typename T>
RcppVector<T>::RcppVector(SEXP vec) {
    int i;

    // The function isVector returns TRUE for vectors AND
    // matrices, so it does not distinguish. We could
    // check the dim attribute here to be sure that it
    // is not present (i.e., dimAttr == R_NilValue, not 0!).
    // But it is easier to simply check if it is set via
    // isMatrix (in which case we don't have a vector).
    if(!isNumeric(vec) || isMatrix(vec) || isLogical(vec))
	throw std::range_error("RcppVector: invalid numeric vector in constructor");
    len = length(vec);
    v = (T *)R_alloc(len, sizeof(T));
    if(isInteger(vec)) {
	for(i = 0; i < len; i++)
	    v[i] = (T)(INTEGER(vec)[i]);
    }	
    else if(isReal(vec)) {
	for(i = 0; i < len; i++)
	    v[i] = (T)(REAL(vec)[i]);
    }
}

template <typename T>
RcppVector<T>::RcppVector(int _len) {
    len = _len;
    v = (T *)R_alloc(len, sizeof(T));
    for(int i = 0; i < len; i++)
	v[i] = 0;
}

template <typename T>
T *RcppVector<T>::cVector() {
    T* tmp = (T *)R_alloc(len, sizeof(T));
    for(int i = 0; i < len; i++)
	tmp[i] = v[i];
    return tmp;
}

template <typename T>
vector<T> RcppVector<T>::stlVector() {
    vector<T> tmp(len);
    for(int i = 0; i < len; i++)
	tmp[i] = v[i];
    return tmp;
}

template <typename T>
RcppMatrix<T>::RcppMatrix(SEXP mat) {

    if(!isNumeric(mat) || !isMatrix(mat))
	throw std::range_error("RcppMatrix: invalid numeric matrix in constructor");

    // Get matrix dimensions
    SEXP dimAttr = getAttrib(mat, R_DimSymbol);
    dim1 = INTEGER(dimAttr)[0];
    dim2 = INTEGER(dimAttr)[1];

    // We guard against  the possibility that R might pass an integer matrix.
    // Can be prevented using R code: temp <- as.double(a), dim(temp) <- dim(a)
    int i,j;
    int isInt = isInteger(mat);
    T *m = (T *)R_alloc(dim1*dim2, sizeof(T));
    a = (T **)R_alloc(dim1, sizeof(T *));
    for(i = 0; i < dim1; i++)
	a[i] = m + i*dim2;
    if(isInt) {
	for(i=0; i < dim1; i++)
	    for(j=0; j < dim2; j++)
		a[i][j] = (T)(INTEGER(mat)[i+dim1*j]);
    }	
    else {
	for(i=0; i < dim1; i++)
	    for(j=0; j < dim2; j++)
		a[i][j] = (T)(REAL(mat)[i+dim1*j]);
    }	
}

template <typename T>
RcppMatrix<T>::RcppMatrix(int _dim1, int _dim2) {
    dim1 = _dim1;
    dim2 = _dim2;
    int i,j;
    T *m = (T *)R_alloc(dim1*dim2, sizeof(T));
    a = (T **)R_alloc(dim1, sizeof(T *));
    for(i = 0; i < dim1; i++)
	a[i] = m + i*dim2;
    for(i=0; i < dim1; i++)
	for(j=0; j < dim2; j++)
	    a[i][j] = 0;
}

template <typename T>
vector<vector<T> > RcppMatrix<T>::stlMatrix() {
    int i,j;
    vector<vector<T> > temp;
    for(i = 0; i < dim1; i++) {
	temp.push_back(vector<T>(dim2));
    }
    for(i = 0; i < dim1; i++)
	for(j = 0; j < dim2; j++)
	    temp[i][j] = a[i][j];
    return temp;
}

template <typename T>
T **RcppMatrix<T>::cMatrix() {
    int i,j;
    T *m = (T *)R_alloc(dim1*dim2, sizeof(T));
    T **tmp = (T **)R_alloc(dim1, sizeof(T *));
    for(i = 0; i < dim1; i++)
	tmp[i] = m + i*dim2;
    for(i=0; i < dim1; i++)
	for(j=0; j < dim2; j++)
	    tmp[i][j] = a[i][j];
    return tmp;
}

// Explicit instantiation (required for external linkage)
template class RcppVector<int>;
template class RcppVector<double>;
template class RcppMatrix<int>;
template class RcppMatrix<double>;

void RcppResultSet::add(string name, RcppDate& date) {
    SEXP value = PROTECT(allocVector(REALSXP, 1));
    numProtected++;
    REAL(value)[0] = date.getJDN() - RcppDate::Jan1970Offset;
    SEXP dateclass = PROTECT(allocVector(STRSXP,1));
    numProtected++;
    SET_STRING_ELT(dateclass, 0, mkChar("Date"));
    setAttrib(value, R_ClassSymbol, dateclass); 
    values.push_back(make_pair(name, value));
}

void RcppResultSet::add(string name, double x) {
    SEXP value = PROTECT(allocVector(REALSXP, 1));
    numProtected++;
    REAL(value)[0] = x;
    values.push_back(make_pair(name, value));
}

void RcppResultSet::add(string name, int i) {
    SEXP value = PROTECT(allocVector(INTSXP, 1));
    numProtected++;
    INTEGER(value)[0] = i;
    values.push_back(make_pair(name, value));
}

void RcppResultSet::add(string name, string strvalue) {
    SEXP value = PROTECT(allocVector(STRSXP, 1));
    numProtected++;
    SET_STRING_ELT(value, 0, mkChar(strvalue.c_str()));
    values.push_back(make_pair(name, value));
}

void RcppResultSet::add(string name, double *vec, int len) {
    if(vec == 0)
	throw std::range_error("RcppResultSet::add: NULL double vector");
    SEXP value = PROTECT(allocVector(REALSXP, len));
    numProtected++;
    for(int i = 0; i < len; i++)
	REAL(value)[i] = vec[i];
    values.push_back(make_pair(name, value));
}

void RcppResultSet::add(string name, RcppDateVector& datevec) {
    SEXP value = PROTECT(allocVector(REALSXP, datevec.size()));
    numProtected++;
    for(int i = 0; i < datevec.size(); i++) {
	REAL(value)[i] = datevec(i).getJDN() - RcppDate::Jan1970Offset;
    }
    SEXP dateclass = PROTECT(allocVector(STRSXP,1));
    numProtected++;
    SET_STRING_ELT(dateclass, 0, mkChar("Date"));
    setAttrib(value, R_ClassSymbol, dateclass); 
    values.push_back(make_pair(name, value));
}

void RcppResultSet::add(string name, RcppStringVector& stringvec) {
    int len = (int)stringvec.size();
    SEXP value = PROTECT(allocVector(STRSXP, len));
    numProtected++;
    for(int i = 0; i < len; i++)
        SET_STRING_ELT(value, i, mkChar(stringvec(i).c_str()));
    values.push_back(make_pair(name, value));
}

void RcppResultSet::add(string name, int *vec, int len) {
    if(vec == 0)
	throw std::range_error("RcppResultSet::add: NULL int vector");
    SEXP value = PROTECT(allocVector(INTSXP, len));
    numProtected++;
    for(int i = 0; i < len; i++)
	INTEGER(value)[i] = vec[i];
    values.push_back(make_pair(name, value));
}

void RcppResultSet::add(string name, double **mat, int nx, int ny) {
    if(mat == 0)
	throw std::range_error("RcppResultSet::add: NULL double matrix");
    SEXP value = PROTECT(allocMatrix(REALSXP, nx, ny));
    numProtected++;
    for(int i = 0; i < nx; i++)
	for(int j = 0; j < ny; j++)
	    REAL(value)[i + nx*j] = mat[i][j];
    values.push_back(make_pair(name, value));
}

void RcppResultSet::add(string name, int **mat, int nx, int ny) {
    if(mat == 0)
	throw std::range_error("RcppResultSet::add: NULL int matrix");
    SEXP value = PROTECT(allocMatrix(INTSXP, nx, ny));
    numProtected++;
    for(int i = 0; i < nx; i++)
	for(int j = 0; j < ny; j++)
	    INTEGER(value)[i + nx*j] = mat[i][j];
    values.push_back(make_pair(name, value));
}

void RcppResultSet::add(string name, vector<string>& vec) {
    if(vec.size() == 0)
	throw std::range_error("RcppResultSet::add; zero length vector<string>");
    int len = (int)vec.size();
    SEXP value = PROTECT(allocVector(STRSXP, len));
    numProtected++;
    for(int i = 0; i < len; i++)
        SET_STRING_ELT(value, i, mkChar(vec[i].c_str()));
    values.push_back(make_pair(name, value));
}

void RcppResultSet::add(string name, vector<int>& vec) {
    if(vec.size() == 0)
	throw std::range_error("RcppResultSet::add; zero length vector<int>");
    int len = (int)vec.size();
    SEXP value = PROTECT(allocVector(INTSXP, len));
    numProtected++;
    for(int i = 0; i < len; i++)
	INTEGER(value)[i] = vec[i];
    values.push_back(make_pair(name, value));
}

void RcppResultSet::add(string name, vector<double>& vec) {
    if(vec.size() == 0)
	throw std::range_error("RcppResultSet::add; zero length vector<double>");
    int len = (int)vec.size();
    SEXP value = PROTECT(allocVector(REALSXP, len));
    numProtected++;
    for(int i = 0; i < len; i++)
	REAL(value)[i] = vec[i];
    values.push_back(make_pair(name, value));
}

void RcppResultSet::add(string name, vector<vector<int> >& mat) {
    if(mat.size() == 0)
	throw std::range_error("RcppResultSet::add: zero length vector<vector<int> >");
    else if(mat[0].size() == 0)
	throw std::range_error("RcppResultSet::add: no columns in vector<vector<int> >");
    int nx = (int)mat.size();
    int ny = (int)mat[0].size();
    SEXP value = PROTECT(allocMatrix(INTSXP, nx, ny));
    numProtected++;
    for(int i = 0; i < nx; i++)
	for(int j = 0; j < ny; j++)
	    INTEGER(value)[i + nx*j] = mat[i][j];
    values.push_back(make_pair(name, value));
}

void RcppResultSet::add(string name, vector<vector<double> >& mat) {
    if(mat.size() == 0)
	throw std::range_error("RcppResultSet::add: zero length vector<vector<double> >");
    else if(mat[0].size() == 0)
	throw std::range_error("RcppResultSet::add: no columns in vector<vector<double> >");
    int nx = (int)mat.size();
    int ny = (int)mat[0].size();
    SEXP value = PROTECT(allocMatrix(REALSXP, nx, ny));
    numProtected++;
    for(int i = 0; i < nx; i++)
	for(int j = 0; j < ny; j++)
	    REAL(value)[i + nx*j] = mat[i][j];
    values.push_back(make_pair(name, value));
}

void RcppResultSet::add(string name, RcppVector<int>& vec) {
    int len = vec.size();
    int *a = vec.cVector();
    SEXP value = PROTECT(allocVector(INTSXP, len));
    numProtected++;
    for(int i = 0; i < len; i++)
	INTEGER(value)[i] = a[i];
    values.push_back(make_pair(name, value));
}

void RcppResultSet::add(string name, RcppVector<double>& vec) {
    int len = vec.size();
    double *a = vec.cVector();
    SEXP value = PROTECT(allocVector(REALSXP, len));
    numProtected++;
    for(int i = 0; i < len; i++)
	REAL(value)[i] = a[i];
    values.push_back(make_pair(name, value));
}

void RcppResultSet::add(string name, RcppMatrix<int>& mat) {
    int nx = mat.getDim1();
    int ny = mat.getDim2();
    int **a = mat.cMatrix();
    SEXP value = PROTECT(allocMatrix(INTSXP, nx, ny));
    numProtected++;
    for(int i = 0; i < nx; i++)
	for(int j = 0; j < ny; j++)
	    INTEGER(value)[i + nx*j] = a[i][j];
    values.push_back(make_pair(name, value));
}

void RcppResultSet::add(string name, RcppMatrix<double>& mat) {
    int nx = mat.getDim1();
    int ny = mat.getDim2();
    double **a = mat.cMatrix();
    SEXP value = PROTECT(allocMatrix(REALSXP, nx, ny));
    numProtected++;
    for(int i = 0; i < nx; i++)
	for(int j = 0; j < ny; j++)
	    REAL(value)[i + nx*j] = a[i][j];
    values.push_back(make_pair(name, value));
}

void RcppResultSet::add(string name, RcppFrame& frame) {
    vector<string> colNames = frame.getColNames();
    vector<vector<ColDatum> > table = frame.getTableData();
    int ncol = colNames.size();
    int nrow = table.size();
    SEXP rl = PROTECT(allocVector(VECSXP,ncol));
    SEXP nm = PROTECT(allocVector(STRSXP,ncol));
    numProtected += 2;
    for(int i=0; i < ncol; i++) {
	SEXP value, names;
	if(table[0][i].getType() == COLTYPE_DOUBLE) {
	    value = PROTECT(allocVector(REALSXP,nrow));
	    numProtected++;
	    for(int j=0; j < nrow; j++)
		REAL(value)[j] = table[j][i].getDoubleValue();
	}
	else if(table[0][i].getType() == COLTYPE_INT) {
	    value = PROTECT(allocVector(INTSXP,nrow));
	    numProtected++;
	    for(int j=0; j < nrow; j++)
		INTEGER(value)[j] = table[j][i].getIntValue();
	}
	else if(table[0][i].getType() == COLTYPE_FACTOR) {
	    value = PROTECT(allocVector(INTSXP,nrow));
	    numProtected++;
	    int levels = table[0][i].getFactorNumLevels();
	    names = PROTECT(allocVector(STRSXP,levels));
	    numProtected++;
	    string *levelNames = table[0][i].getFactorLevelNames();
	    for(int k=0; k < levels; k++)
		SET_STRING_ELT(names, k, mkChar(levelNames[k].c_str()));
	    for(int j=0; j < nrow; j++) {
		int level = table[j][i].getFactorLevel();
		INTEGER(value)[j] = level;
	    }
	    setAttrib(value, R_LevelsSymbol, names);
	    SEXP factorclass = PROTECT(allocVector(STRSXP,1));
	    numProtected++;
	    SET_STRING_ELT(factorclass, 0, mkChar("factor"));
	    setAttrib(value, R_ClassSymbol, factorclass); 
	}
	else if(table[0][i].getType() == COLTYPE_STRING) {
	    value = PROTECT(allocVector(STRSXP,nrow));
	    numProtected++;
	    for(int j=0; j < nrow; j++) {
		SET_STRING_ELT(value, j, mkChar(table[j][i].getStringValue().c_str()));
	    }
		
	}
	else if(table[0][i].getType() == COLTYPE_LOGICAL) {
	    value = PROTECT(allocVector(LGLSXP,nrow));
	    numProtected++;
	    for(int j=0; j < nrow; j++) {
		LOGICAL(value)[j] = table[j][i].getLogicalValue();
	    }
	}
	else if(table[0][i].getType() == COLTYPE_DATE) {
	    value = PROTECT(allocVector(REALSXP,nrow));
	    numProtected++;
	    for(int j=0; j < nrow; j++)
		REAL(value)[j] = table[j][i].getDateRCode();
	    SEXP dateclass = PROTECT(allocVector(STRSXP,1));
	    numProtected++;
	    SET_STRING_ELT(dateclass, 0, mkChar("Date"));
	    setAttrib(value, R_ClassSymbol, dateclass); 
	}
	else {
	    throw std::range_error("RcppResultSet::add invalid column type");
	}
	SET_VECTOR_ELT(rl, i, value);
	SET_STRING_ELT(nm, i, mkChar(colNames[i].c_str()));
    }
    setAttrib(rl, R_NamesSymbol, nm);
    values.push_back(make_pair(name, rl));
}

void RcppResultSet::add(string name, SEXP sexp, bool isProtected) {
    values.push_back(make_pair(name, sexp));
    if(isProtected)
	numProtected++;
}

SEXP RcppResultSet::getReturnList() {
    int nret = (int)values.size();
    SEXP rl = PROTECT(allocVector(VECSXP,nret));
    SEXP nm = PROTECT(allocVector(STRSXP,nret));
    list<pair<string,SEXP> >::iterator iter = values.begin();
    for(int i = 0; iter != values.end(); iter++, i++) {
	SET_VECTOR_ELT(rl, i, iter->second);
	SET_STRING_ELT(nm, i, mkChar(iter->first.c_str()));
    }
    setAttrib(rl, R_NamesSymbol, nm);
    UNPROTECT(numProtected+2);
    return rl;
}

#ifdef USING_QUANTLIB

// Conversion from QuantLib Date to RcppDate.
RcppDate::RcppDate(Date dateQL) {
    day = (int)dateQL.dayOfMonth();
    month = (int)dateQL.month();
    year  = (int)dateQL.year();
    mdy2jdn();
}

// Conversion from RcppDate to QuantLib Date.
RcppDate::operator Date() const {
    Date d(day, (Month)month, year);
    return d;
}

// Print a QuantLib Date.
ostringstream& operator<<(ostringstream& os, const Date& d) {
    os << d.month() << " " << d.weekday() << ", " << d.year();
    return os;
}

#endif

// Print an RcppDate.
ostream& operator<<(ostream& os, const RcppDate& date) {
    os << date.getYear() << "-" << date.getMonth() << "-" << date.getDay();
    return os;
}

#ifdef RCPP_DATE_OPS

// A few basic date operations.
RcppDate operator+(const RcppDate& date, int offset) {
    RcppDate temp(date.month, date.day, date.year);
    temp.jdn += offset;
    temp.jdn2mdy();
    return temp;
}

int operator-(const RcppDate& date2, const RcppDate& date1) {
    return date2.jdn - date1.jdn;
}

bool  operator<(const RcppDate &date1, const RcppDate& date2) {
    return date1.jdn < date2.jdn;
}

bool  operator>(const RcppDate &date1, const RcppDate& date2) {
    return date1.jdn > date2.jdn;
}

bool  operator>=(const RcppDate &date1, const RcppDate& date2) {
    return date1.jdn >= date2.jdn;
}

bool  operator<=(const RcppDate &date1, const RcppDate& date2) {
    return date1.jdn <= date2.jdn;
}

bool  operator==(const RcppDate &date1, const RcppDate& date2) {
    return date1.jdn == date2.jdn;
}

#endif

// Offset used to convert from R date representation to Julian day number.
const int RcppDate::Jan1970Offset = 2440588;

// The Julian day number (jdn) is the number of days since Monday,
// Jan 1, 4713BC (year = -4712). Here 1BC is year 0, 2BC is year -1, etc.
// On the other hand, R measures days since Jan 1, 1970, and these dates are
// converted to jdn's by adding Jan1970Offset.
//
// mdy2jdn and jdn2mdy are inverse functions for dates back to 
// year = -4799 (4800BC).
//
// See the Wikipedia entry on Julian day number for more information 
// on these algorithms.
//

// Transform month/day/year to Julian day number.
void RcppDate::mdy2jdn() {
    int m = month, d = day, y = year;
    int a = (14 - m)/12;
    y += 4800 - a;
    m += 12*a - 3;
    jdn = (d + (153*m + 2)/5 + 365*y
	   + y/4 - y/100 + y/400 - 32045);
}

// Transform from Julian day number to month/day/year.
void RcppDate::jdn2mdy() {
    int jul = jdn + 32044;
    int g = jul/146097;
    int dg = jul % 146097;
    int c = (dg/36524 + 1)*3/4;
    int dc = dg - c*36524;
    int b = dc/1461;
    int db = dc % 1461;
    int a = (db/365 + 1)*3/4;
    int da = db - a*365;
    int y = g*400 + c*100 + b*4 + a;
    int m = (da*5 + 308)/153 - 2;
    int d = da - (m + 4)*153 /5 + 122;
    y = y - 4800 + (m + 2)/12;
    m = (m + 2) % 12 + 1;
    d = d + 1;
    month = m;
    day   = d;
    year  = y;
}

SEXP RcppFunction::listCall() {
    if(names.size() != (unsigned)listSize)
	throw std::range_error("listCall: no. of names != no. of items");
    if(currListPosn != listSize)
	throw std::range_error("listCall: list has incorrect size");
    SEXP nm = PROTECT(allocVector(STRSXP,listSize));
    numProtected++;
    for(int i=0; i < listSize; i++)
	SET_STRING_ELT(nm, i, mkChar(names[i].c_str()));
    setAttrib(listArg, R_NamesSymbol, nm);
    SEXP R_fcall;
    PROTECT(R_fcall = lang2(fn, R_NilValue));
    numProtected++;
    SETCADR(R_fcall, listArg);
    SEXP result = eval(R_fcall, R_NilValue);
    names.clear();
    listSize = currListPosn = 0; // Ready for next call.
    return result;
}

SEXP RcppFunction::vectorCall() {
    if(vectorArg == R_NilValue)
	throw std::range_error("vectorCall: vector has not been set");
    SEXP R_fcall;
    PROTECT(R_fcall = lang2(fn, R_NilValue));
    numProtected++;
    SETCADR(R_fcall, vectorArg);
    SEXP result = eval(R_fcall, R_NilValue);
    vectorArg = R_NilValue; // Ready for next call.
    return result;
}

void RcppFunction::setRVector(vector<double>& v) {
    vectorArg = PROTECT(allocVector(REALSXP,v.size()));
    numProtected++;
    for(int i=0; i < (int)v.size(); i++)
	REAL(vectorArg)[i] = v[i];
}

void RcppFunction::setRListSize(int n) {
    listSize = n;
    listArg = PROTECT(allocVector(VECSXP, n));
    numProtected++;
}

void RcppFunction::appendToRList(string name, double value) {
    if(currListPosn < 0 || currListPosn >= listSize)
	throw std::range_error("appendToRList(double): list posn out of range");
    SEXP valsxp = PROTECT(allocVector(REALSXP,1));
    numProtected++;
    REAL(valsxp)[0] = value;
    SET_VECTOR_ELT(listArg, currListPosn++, valsxp);
    names.push_back(name);
}

void RcppFunction::appendToRList(string name, int value) {
    if(currListPosn < 0 || currListPosn >= listSize)
	throw std::range_error("appendToRlist(int): posn out of range");
    SEXP valsxp = PROTECT(allocVector(INTSXP,1));
    numProtected++;
    INTEGER(valsxp)[0] = value;
    SET_VECTOR_ELT(listArg, currListPosn++, valsxp);
    names.push_back(name);
}

void RcppFunction::appendToRList(string name, string value) {
    if(currListPosn < 0 || currListPosn >= listSize)
	throw std::range_error("appendToRlist(string): posn out of range");
    SEXP valsxp = PROTECT(allocVector(STRSXP,1));
    numProtected++;
    SET_STRING_ELT(valsxp, 0, mkChar(value.c_str()));
    SET_VECTOR_ELT(listArg, currListPosn++, valsxp);
    names.push_back(name);
}

void RcppFunction::appendToRList(string name, RcppDate& date) {
    if(currListPosn < 0 || currListPosn >= listSize)
	throw std::range_error("appendToRlist(RcppDate): list posn out of range");
    SEXP valsxp = PROTECT(allocVector(REALSXP,1));
    numProtected++;
    REAL(valsxp)[0] = date.getJDN() - RcppDate::Jan1970Offset;
    SEXP dateclass = PROTECT(allocVector(STRSXP, 1));
    numProtected++;
    SET_STRING_ELT(dateclass, 0, mkChar("Date"));
    setAttrib(valsxp, R_ClassSymbol, dateclass);
    SET_VECTOR_ELT(listArg, currListPosn++, valsxp);
    names.push_back(name);
}

#include <string.h>

// Paul Roebuck has observed that the memory used by an exception message
// is not reclaimed if error() is called inside of a catch block (due to
// a setjmp() call), and he suggested the following work-around.
char *copyMessageToR(const char* const mesg) {
    char* Rmesg;
    const char* prefix = "Exception: ";
    //void* Rheap = R_alloc(std::strlen(prefix)+std::strlen(mesg)+1,sizeof(char));
    //Rmesg = static_cast<char*>(Rheap);
    //std::strcpy(Rmesg, prefix);
    //std::strcat(Rmesg, mesg);

    void* Rheap = R_alloc(strlen(prefix)+strlen(mesg)+1,sizeof(char));
    Rmesg = static_cast<char*>(Rheap);
    strcpy(Rmesg, prefix);
    strcat(Rmesg, mesg);

    return Rmesg;
}

