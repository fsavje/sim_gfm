# Installing modules

## Preliminaries

The following instructions assume that the shell variable `MODENV_PATH` points to the local module environment and that it's been populated with the folders `modfiles` and `packages`. I.e., it presumes you've ran:
```bash
MODENV_PATH=/global/home/groups/co_praxis/modules
mkdir -p ${MODENV_PATH}/modfiles ${MODENV_PATH}/packages
```

It also requires access to a compiler such as GCC. If not loaded by default, run:
```bash
module load gcc
```


## R module

To install R you might need more recent versions of some dependencies. Common cases are: bzip2, curl, PCRE, XZ Utils and zlib. See below for instructions on these.

```bash
# Set version
RVER=3.3.2

# Make folders
mkdir -p ${MODENV_PATH}/packages/r ${MODENV_PATH}/modfiles/r
mkdir ${MODENV_PATH}/packages/r/${RVER}

# Set compilation flags for updated libraries (change as necessary)
BZIP2_DIR=${MODENV_PATH}/packages/bzip2/1.0.6
CURL_DIR=${MODENV_PATH}/packages/curl/7.52.1
PCRE_DIR=${MODENV_PATH}/packages/pcre/8.40
XZ_DIR=${MODENV_PATH}/packages/xz/5.2.3
ZLIB_DIR=${MODENV_PATH}/packages/zlib/1.2.11

export PATH="$BZIP2_DIR/bin:$CURL_DIR/bin:$PCRE_DIR/bin:$XZ_DIR/bin:$PATH"
export LD_LIBRARY_PATH="$BZIP2_DIR/lib:$CURL_DIR/lib:$PCRE_DIR/lib:$XZ_DIR/lib:$ZLIB_DIR/lib:$LD_LIBRARY_PATH"
export CFLAGS="-I$BZIP2_DIR/include -I$CURL_DIR/include -I$PCRE_DIR/include -I$XZ_DIR/include -I$ZLIB_DIR/include"
export LDFLAGS="-L$BZIP2_DIR/lib -L$CURL_DIR/lib -L$PCRE_DIR/lib -L$XZ_DIR/lib -L$ZLIB_DIR/lib"

# Download, compile and install
wget https://cran.r-project.org/src/base/R-3/R-${RVER}.tar.gz
tar xzf R-${RVER}.tar.gz && cd R-${RVER}
# Patch bug in configure script
sed -i 's/exit(strncmp(ZLIB_VERSION, "1.2.5", 5) < 0);/exit(ZLIB_VERNUM < 0x1250);/' configure
./configure --disable-java --prefix=${MODENV_PATH}/packages/r/${RVER}
make && make install
cd .. && rm -r R-${RVER}.tar.gz R-${RVER}

# Make module file
cat << EOF > ${MODENV_PATH}/modfiles/r/${RVER}
#%Module1.0
proc ModulesHelp { } {
  puts stderr "This module sets up R ${RVER} in your environment."
}

module-whatis "This module sets up R ${RVER} in your environment."

set R_DIR ${MODENV_PATH}/packages/r/${RVER}

setenv       R_DIR              \$R_DIR
prepend-path PATH               \$R_DIR/bin
prepend-path CPATH              \$R_DIR/lib64/R/include
prepend-path FPATH              \$R_DIR/lib64/R/include
prepend-path INCLUDE            \$R_DIR/lib64/R/include
prepend-path LIBRARY_PATH       \$R_DIR/lib64/R/lib
prepend-path LD_LIBRARY_PATH    \$R_DIR/lib64/R/lib
prepend-path MANPATH            \$R_DIR/share/man
EOF

# Set permissions
chmod -R -w ${MODENV_PATH}/packages/r/${RVER}
chmod 444 ${MODENV_PATH}/modfiles/r/${RVER}
```

### References

* http://stackoverflow.com/a/41362423
* http://pj.freefaculty.org/blog/?p=315


## GNU time module

