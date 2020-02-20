# Remove missings
- **Remove missing genotype variants and samples from 0.90 to 0.95 frequencies.**
- Single process
```
$ genomind.sh
#!/bin/bash

path1='./test/'
path2='./inform/'
file1='project'
file2='.option1'
file3='.op1'

# Remove missing genotype variants and samples from 0.90 to 0.95 frequencies.
for i in {1..22} X Y;do plink --bfile ${file1}chr${i}${file2} --geno 0.1 --make-bed --out ${path1}${file1}chr${i}${file3}.snp90;done
for i in {1..22} X Y;do plink --bfile ${file1}chr${i}${file2} --mind 0.1 --make-bed --out ${path1}${file1}chr${i}${file3}.smp90;done

for j in {9..1}
do
    a=$(echo "scale = 2; $j / 100" | bc);b=$(echo "scale = 2; 99 - $j" | bc);c=$(echo "scale = 2; 100 - $j" | bc)
    for i in {1..22} X Y;do plink --bfile ${path1}${file1}chr${i}${file3}.smp$b --geno ${a} --make-bed --out ${path1}${file1}chr${i}${file3}.snp${c};done
    for i in {1..22} X Y;do plink --bfile ${path1}${file1}chr${i}${file3}.snp$b --mind ${a} --make-bed --out ${path1}${file1}chr${i}${file3}.smp${c};done
done

# Check number of variants and samples from 0.90 to 0.95 frequencies.
for j in {90..99}
do
    for i in {1..22} X Y;do wc -l ${path1}${file1}chr${i}${file3}.snp${j}.bim;done > ${path2}${file1}${file3}.snp${j}.inf0
    awk '{print $1}' ${path2}${file1}${file3}.snp${j}.inf0 > ${path2}${file1}${file3}.snp${j}.inf
    for i in {1..22} X Y;do wc -l ${path1}${file1}chr${i}${file3}.smp${j}.fam;done > ${path2}${file1}${file3}.smp${j}.inf0
    awk '{print $1}' ${path2}${file1}${file3}.smp${j}.inf0 > ${path2}${file1}${file3}.smp${j}.inf
done

for i in {1..22} X Y;do wc -l ${file1}chr${i}${file2}.bim;done > ${path2}${file1}${file3}.snp.inf0
awk '{print $1}' ${path2}${file1}${file3}.snp.inf0 > ${path2}${file1}${file3}.snp.inf
for i in {1..22} X Y;do wc -l ${file1}chr${i}${file2}.fam;done > ${path2}${file1}${file3}.smp.inf0
awk '{print $1}' ${path2}${file1}${file3}.smp.inf0 > ${path2}${file1}${file3}.smp.inf

rm ${path2}${file1}${file3}.*.inf0

# Generate chromosome numbers' index
for i in {1..22} X Y;do echo ${i};done > ${path2}${file1}${file3}.idx

a=$(for j in {90..99} X Y;do printf ${path2}${file1}${file3}.snp${j}.inf" ";done)
paste ${path2}${file1}${file3}.idx ${path2}${file1}${file3}.snp.inf $a > ${path2}${file1}${file3}.snp_90_99.inf
a=$(for j in {90..99} X Y;do printf ${path2}${file1}${file3}.smp${j}.inf" ";done)
paste ${path2}${file1}${file3}.idx ${path2}${file1}${file3}.smp.inf $a > ${path2}${file1}${file3}.smp_90_99.inf
```

- Multi-process
```
$ cmd.sh
#!/bin/bash

path1='./test/'
path2='./inform/'
file1='project'
file2='.option1'
file3='.op1'

# Remove missing variants and samples from 0.90 to 0.95 frequencies.
for i in {1..22} X Y;do echo "plink --bfile ${file1}chr${i}${file2} --geno 0.1 --make-bed --out ${path1}${file1}chr${i}${file3}.snp90";done
for i in {1..22} X Y;do echo "plink --bfile ${file1}chr${i}${file2} --mind 0.1 --make-bed --out ${path1}${file1}chr${i}${file3}.smp90";done

for j in {9..1}
do
    a=$(echo "scale = 2; $j / 100" | bc);b=$(echo "scale = 2; 99 - $j" | bc);c=$(echo "scale = 2; 100 - $j" | bc)
    for i in {1..22} X Y;do echo "plink --bfile ${path1}${file1}chr${i}${file3}.smp$b --geno ${a} --make-bed --out ${path1}${file1}chr${i}${file3}.snp${c}";done
    for i in {1..22} X Y;do echo "plink --bfile ${path1}${file1}chr${i}${file3}.snp$b --mind ${a} --make-bed --out ${path1}${file1}chr${i}${file3}.smp${c}";done
done
```
```
$ count.sh
#!/bin/bash

path1='./test/'
path2='./inform/'
file1='project'
file2='.option1'
file3='.op1'

./cmd.sh > cmd.lst

parallel {} < cmd.lst

# Check number of variants and samples from 0.90 to 0.95 frequencies.
for j in {90..99}
do
    for i in {1..22} X Y;do wc -l ${path1}${file1}chr${i}${file3}.snp${j}.bim;done > ${path2}${file1}${file3}.snp${j}.inf0
    awk '{print $1}' ${path2}${file1}${file3}.snp${j}.inf0 > ${path2}${file1}${file3}.snp${j}.inf
    for i in {1..22} X Y;do wc -l ${path1}${file1}chr${i}${file3}.smp${j}.fam;done > ${path2}${file1}${file3}.smp${j}.inf0
    awk '{print $1}' ${path2}${file1}${file3}.smp${j}.inf0 > ${path2}${file1}${file3}.smp${j}.inf
done

for i in {1..22} X Y;do wc -l ${file1}chr${i}${file2}.bim;done > ${path2}${file1}${file3}.snp.inf0
awk '{print $1}' ${path2}${file1}${file3}.snp.inf0 > ${path2}${file1}${file3}.snp.inf
for i in {1..22} X Y;do wc -l ${file1}chr${i}${file2}.fam;done > ${path2}${file1}${file3}.smp.inf0
awk '{print $1}' ${path2}${file1}${file3}.smp.inf0 > ${path2}${file1}${file3}.smp.inf

rm ${path2}${file1}${file3}.*.inf0

# Generate chromosome numbers' index
for i in {1..22} X Y;do echo ${i};done > ${path2}${file1}${file3}.idx

a=$(for j in {90..99} X Y;do printf ${path2}${file1}${file3}.snp${j}.inf" ";done)
paste ${path2}${file1}${file3}.idx ${path2}${file1}${file3}.snp.inf $a > ${path2}${file1}${file3}.snp_90_99.inf
a=$(for j in {90..99} X Y;do printf ${path2}${file1}${file3}.smp${j}.inf" ";done)
paste ${path2}${file1}${file3}.idx ${path2}${file1}${file3}.smp.inf $a > ${path2}${file1}${file3}.smp_90_99.inf
```
```
$ ./count.sh
```
