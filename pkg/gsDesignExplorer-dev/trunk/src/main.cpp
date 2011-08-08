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
#include <QtGui/QApplication>
#include "gsdesign.h"
#include "gsDesignGUI.h"
#include <stdio.h>

// This class holds pointers to the objects we allocate and initialize,
// including the QApplication, and deletes them in the correct
// order.
class GsdState
{
public:
	QApplication	*m_pgsdApp;
	QSplashScreen	*m_pSplash;
	gsDesign		*m_gsdWindow;

public:
	GsdState() :
		m_pgsdApp( NULL ),
		m_pSplash( NULL ),
		m_gsdWindow( NULL )
	{
	  printf( "GsdState constructor called!\n" );
	}

	void Init(int argc, char *argv[])
	{
		printf( "Init called\n" );

		if (m_pgsdApp == NULL)
		{
			printf("In Init() function\n");
			printf("Next line is call to new QApplication()...\n");
			m_pgsdApp = new QApplication(argc, argv);
			printf("Done with call to new QApplication()...\n");
			QSplashScreen *m_pSplash = new QSplashScreen;
			m_pSplash->setPixmap(QPixmap(":/images/splash/gsDesignSplash.png"));
			m_pSplash->show();

			Qt::Alignment topRight = Qt::AlignRight | Qt::AlignTop;
			m_pSplash->showMessage(QObject::tr("Loading graphical user interface ... "),
								   topRight, Qt::white);

			int delay = 3500;
			QTimer::singleShot(delay, m_pSplash, SLOT(close()));

			m_pgsdApp->processEvents();

			printf("About to call the gsDesign constructor\n");
			m_gsdWindow = new gsDesign();
			printf("Done with callign the gsDesign constructor\n");

			QTimer::singleShot(delay, m_gsdWindow, SLOT(show()));
		}
	}

	int Exec()
	{
		printf( "Exec called\n" );

		return m_pgsdApp->exec();
	}

	void Destroy()
	{
		printf( "Destroy called\n" );

		if (m_pSplash != NULL)
		{
			delete m_pSplash;
			m_pSplash = NULL;
		}

		if (m_gsdWindow != NULL)
		{
			delete m_gsdWindow;
			m_gsdWindow = NULL;
		}

		if (m_pgsdApp != NULL)
		{
			delete m_pgsdApp;
			m_pgsdApp = NULL;
		}

	}

	~GsdState()
	{
		printf( "Destructor called\n" );
		Destroy();
	}	

	QApplication *GetQApp()
	{
		return m_pgsdApp;
	}

};

// global state
GsdState g_gsdState;


int	GsdMain(int argc, char *argv[])
{
	printf( "In GsdMain\n" );

	int iRet=0;
	try
	{
		printf( "In GsdMain\n" );
		g_gsdState.Init(argc, argv);

		iRet = g_gsdState.Exec();

	}
	catch(...)
	{
		printf("Caught exception in GsdMain");
	}

	g_gsdState.Destroy();

	return iRet;
}


int GsdStartup()
{
	printf( "In GsdStartup\n" );
	int ret = 0;
	ret = GsdMain(0/*argc*/, 0/*argv*/);
	return ret;
}

// TODO -- set this up correctly for dll's or exe's on all OS's
#if defined( __MINGW32__ )

Gsd_Export_C BOOL APIENTRY DllMain( HINSTANCE hModule,
									DWORD ul_reason_for_call,
									LPVOID lpReserved )
{
		printf( "In DllMain, ul_reason_for_call = %d\n" , (int)ul_reason_for_call );
		switch (ul_reason_for_call)
		{
		case DLL_PROCESS_ATTACH:
			printf(">> In DLL_PROCESS_ATTACH\n");
			break;
		case DLL_THREAD_ATTACH:
			printf("In DLL_THREAD_ATTACH\n");
			break;
		case DLL_THREAD_DETACH:
			printf("In DLL_THREAD_DETACH\n");
			break;
		case DLL_PROCESS_DETACH:
			printf(">> In DLL_PROCESS_DETACH (%s)\n", lpReserved == null ? "DLL failed to load" : "DLL is terminating normally");
			break;
		default:
		    printf("Default!\n");
		}
        return true;
}

#elif defined( _MSC_VER )

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
					 )
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
	case DLL_PROCESS_DETACH:
		break;
	}
	return TRUE;
}

#else // defined( __MINGW32__ )

int main(int argc, char *argv[])
{
	return GsdMain(argc, argv);
}

#endif // defined( __MINGW32__ )
