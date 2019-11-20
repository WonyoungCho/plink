# Installation
```
$ sudo yum install libstdc++-static
$ sudo yum install glibc-static
$ sudo yum install git
$ git clone https://github.com/bedops/bedops.git
$ cd bedops
$ make
$ make install
$ sudo cp bin/* /usr/local/bin # optional
```
<https://bedops.readthedocs.io/>

# Check repeated region
```
$ wget -qO- http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/rmsk.txt.gz | gunzip -c -|awk -v OFS="\t" '{ print $6, $7, $8, $12, $11, $10 }' -|sort-bed - > rmsk.bed
$ sort-bed Exome-Agilent_V6_UTR_Padded.duplicate.merge.bed > Exome_regions.bed
$ bedmap --echo --echo-map-id-uniq Exome_regions.bed rmsk.bed > Exome_rm_regions.bed
```
![Repeat regions](./image/repeat_region.png)

<http://www.incodom.kr/RepeatMasker>

```
$ less Exome_rm_regions.bed
    822 chr1    6412706 6413462 HES2^M|DNA;LINE;LTR;SINE
    823 chr1    6415086 6415834 HES2^M|DNA;SINE
    824 chr1    6415947 6417694 HES2^M|LINE;SINE;Simple_repeat
    825 chr1    6417803 6420050 HES2^M|Low_complexity;SINE;Simple_repeat
    826 chr1    6424402 6425490 ESPN^M|Low_complexity;Simple_repeat
    827 chr1    6428122 6428558 ESPN^M|
    828 chr1    6429715 6430117 ESPN^M|
    829 chr1    6440166 6441150 ESPN^M|Low_complexity;SINE;Simple_repeat
    830 chr1    6444328 6444916 ESPN^M|SINE
    831 chr1    6445504 6446048 ESPN^M|
    832 chr1    6447883 6448252 ESPN^M|
    833 chr1    6448447 6449096 ESPN^M|Simple_repeat
    834 chr1    6451416 6452190 ESPN^M|Simple_repeat
    835 chr1    6457141 6457462 ESPN^M|LINE;Simple_repeat
    836 chr1    6459872 6462266 ESPN^M|Unknown
    837 chr1    6462309 6463190 TNFRSF25^M|Simple_repeat
    838 chr1    6464072 6465671 TNFRSF25^M|Simple_repeat
    839 chr1    6465820 6466589 PLEKHG5^M|SINE;Simple_repeat
    840 chr1    6466679 6468740 PLEKHG5^M|DNA;SINE
    841 chr1    6468887 6469758 PLEKHG5^M|DNA;Simple_repeat
    842 chr1    6470130 6471962 PLEKHG5^M|SINE;Simple_repeat
```
