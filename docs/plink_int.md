# Introduction

<http://zzz.bwh.harvard.edu/plink/index.shtml>

# Installation

- plink 파일을 다운 : <a href="https://www.cog-genomics.org/plink2" target="_blank"> https://www.cog-genomics.org/plink2 </a>

- plink 파일을 실행 가능한 파일로 만들어준다.
```
$ sudo chmod u+x plink
```

- 만약 사용권한이 제한된어 실행되지 않을 경우, 소유자를 사용자로 바꾸어 준다 (change owner).
```
$ sudo chown user1:user1 plink
```

Conda를 이용한 다른 방법 : <a href="https://anaconda.org/search?q=plink" target="_blank"> https://anaconda.org/search?q=plink </a>
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
`wgas.sim` 파일의 각 필드(행) 값은 다음을 나타낸다.
```sh
1 Number of SNPs in this set
2 Label of this set of SNPs
3 Lower allele frequency range
4 Upper allele frequency range
5 Odds ratio for disease, heterozygote
6 Odds ratio for disease, homozyygote (or "mult")
```
- 데이터를 생성하는 명령어.
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

- 생성된 데이터에 대한 정보는 다음과 같다.
```
$ emacs info_DS.py
from pandas_plink import read_plink1_bin

f_nm="test"

DS = read_plink1_bin(f_nm+".bed", f_nm+".bim", f_nm+".fam", verbose=False)

print(DS)
print("")
print(DS.values)
print(DS.shape)
print(len(DS))
```
```
$ python info_DS.py
<xarray.DataArray 'genotype' (sample: 2000, variant: 12)>
dask.array<shape=(2000, 12), dtype=float64, chunksize=(1024, 12)>
Coordinates:
  * sample   (sample) object 'per0' 'per1' 'per2' ... 'per1998' 'per1999'
  * variant  (variant) object '1_nullA_0' '1_nullA_1' ... '1_disea_3'
    father   (sample) <U1 '0' '0' '0' '0' '0' '0' ... '0' '0' '0' '0' '0' '0'
    fid      (sample) <U7 'per0' 'per1' 'per2' ... 'per1997' 'per1998' 'per1999'
    gender   (sample) <U1 '2' '2' '2' '2' '2' '2' ... '2' '2' '2' '2' '2' '2'
    iid      (sample) <U7 'per0' 'per1' 'per2' ... 'per1997' 'per1998' 'per1999'
    mother   (sample) <U1 '0' '0' '0' '0' '0' '0' ... '0' '0' '0' '0' '0' '0'
    trait    (sample) float64 2.0 2.0 2.0 2.0 2.0 2.0 ... 1.0 1.0 1.0 1.0 1.0
    a0       (variant) <U1 'd' 'd' 'D' 'D' 'D' 'D' 'd' 'd' 'D' 'D' 'D' 'd'
    a1       (variant) <U1 'D' 'D' 'd' 'd' 'd' 'd' 'D' 'D' 'd' 'd' 'd' 'D'
    chrom    (variant) <U1 '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1'
    cm       (variant) float64 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
    pos      (variant) int64 1 2 3 4 5 6 7 8 9 10 11 12
    snp      (variant) <U7 'nullA_0' 'nullA_1' 'nullA_2' ... 'disea_2' 'disea_3'

[[1. 1. 2. ... 2. 2. 2.]
 [1. 2. 0. ... 2. 2. 2.]
 [1. 2. 1. ... 1. 2. 2.]
 ...
 [1. 2. 1. ... 1. 2. 2.]
 [2. 2. 1. ... 2. 2. 2.]
 [2. 1. 1. ... 2. 2. 2.]]
(2000, 12)
2000
```

- Default 로 1000명의 case와 1000명의 control 이 생겼다. 100명씩 생성해 보자.
```
$ plink --simulate wgas2.sim --make-bed -out test --simulate-ncases 100 --simulate-ncontrols 100 --simulate-prevalence 0.05
```

# File format reference

## .bim

## .fam
