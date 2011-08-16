// Desc:   Generate DEF files from DLL
// Author: Ladislav Nevery             Article: http://www.codeproject.com/KB/tips/ImpDef.aspx       
//

#include <windows.h>
#include <stdio.h>

void main(int argc,char**argv) { 
    DWORD* dll = (DWORD*)LoadLibrary(argv[1]); 
    DWORD *nt = dll + dll[15] / 4 + 6;
	DWORD *dir = nt + 24;
	DWORD *exports = (DWORD*)(nt[7] + dir[0]);
	DWORD *name = (DWORD*)(nt[7] + exports[8]);
	DWORD *addr = (DWORD*)(nt[7] + exports[7]);

    printf("LIBRARY %s\nEXPORTS\n", argv[1]);
    for(DWORD i = 0; i<exports[6]; i++) {
        printf("  %s\n", nt[7] + name[i]);
    }
}
