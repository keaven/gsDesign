export RPATH=/dev/tools/R/R-2.13.1
export RTOOLS=/dev/tools/Rtools

export PATH=$RTOOLS/bin:$RPATH/bin:$PATH

alias install='cd ..; R CMD INSTALL --no-clean-on-error gsDesignExplorer'

