# Introduction

<http://zzz.bwh.harvard.edu/plink/index.shtml>

# Installation

- Download the plink program file : <a href="https://www.cog-genomics.org/plink2" target="_blank"> https://www.cog-genomics.org/plink2 </a>

- Copy the downloaded file to some directory.

- Make the file to be executable
```
$ sudo chmod u+x plink
```

Another way of plink installation using conda : <a href="https://anaconda.org/search?q=plink" target="_blank"> https://anaconda.org/search?q=plink </a>
```
$ conda install -c bioconda plink
```

# Generate a SNP simulation file
```
$ emacs wgas.sim

10 null 0 1 1 1
10 disease 0 1 2 mult
```
```
$ plink --simulate wgas.sim --make-bed --out test2
```
