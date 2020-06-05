# PLINK

[**PLINK**](http://zzz.bwh.harvard.edu/plink/tutorial.shtml) is a whole genome association analysis toolset.

This site introduces several ways to analyze genomic data and related things using `Plink` and `Python`.

- Developer Christopher Chang's interview : <http://gigasciencejournal.com/blog/gwas-reloaded-extended-qa-plink1-9-author-chris-chang/>

---
*What Feynman hated worse than anything else was intellectual pretense: phoniness, false sophistication, jargon.*

by Leonard Susskind, an old friend of Feynman.

---

**Wonyoung Cho**.

<bourbaki10@gmail.com>

---

# Installation
```
sudo apt install plink1.9
```
or

- Download page : <a href="https://www.cog-genomics.org/plink2" target="_blank"> https://www.cog-genomics.org/plink2 </a>
```
$ wget http://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20191028.zip
```
- if the **plink** is not a type of execute, then 
```
$ sudo chmod u+x plink
```

- If it has something about permission, then
```
$ sudo chown user:user plink
```

- Download plink using Conda : <a href="https://anaconda.org/search?q=plink" target="_blank"> https://anaconda.org/search?q=plink </a>
```
$ conda install -c bioconda plink
```

# Miniconda
```
$ wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
$ sh Miniconda3-latest-Linux-x86_64.sh
$ vi ~/.bashrc
export PATH="/home/username/miniconda3/bin:$PATH"
```
```
$ conda config --add channels defaults
$ conda config --add channels bioconda
$ conda config --add channels conda-forge
$ conda update conda
$ conda search --full-name python
$ conda create --name environment_name python=3.6.1
$ conda info --envs
$ source activate environment_name
```
```
$ source deactivate 
```
# Remove
```
$ conda remove --name environment_name --all
$ rm -rf ~/miniconda3
```

# Document
- plink 1.07 document <http://zzz.bwh.harvard.edu/plink/dist/plink-doc-1.07.pdf>
# Source code
- plink 1.9 <https://www.cog-genomics.org/static/bin/plink/plink_src.zip>
- plink 1.07 <http://s3.amazonaws.com/plink1-assets/1.07/plink1_src.zip>
- plink 2.0 <https://github.com/chrchang/plink-ng/tree/master/2.0>