```bash
# Set version
TIMEV=1.7

# Make folders
mkdir -p ${MODENV_PATH}/packages/time ${MODENV_PATH}/modfiles/time
mkdir ${MODENV_PATH}/packages/time/${TIMEV}

# Download, compile and install
wget http://ftp.gnu.org/gnu/time/time-${TIMEV}.tar.gz
tar xzf time-${TIMEV}.tar.gz && cd time-${TIMEV}
# Patch bug, see reference below
sed -i 's/fprintf (fp, "%lu", ptok ((UL) resp->ru.ru_maxrss));/fprintf (fp, "%lu", (UL) resp->ru.ru_maxrss);/' time.c
./configure --prefix=${MODENV_PATH}/packages/time/${TIMEV}
make && make install
cd .. && rm -r time-${TIMEV}.tar.gz time-${TIMEV}

# Make module file
cat << EOF > ${MODENV_PATH}/modfiles/time/${TIMEV}
#%Module1.0
proc ModulesHelp { } {
  puts stderr "This module sets up GNU time ${TIMEV} in your environment."
}

module-whatis "This module sets up GNU time ${TIMEV} in your environment."

set TIME_DIR ${MODENV_PATH}/packages/time/${TIMEV}

setenv       TIME_DIR           \$TIME_DIR
prepend-path PATH               \$TIME_DIR/bin
prepend-path INFOPATH           \$TIME_DIR/info
EOF

# Set permissions
chmod -R -w ${MODENV_PATH}/packages/time/${TIMEV}
chmod 444 ${MODENV_PATH}/modfiles/time/${TIMEV}
```

### References

* https://groups.google.com/forum/#!topic/gnu.utils.help/u1MOsHL4bhg


## bzip2 library

```bash
# Set version
BZIP2V=1.0.6

# Make folders
mkdir -p ${MODENV_PATH}/packages/bzip2
mkdir ${MODENV_PATH}/packages/bzip2/${BZIP2V}

# Download, compile and install
wget http://www.bzip.org/${BZIP2V}/bzip2-${BZIP2V}.tar.gz
tar xzf bzip2-${BZIP2V}.tar.gz && cd bzip2-${BZIP2V}
# Compile with "PIC" flag
sed -i 's/CFLAGS=-Wall/CFLAGS=-Wall -fPIC/' Makefile
make && make install PREFIX=${MODENV_PATH}/packages/bzip2/${BZIP2V}
cd .. && rm -r bzip2-${BZIP2V}.tar.gz bzip2-${BZIP2V}

# Set permissions
chmod -R -w ${MODENV_PATH}/packages/bzip2/${BZIP2V}
```


## curl library

```bash
# Set version
CURLV=7.52.1

# Make folders
mkdir -p ${MODENV_PATH}/packages/curl
mkdir ${MODENV_PATH}/packages/curl/${CURLV}

# Download, compile and install
wget https://curl.haxx.se/download/curl-${CURLV}.tar.gz
tar xzf curl-${CURLV}.tar.gz && cd curl-${CURLV}
./configure --prefix=${MODENV_PATH}/packages/curl/${CURLV}
make && make install
cd .. && rm -r curl-${CURLV}.tar.gz curl-${CURLV}

# Set permissions
chmod -R -w ${MODENV_PATH}/packages/curl/${CURLV}
```


## PCRE library

```bash
# Set version
PCREV=8.40

# Make folders
mkdir -p ${MODENV_PATH}/packages/pcre
mkdir ${MODENV_PATH}/packages/pcre/${PCREV}

# Download, compile and install
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${PCREV}.tar.gz
tar xzf pcre-${PCREV}.tar.gz && cd pcre-${PCREV}
./configure --enable-utf8 --prefix=${MODENV_PATH}/packages/pcre/${PCREV}
make && make install
cd .. && rm -r pcre-${PCREV}.tar.gz pcre-${PCREV}

# Set permissions
chmod -R -w ${MODENV_PATH}/packages/pcre/${PCREV}
```


## XZ Utils

```bash
# Set version
XZV=5.2.3

# Make folders
mkdir -p ${MODENV_PATH}/packages/xz
mkdir ${MODENV_PATH}/packages/xz/${XZV}

# Download, compile and install
wget http://tukaani.org/xz/xz-${XZV}.tar.gz
tar xzf xz-${XZV}.tar.gz && cd xz-${XZV}
./configure --prefix=${MODENV_PATH}/packages/xz/${XZV}
make && make install
cd .. && rm -r xz-${XZV}.tar.gz xz-${XZV}

# Set permissions
chmod -R -w ${MODENV_PATH}/packages/xz/${XZV}
```


## zlib library

```bash
# Set version
ZLIBV=1.2.11

# Make folders
mkdir -p ${MODENV_PATH}/packages/zlib
mkdir ${MODENV_PATH}/packages/zlib/${ZLIBV}

# Download, compile and install
wget http://zlib.net/zlib-${ZLIBV}.tar.gz
tar xzf zlib-${ZLIBV}.tar.gz && cd zlib-${ZLIBV}
./configure --prefix=${MODENV_PATH}/packages/zlib/${ZLIBV}
make && make install
cd .. && rm -r zlib-${ZLIBV}.tar.gz zlib-${ZLIBV}

# Set permissions
chmod -R -w ${MODENV_PATH}/packages/zlib/${ZLIBV}
```
