# Parameters
```
path0='./'
path1=${path0}'op1_range/'
path2=${path0}'inform/'
path3=${path0}'cmd_list/'
path4=${path0}'temp/'

file1='GROUP'
file2='.option1'
file3='.op1'
file4='.cmd'
gene_list=${file1}'_sel_gene.list'

file0='.gene.snp0.99.maf0.05'
file00='.gene.snp.maf'
```

# Preparation
```
mkdir ${path4}

while IFS='' read -r line
do
    echo "cat ${path0}Exome.bed |grep -w ${line} > ${path4}Exome_gene_${line}"
    echo "cat ${path0}${file1}.ann |grep -w ${line} > ${path4}${file1}_gene_${line}"
done < ${path0}${gene_list} > ${path0}'cmd_sel_gene'

parallel {} < ${path0}'cmd_sel_gene'

rm ${path0}'cmd_sel_gene'


cat ${path4}Exome_gene_* > ${path4}Exome_sel_gene.bed
cat ${path4}${file1}_gene_* > ${path4}${file1}_sel_gene.ann

sort -V -k 1 ${path4}Exome_sel_gene.bed > ${path4}Exome_sel_gene.tmp
awk -F"chr" '{print $2}' ${path4}Exome_sel_gene.tmp > ${path0}Exome_sel_genes.bed
sort -V -k 1 ${path4}${file1}_sel_gene.ann > ${path0}${file1}_sel_genes.ann

rm -r ${path4}

awk -F"chr" '{print $2" "$3}' ${path0}${file1}_sel_genes.ann|awk '{print $3"_"$5"\t"$2}' > ${path0}${file1}_sel_genes_short.ann
```


# Replace variant name
```
for i in {1..22} X Y;do echo "mv ${path0}${file1}_chr${i}${file2}.bim ${path0}${file1}_chr${i}${file2}.bim.bak && awk '{print \$1\"\t\"\$1\"_\"\$2\"\t\"\$3\"\t\"\$4\"\t\"\$5\"\t\"\$6}' ${path0}${file1}_chr${i}${file2}.bim.bak > ${path0}${file1}_chr${i}${file2}.bim";done > ${path0}replace.tmp

parallel {} < ${path0}replace.tmp

rm ${path0}replace.tmp
```

# Extract some ranges
```
for i in {1..22} X Y;do echo "plink --bfile ${path0}${file1}_chr${i}${file2} --extract /maha3/WYC/ADNI/Exome_sel_genes.bed --range --make-bed --out ${path1}${file1}_chr${i}${file3}.gene";done > ${path3}${file1}${file3}.gene.cmd

parallel {} < ${path3}${file1}${file3}.gene.cmd

for i in {1..22} X Y;do wc -l ${path1}${file1}_chr${i}${file3}.gene.bim ;done > ${path2}${file1}${file3}.gene.inf0
awk -F"[chr .]" '{print $7"\t"$1}' ${path2}${file1}${file3}.gene.inf0 > ${path2}${file1}${file3}.genes.inf

rm ${path2}${file1}${file3}.*.inf0
```

# Remove missings
```
# Remove variants and samples which have missing genotypes with 0.10 to 0.01 frequencies.
for i in {1..22} X Y;do echo "plink --bfile ${path1}${file1}_chr${i}${file3}.gene --geno 0.99 --make-bed --out ${path1}${file1}_chr${i}${file3}.gene.snp0.99";done > ${path3}${file1}${file3}.gene.snp.cmd

parallel {} < ${path3}${file1}${file3}.gene.snp.cmd


for i in {1..22} X Y;do wc -l ${path1}${file1}_chr${i}${file3}.gene.snp0.99.bim ;done > ${path2}${file1}${file3}.gene.snp.inf0
awk -F"[chr .]" '{print $7"\t"$1}' ${path2}${file1}${file3}.gene.snp.inf0 > ${path2}${file1}${file3}.genes.snp.inf

rm ${path2}${file1}${file3}.*.inf0
```

# Filter by maf
```
for i in {1..22} X Y;do echo "plink --bfile ${path1}${file1}_chr${i}${file3}.gene.snp0.99 --maf 0.05 --make-bed --out ${path1}${file1}_chr${i}${file3}.gene.snp0.99.maf0.05";done > ${path3}${file1}${file3}.gene.snp.maf.cmd

parallel {} < ${path3}${file1}${file3}.gene.snp.maf.cmd


for i in {1..22} X Y;do wc -l ${path1}${file1}_chr${i}${file3}.gene.snp0.99.maf0.05.bim ;done > ${path2}${file1}${file3}.gene.snp.maf.inf0
awk -F"[chr .]" '{print $7"\t"$1}' ${path2}${file1}${file3}.gene.snp.maf.inf0 > ${path2}${file1}${file3}.genes.snp.maf.inf

rm ${path2}${file1}${file3}.*.inf0
```

# Merge files
```
for i in {1..22};do echo "${path1}${file1}_chr${i}${file3}${file0}.bed ${path1}${file1}_chr${i}${file3}${file0}.bim ${path1}${file1}_chr${i}${file3}${file0}.fam";done > ${path3}${file1}${file3}${file0}.merge.lst

plink --bfile ${path1}${file1}_chr1${file3}${file0} --merge-list ${path3}${file1}${file3}${file0}.merge.lst --make-bed --out ${path1}${file1}${file3}${file0}.merged

for i in {1..22} X Y;do wc -l ${path1}${file1}_chr${i}${file3}.gene.snp95.maf0.05.bim ;done > ${path2}${file1}${file3}.gene.snp.maf.inf0
awk -F"[chr .]" '{print $7"\t"$1}' ${path2}${file1}${file3}.gene.snp.maf.inf0 > ${path2}${file1}${file3}.genes.snp.maf.inf

rm ${path2}${file1}${file3}.*.inf0
```



