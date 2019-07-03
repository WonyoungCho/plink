# Introduction

<http://zzz.bwh.harvard.edu/plink/index.shtml>

# Installation

- plink 파일을 다운받아 원하는 폴더에 넣는다. : <a href="https://www.cog-genomics.org/plink2" target="_blank"> https://www.cog-genomics.org/plink2 </a>

- plink 파일을 실행 가능한 파일로 만들어준다.
```
$ sudo chmod u+x plink
```

- 만약 사용권한이 제한된어 실행되지 않을 경우, 소유자를 사용자로 바꾸어 준다 (change owner).
```
$ sudo chown user1:user1 plink
```

Another way of plink installation using conda : <a href="https://anaconda.org/search?q=plink" target="_blank"> https://anaconda.org/search?q=plink </a>
```
$ conda install -c bioconda plink
```

# Generate a SNP simulation file
- 어떤 dataset을 생성할 것인지 정해준다.
```
$ emacs wgas.sim
4 nullA 0 1 1 1
4 nullA 0 1 1 1
4 disea 0 1 2 mult
```
각 필드(행)의 값은 다음을 나타낸다.

1 Number of SNPs in this set
2 Label of this set of SNPs
3 Lower allele frequency range
4 Upper allele frequency range
5 Odds ratio for disease, heterozygote
6 Odds ratio for disease, homozyygote (or "mult")

```
$ plink --simulate wgas.sim --make-bed --out test
```

- 생성된 SNP simulation 파일.
```
$ cat test.bim
1       nullA_0 0       1       D       d
1       nullA_1 0       2       D       d
1       nullA_2 0       3       d       D
1       nullA_3 0       4       D       d
1       nullB_0 0       5       d       D
1       nullB_1 0       6       d       D
1       nullB_2 0       7       D       d
1       nullB_3 0       8       D       d
1       disea_0 0       9       D       d
1       disea_1 0       10      d       D
1       disea_2 0       11      D       d
1       disea_3 0       12      d       D
```

- 얼만큼의 빈도를 가지고 `nullA_#`가 나타나는지 확인.
```
$ cat test-temporary.simfreq
1 nullA_0       0.370886 0.370886       1       1
1 nullA_1       0.229202 0.229202       1       1
1 nullA_2       0.743708 0.743708       1       1
1 nullA_3       0.0544006 0.0544006     1       1
1 nullB_0       0.813045 0.813045       1       1
1 nullB_1       0.639096 0.639096       1       1
1 nullB_2       0.441359 0.441359       1       1
1 nullB_3       0.192305 0.192305       1       1
1 disea_0       0.266559 0.266559       2       4
1 disea_1       0.732512 0.732512       2       4
1 disea_2       0.344471 0.344471       2       4
1 disea_3       0.800109 0.800109       2       4
```

