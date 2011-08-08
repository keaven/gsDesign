## Copyright (C) 2009 Merck Research Laboratories and REvolution Computing, Inc.
##
##	This file is part of gsDesignExplorer.
##
##  gsDesignExplorer is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.

##  gsDesignExplorer is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.

##  You should have received a copy of the GNU General Public License
##  along with gsDesignExplorer.  If not, see <http://www.gnu.org/licenses/>.

"gsDesignExplorer" <- function( exitOnClose = FALSE )
{
  if ( exitOnClose )
  {
    on.exit( quit( "no" ) )
  }
# initialize variables
	curdir <- getwd()
	unsupportedPlatformMessage <- "gsDesignExplorer is currently not supported on this platform"
# define shared object file name
	if ( !( ( .Platform$OS.type == "windows" ) || ( .Platform$OS.type == "unix" ) ) )
  {
    stop( unsupportedPlatformMessage )
	}
	setwd( curdir )
	retValue <- try( .Call( "LaunchGSDesignExplorer" ) )
}
