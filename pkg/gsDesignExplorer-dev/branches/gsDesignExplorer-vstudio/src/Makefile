all:
	mkdir -p ../explorergui-build;
	cd ../explorergui-build; \
	  cmake ../src -DR_LIBRARIES="${LIBR}" -DR_INCLUDES=${R_INCLUDE_DIR} -DCMAKE_INSTALL_PREFIX=../inst/libs/; \
	  LD_LIBRARY_PATH=../inst/libs/; \
	  make install; \
	  cp -R ../src/images/ ../inst

clean:
	rm -rf ../explorergui-build; \
	rm -rf ../inst/libs; \
	rm -rf ../inst/images

