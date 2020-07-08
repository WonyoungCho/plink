# Prerequisite

- [**HTSlib**](http://www.htslib.org/download/): A great C library for reading/writing high-throughput sequencing data.
- [**BOOST**](https://www.boost.org/users/download/): A free peer-reviewed portable C++ source libraries. SHAPEIT4 uses two specific BOOST libraries: iostreams and program_options.

```
# git 2.x
$ sudo rpm -Uvh http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm
$ sudo yum install git

# gcc 7.x
$ sudo yum install centos-release-scl
$ sudo yum install devtoolset-7
$ scl enable devtoolset-7 bash

# zstd
$ git clone https://github.com/Microsoft/vcpkg.git
$ cd vcpkg
$ ./bootstrap-vcpkg.sh
$ ./vcpkg integrate install
$ ./vcpkg install zstd

# HTSlib
$ wget https://github.com/samtools/htslib/releases/download/1.10.2/htslib-1.10.2.tar.bz2
$ tar -xvf htslib-1.10.2.tar.bz2
$ cd htslib-1.10.2
$ make && sudo make install

# BOOST
$ wget https://dl.bintray.com/boostorg/release/1.73.0/source/boost_1_73_0.tar.bz2
$ tar -xvf boost_1_73_0.tar.bz2
$ cd boost_1_73_0
$ ./bootstrap.sh
$ ./b2 install

# export path of 'pyconfig.h'
$ export CPLUS_INCLUDE_PATH="$CPLUS_INCLUDE_PATH:/home/user1/miniconda3/pkgs/python-3.6.9-h265db76_0/include/python3.6m/"
```


# Installation
<https://odelaneau.github.io/shapeit4/#installation>
```
$ git clone https://github.com/odelaneau/shapeit4.git
$ cd git
$ locate libboost_program_options.a libboost_iostreams.a libhts.a
$ emacs makefile
HTSLIB_INC (line 5): path to the HTSlib header files
HTSLIB_LIB (line 6): path to the static HTSlib library (file libhts.a)
BOOST_INC (line 9): path to the BOOST header files (often /usr/include)
BOOST_LIB_IO (line 10): path to the static BOOST iostreams library (file libboost_iostreams.a)
BOOST_LIB_PO (line 11): path to the static BOOST program_options library (file libboost_iostreams.a)

Add libraries (line 32): DYN_LIBS=-lz -lbz2 -lm -lpthread -llzma -lcurl -lssl -lcrypto 

$ make
```


