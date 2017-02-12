# Installing GNU time

```bash
mkdir -p $HOME/packages

module load gcc/4.8.5

cd && wget http://ftp.gnu.org/gnu/time/time-1.7.tar.gz
tar xzf time-1.7.tar.gz && cd time-1.7
sed -i 's/fprintf (fp, "%lu", ptok ((UL) resp->ru.ru_maxrss));/fprintf (fp, "%lu", (UL) resp->ru.ru_maxrss);/' time.c
./configure --prefix=$HOME/packages
make && make install
cd ..
rm -r time-1.7 time-1.7.tar.gz
```


## References

* https://groups.google.com/forum/#!topic/gnu.utils.help/u1MOsHL4bhg
