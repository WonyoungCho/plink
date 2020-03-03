# Data

- Data file : [test_set2.csv](data/test_set2.csv) (<https://github.com/EpistasisLab/scikit-mdr/tree/master/data>)

## vcf to bed
```
$ bgzip -c data.vcf > data.vcf.gz && tabix -p vcf data.vcf.gz
$ plink --vcf data.vcf.gz --double-id --make-bed --out data
```

## Recode allele type
<http://zzz.bwh.harvard.edu/plink/dataman.shtml>
```
$ plink --bfile mydata --recode --alleleACGT # 1234 to AGCT
$ plink --bfile mydata --recode --allele1234 # AGCT to 1234
$ plink --bfile mydata --recodeAD # Additive and dominance components, plink.raw
$ plink --bfile mydata --recode-rlist # Listing by minor allele count, plink.rlist
```

## Extract from samples
<https://www.cog-genomics.org/plink/1.9/filter>
```
$ plink --bfile mydata --keep sampleList.txt --make-bed --out mydata_sample
```
- In sampleList.txt, it should include **FamilyID** and **IndividualID**.
```
$ less sampleList.txt
HG00096	HG00096
HG00097	HG00097
HG00099	HG00099
HG00100	HG00100
HG00101	HG00101
HG00102	HG00102
HG00103	HG00103
```

## Adjust other phenotype
- case/control data
```
$ plink -bfile mydata --pheno phenotype.txt --make-bed --out mydata_gene
```
- In phenotype.txt, it should include **FamilyID**, **IndividualID** and **case/control_Phenotype**.
```
$ less phenotype.txt
HG00096	HG00096	1
HG00097	HG00097	2
HG00099	HG00099	2
HG00100	HG00100	2
HG00101	HG00101	1
HG00102	HG00102	2
HG00103	HG00103	1
```

## Extract from genes
<https://www.cog-genomics.org/plink/1.9/filter#gene>
```
$ plink --bfile mydata --gene geneList.txt --make-bed --out mydata_gene
```
<https://www.cog-genomics.org/plink/1.9/formats#set>
```
$ less geneList.txt
GENE1
rs123456
rs10912
rs66222
END

GENE2 rs66222 rs929292
rs288222 END
```

## Extract from ranges
```
$ plink --bfile mydata --extract rangeList.txt --range --make-bed --out mydata_range
```
```
The format of myrange.txt should be, one range per line, whitespace-separated:

CHR Chromosome code (1-22, X, Y, XY, MT, 0)
BP1 Start of range, physical position in base units
BP2 End of range, as above
LABEL Name of range/gene

For example,
2 30000000 35000000 R1
2 60000000 62000000 R2
X 10000000 20000000 R3
```
<https://www.cog-genomics.org/plink/1.9/filter#snp>
