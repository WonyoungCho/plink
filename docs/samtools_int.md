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

# Required libraries
```
sudo yum install -y zlib-devel
sudo yum install -y ncurses-devel ncurses
sudo yum install -y bzip2-devel-1.0.6-13.el7.i686
sudo yum install -y xz-devel
sudo yum install -y bzip2-devel
```
