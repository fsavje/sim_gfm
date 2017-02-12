# Installing R 3.3.2


### Preliminaries

```bash
mkdir -p $HOME/R-3.3.2 $HOME/packages $HOME/tmp_src

module load gcc/4.8.5
module load java

export PATH=$HOME/packages/bin:$PATH
export LD_LIBRARY_PATH=$HOME/packages/lib:$LD_LIBRARY_PATH
export CFLAGS="-I$HOME/packages/include"
export LDFLAGS="-L$HOME/packages/lib"
```


### Download sources

```bash
cd $HOME/tmp_src && wget http://zlib.net/zlib-1.2.11.tar.gz http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz http://tukaani.org/xz/xz-5.2.3.tar.gz ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.40.tar.gz https://curl.haxx.se/download/curl-7.52.1.tar.gz https://cran.r-project.org/src/base/R-3/R-3.3.2.tar.gz
```


### Install R dependencies

```bash
tar xzf zlib-1.2.11.tar.gz && cd zlib-1.2.11
./configure --prefix=$HOME/packages
make && make install
cd ..

tar xzf bzip2-1.0.6.tar.gz && cd bzip2-1.0.6
sed -i 's/CFLAGS=-Wall/CFLAGS=-Wall -fPIC/' Makefile
make && make install PREFIX=$HOME/packages
cd ..

tar xzf xz-5.2.3.tar.gz && cd xz-5.2.3
./configure --prefix=$HOME/packages
make && make install
cd ..

tar xzf pcre-8.40.tar.gz && cd pcre-8.40
./configure --enable-utf8 --prefix=$HOME/packages
make && make install
cd ..

tar xzf curl-7.52.1.tar.gz && cd curl-7.52.1
./configure --prefix=$HOME/packages
make && make install
cd ..
```


### Install R

```bash
tar xzf R-3.3.2.tar.gz && cd R-3.3.2
sed -i 's/exit(strncmp(ZLIB_VERSION, "1.2.5", 5) < 0);/exit(ZLIB_VERNUM < 0x1250);/' configure
./configure --prefix=$HOME/R-3.3.2
make && make install
```


### Install R packages

```bash
$HOME/R-3.3.2/bin/R -e 'install.packages(c("devtools"), repos = "http://cloud.r-project.org")'
```


### Clean up

```bash
cd
rm -r tmp_src
```


## References

* http://stackoverflow.com/a/41362423
* http://pj.freefaculty.org/blog/?p=315
