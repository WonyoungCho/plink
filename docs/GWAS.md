# GWAS QC
Genome-wise association study (GWAS) is the way to find any variants are associated with a trait.

As a prior to analyze data, quality control (QC) is needed.

Under the guidance of the first reference, I used 'plink' and 'python' for QC.

There are few steps:

# Step 1.
- call rate (SNP) > 95%, MAF > 1%
```
$ plink --file raw_data --geno 0.05 --make-bed --out variant5
  (variant5.bed + variant5.bim + variant5.fam)
$ plink --bfile variant --maf 0.01 –make-bed --out maf5
  (maf5.bed + maf5.bim + maf5.fam)
```

# Step 2.

# Reference
- A guide to genome-wide association analysis and post-analytic interrogation, <https://dx.doi.org/10.1002/sim.6605>
