# Data

- Data file : [test_set2.csv](data/test_set2.csv) (<https://github.com/EpistasisLab/scikit-mdr/tree/master/data>)

## Recode allele type
<http://zzz.bwh.harvard.edu/plink/dataman.shtml>
```
$ plink --bfile mydata --recode --alleleACGT # 1234 to AGCT
$ plink --bfile mydata --recode --allele1234 # AGCT to 1234
$ plink --bfile mydata --recodeAD # Additive and dominance components, plink.raw
$ plink --bfile mydata --recode-rlist # Listing by minor allele count, plink.rlist
```

## Bin samples
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

## Use other phenotype
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

## Bin genes
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