# Remove missings2
- **Remove variants and samples which have missing genotypes with 0.10 to 0.01 frequencies.**

> - Single processing
```
# Remove variants and samples which have missing genotypes with 0.10 to 0.01 frequencies.
for i in {1..22} X Y;do plink --bfile ${path0}${file1}chr${i}${file2} --geno 0.1 --make-bed --out ${path1}${file1}chr${i}${file3}.snp90;done
for i in {1..22} X Y;do plink --bfile ${path1}${file1}chr${i}${file3}.snp90 --mind 0.1 --make-bed --out ${path1}${file1}chr${i}${file3}.smp90;done

for j in {9..1}
do
    a=$(echo "scale = 2; $j / 100" | bc);b=$(echo "scale = 2; 99 - $j" | bc);c=$(echo "scale = 2; 100 - $j" | bc)
    for i in {1..22} X Y;do plink --bfile ${path1}${file1}chr${i}${file3}.smp$b --geno ${a} --make-bed --out ${path1}${file1}chr${i}${file3}.snp${c};done
    for i in {1..22} X Y;do plink --bfile ${path1}${file1}chr${i}${file3}.snp$b --mind ${a} --make-bed --out ${path1}${file1}chr${i}${file3}.smp${c};done
done

# Check the number of variants and samples.
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

> - Multi-processing
```
$ emacs cmd.sh
#!/bin/bash

file1='GROUP'
file2='.option1'
file3='.op1'
file4='.cmd'

path0=/${file1}/data/
path1=${path0}test/
path2=${path0}inform/
path3=${path0}cmd_list/


# Remove variants and samples which have missing genotypes with 0.10 to 0.01 frequencies.
for i in {1..22} X Y;do echo "plink --bfile ${path0}${file1}_chr${i}${file2} --geno 0.1 --make-bed --out ${path1}${file1}_chr${i}${file3}.snp90";done > ${path3}${file1}${file3}.snp90.cmd
for i in {1..22} X Y;do echo "plink --bfile ${path1}${file1}_chr${i}${file3}.snp90 --mind 0.1 --make-bed --out ${path1}${file1}_chr${i}${file3}.smp90";done > ${path3}${file1}${file3}.smp90.cmd

for j in {9..1}
do
    a=$(echo "scale = 2; $j / 100" | bc);b=$(echo "scale = 2; 99 - $j" | bc);c=$(echo "scale = 2; 100 - $j" | bc)
    for i in {1..22} X Y;do echo "plink --bfile ${path1}${file1}_chr${i}${file3}.smp$b --geno ${a} --make-bed --out ${path1}${file1}_chr${i}${file3}.snp${c}";done > ${path3}${file1}${file3}.snp${c}.cmd
    for i in {1..22} X Y;do echo "plink --bfile ${path1}${file1}_chr${i}${file3}.snp$b --mind ${a} --make-bed --out ${path1}${file1}_chr${i}${file3}.smp${c}";done > ${path3}${file1}${file3}.smp${c}.cmd
done

for j in {90..99}
do
    parallel {} < ${path3}${file1}${file3}.snp${j}.cmd && parallel {} < ${path3}${file1}${file3}.smp${j}.cmd
done

# Check number of variants and samples from 0.90 to 0.95 frequencies.
for j in {90..99}
do
    for i in {1..22} X Y;do wc -l ${path1}${file1}_chr${i}${file3}.snp${j}.bim;done > ${path2}${file1}${file3}.snp${j}.inf0
    awk '{print $1}' ${path2}${file1}${file3}.snp${j}.inf0 > ${path2}${file1}${file3}.snp${j}.inf
    for i in {1..22} X Y;do wc -l ${path1}${file1}_chr${i}${file3}.smp${j}.fam;done > ${path2}${file1}${file3}.smp${j}.inf0
    awk '{print $1}' ${path2}${file1}${file3}.smp${j}.inf0 > ${path2}${file1}${file3}.smp${j}.inf
done

for i in {1..22} X Y;do wc -l ${file1}_chr${i}${file2}.bim;done > ${path2}${file1}${file3}.snp.inf0
awk '{print $1}' ${path2}${file1}${file3}.snp.inf0 > ${path2}${file1}${file3}.snp.inf
for i in {1..22} X Y;do wc -l ${file1}_chr${i}${file2}.fam;done > ${path2}${file1}${file3}.smp.inf0
awk '{print $1}' ${path2}${file1}${file3}.smp.inf0 > ${path2}${file1}${file3}.smp.inf

rm ${path2}${file1}${file3}.*.inf0

# Generate chromosome numbers' index
for i in {1..22} X Y;do echo ${i};done > ${path2}${file1}${file3}.idx

a=$(for j in {90..99} X Y;do printf ${path2}${file1}${file3}.snp${j}.inf" ";done)
paste ${path2}${file1}${file3}.idx ${path2}${file1}${file3}.snp.inf $a > ${path2}${file1}${file3}.snp_90_99.inf
a=$(for j in {90..99} X Y;do printf ${path2}${file1}${file3}.smp${j}.inf" ";done)
paste ${path2}${file1}${file3}.idx ${path2}${file1}${file3}.smp.inf $a > ${path2}${file1}${file3}.smp_90_99.inf
```
