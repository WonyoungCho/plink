- Homepage : <https://odelaneau.github.io/shapeit4/>
- Source : <https://github.com/odelaneau/shapeit4>

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
$ export CPLUS_INCLUDE_PATH="$CPLUS_INCLUDE_PATH:/home/user/python3/"
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

# UKBioBank data
- <https://biobank.ctsu.ox.ac.uk/crystal/label.cgi?id=100319>

In order to download UKBioBank data, the program is needed.
<http://biobank.ctsu.ox.ac.uk/crystal/download.cgi?id=665&ty=ut>
```
$ wget -nd biobank.ctsu.ox.ac.uk/crystal/util/ukbgene
$ chmod 755 ukbgene

* A summary of the file types and groups is given in the table below:
Data type	Group	Filename(s)	How to obtain
Calls BED	Anon	ukb_cal_chrN_vZ.bed	EGA or ukbgene cal
Calls BIM	Anon	ukb_snp_chrN_vZ.bim	Resource 1963, ukb_snp_bim.tar
Calls FAM	Link	ukbA_cal_chrN_vZ_sP.fam	ukbgene cal -m
Marker-QC	Static	ukb_snp_qc.txt	Resource 1955, ukb_snp_qc.txt
Sample-QC	Anon	ukb_sqc_vZ.txt	EGA or standard fields in Category 100313
Relatedness	Link	ukbA_rel_sP.txt	ukbgene rel
Imputation BGEN	Anon	ukb_imp_chrN_vZ.bgen	EGA or ukbgene imp
Imputation BGI	Anon	ukb_bgi_chrN_vZ.bgi	Resource 1965, ukb_imp_bgi.tar
Imputation MAF+info	Anon	ukb_mfi_chrN_vZ.txt	Resource 1967, ukb_imp_mfi.tar
Imputation sample	Link	ukbA_imp_chrN_vZ_sP.sample	ukbgene imp -m
Haplotypes BGEN	Anon	ukb_hap_chrN_vZ.bgen	ukbgene hap
Haplotypes BGI	Anon	ukb_hbg_chrN_vZ.bgi	Resource 1671, ukb_hap_bgi.tar
HLA Imputation	Anon	ukb_hla_vZ.txt	EGA or Field 22182
Intensity	Anon	ukb_int_chrN_vZ.bin	EGA or ukbgene int
Confidences	Anon	ukb_con_chrN_vZ.txt	EGA or ukbgene con
CNV log2r	Anon	ukb_l2r_chrN_vZ.txt	EGA or ukbgene l2r
CNV baf	Anon	ukb_baf_chrN_vZ.txt	EGA or ukbgene baf
SNP-posterior	Static	ukb_snp_posterior_chrN.bin	Resource 1817, ukb_snp_posterior.tar
SNP-posterior X BIM	Static	ukb_snp_posterior_chrX_haploid.bim	Resource 1817, ukb_snp_posterior.tar
Batch	Static	ukb_snp_posterior.batch	Resource 1968, ukb_snp_posterior.batch

```
