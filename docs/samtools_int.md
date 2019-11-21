[Samtools](http://www.htslib.org/) is a suite of programs for interacting with high-throughput sequencing data.

# Required library
```
sudo yum install -y zlib-devel ncurses-devel ncurses bzip2-devel-1.0.6-13.el7.i686 xz-devel bzip2-devel
```

# Installation

```
wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2
tar -xvf samtools-1.9.tar.bz2
cd samtools-1.9
./configure --prefix=/where/to/install
make
make install
```
<http://www.htslib.org/download/>

