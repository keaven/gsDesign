all:
	mkdir -p ../explorergui-build;
	cd ../explorergui-build; \
	cmake ../src/explorergui -DR_LIBRARIES="${LIBR}" \
	      -DR_INCLUDES=${R_INCLUDE_DIR} -DCMAKE_INSTALL_PREFIX=../inst/libs/; \
	LD_LIBRARY_PATH=../inst/libs/; make install
	mkdir -p ../src-build;
	cd ../src-build; \
	cmake ../src \
	      -DR_LIBRARIES="${LIBR}" \
	      -DR_INCLUDES=${R_INCLUDE_DIR} \
	      -DCMAKE_INSTALL_PREFIX=../src \
	      -DLD_LIBRARY_PATH=../inst/libs/; \
	make install

clean:
	rm -rf ../explorergui-build
	rm -rf ../src-build
	rm -rf ../inst/local
