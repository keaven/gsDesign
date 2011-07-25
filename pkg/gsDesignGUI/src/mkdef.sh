echo EXPORTS > gsDesignExplorer.def
nm -g --defined-only CMakeFiles/gsDesignExplorer.dir/*.obj > tmp
sed -n '/^........ [T|C|B] _/s/^........ [T|C|B] _/ /p' tmp >> gsDesignExplorer.def
rm tmp

