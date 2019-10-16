# GWAS QC
Genome-wise association study (GWAS) is the way to find any variants are associated with a trait.

As a prior to analyze data, quality control (QC) is needed.

Under the guidance of the first reference, I used 'plink' and 'python' for QC.

There are few steps:

# Step 1.
- call rate (SNP) > 95%
```
$ plink --file raw_data --geno 0.05 --make-bed --out variant5
  : variant5.bed + variant5.bim + variant5.fam
```
- MAF > 1%
```
$ plink --bfile variant --maf 0.01 –make-bed --out maf5
  : maf5.bed + maf5.bim + maf5.fam
```

# Step 2.
- call rate (individual) > 95%
```
$ plink --file raw_data --mind 0.05 --make-bed --out sample5
  : sample5.bed + sample5.bim + sample5.fam
```
- LD : R2 > 0.2
```
# --indep-pairwise <window size>['kb'] <step size (variant ct)> <r^2 threshold>
$ plink --bfile sample5 --indep-pairwise 50 1 0.2 --out ld
  : ld.prun.out + ld.prun.in
  : 'ld.prun.out' is a variants list of pruning.
$ plink --bfile sample5 --extract ld.prun.out --recode --out ld_prun
  : ld_prun.ped + ld_prun.map
$ plink --file ld_prun --r2 d inter-chr with-freqs --ld-window-r2 0
  : plink.ld
```
- heterozygosity |F| = (1-O/E) < 0.1
```
$ plink --bfile sample5 --hardy
  : plink.hwe
```
In 'plink.hwe', there are observed and expected frequencies of heterozygosity of each variants.
```
import pandas as pd

df=pd.read_csv('plink.hwe', sep=\s+)

df['F']=1-df['O(HET)']/df['E(HET)']
df['abs(F)']=abs(df['F'])
df=df[df['abs(F)'] < 0.1]
df_snp=df['SNP'].values
df_snp.to_csv('hetero_prun.txt',index=False)
```
- kinship coefficients (IBD) < 0.1, PCA (take clustered data)
```

```

# Reference
- A guide to genome-wide association analysis and post-analytic interrogation, <https://dx.doi.org/10.1002/sim.6605>
