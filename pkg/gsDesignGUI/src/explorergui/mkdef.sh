echo EXPORTS > gsdesigngui.def
nm -g --defined-only CMakeFiles/gsdesigngui.dir/*.obj > tmp
sed -n '/^........ [T|C|B] _/s/^........ [T|C|B] _/ /p' tmp >> gsdesigngui.def
rm tmp

