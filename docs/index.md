# PLINK

[**PLINK**](http://zzz.bwh.harvard.edu/plink/tutorial.shtml) is a whole genome association analysis toolset.

This site contains the way to analyze genomic data and related things.



---

**Wonyoung Cho**.

<bourbaki10@gmail.com>

---

# Installation
```
sudo apt install plink1.9
```
or

- plink 파일을 다운 : <a href="https://www.cog-genomics.org/plink2" target="_blank"> https://www.cog-genomics.org/plink2 </a>
```
$ wget http://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20190617.zip
```
- 만약 파일이 실행되지 않으면, plink 파일을 실행 가능한 파일로 만들어준다.
```
$ sudo chmod u+x plink
```

- 만약 사용권한이 제한된어 실행되지 않을 경우, 소유자를 사용자로 바꾸어 준다 (change owner).
```
$ sudo chown user:user plink
```

- Conda를 이용한 다른 방법 : <a href="https://anaconda.org/search?q=plink" target="_blank"> https://anaconda.org/search?q=plink </a>
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
