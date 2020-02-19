GWAS (Genome-wise association study) is the way to find any variants are associated with a trait.

As a prior to analyze data, QC (quality control) is needed.

Under the guidance of the first reference, I used 'plink' and 'python' for QC.

There are few steps :


# SNP call rate > 95%
```
$ plink --file raw_data --geno 0.05 --make-bed --out variant5
  : variant5.bed + variant5.bim + variant5.fam
```
# MAF > 1%
```
$ plink --bfile variant5 --maf 0.01 --make-bed --out maf1
  : maf5.bed + maf5.bim + maf5.fam
```


# Sample call rate > 95%
```
$ plink --file maf1 --mind 0.05 --make-bed --out sample5
  : sample5.bed + sample5.bim + sample5.fam
```

To combine above qc, we can write
```
$ plink --file raw_data --geno 0.05 --maf 0.01 --mind 0.05 --make-bed --out sample5
```

# Sex info
```
$ plink --file sample5 --check-sex
```
- Male (1) : XHE > 0.80
- Female (2) : XHE < 0.20
- No sex (0) : 0.20 < XHE < 0.80


# Inbreeding : F
```
$ plink --bfile sample5 -het
  : plink.het
```
* F=(observed hom. count - expected count) / (total observations - expected count)
  
<https://www.cog-genomics.org/plink/1.9/formats#het>

# Heterozygosity : |f| = (1-O/E) < 0.1
```
$ plink --bfile sample5 --hardy
  : plink.hwe
```
In 'plink.hwe',  there are observed and expected frequencies of heterozygosity for each variants.
```
import pandas as pd

df=pd.read_csv('plink.hwe', sep='\s+')

df['F']=1-df['O(HET)']/df['E(HET)']
df['abs(F)']=abs(df['F'])
df=df[df['abs(F)'] < 0.1]
df_snp=df['SNP']
df_snp.to_csv('hetero_prun.out',index=False)
```
```
$ plink --bfile sample5 --extract hetero_prun.out --recode --out hetero_prun
  : hetero_prun.ped + hetero_prun.map
```

# LD : R2 > 0.2
```
$ plink --file hetero_prun --r2 dprime inter-chr with-freqs --ld-window-r2 0.2
  : plink.ld
```

# LD pruning
```
$ plink --file data --indep 50 5 2  # window size, step, the VIF(variance inflation factor) threshold: 1/(1-R^2)
$ plink --file data --indep-pairwise 50 5 0.5  # window size, step, R2 threshold
$ plink --file data --extract plink.prune.in --make-bed --out pruneddata
```
<http://zzz.bwh.harvard.edu/plink/summary.shtml#prune>

- Size : to compute R2 with nearest 50 SNPs, 50C2
- Step : next 5th SNP
- VIF = 1 : completely independent
- VIF = 2~10 : usual cut-off
- R2 : to remove SNPs if R2 is not less than 0.5
> - plink.prune.in : R2 < 0.5
> - plink.prune.out : R2 >= 0.5


# IBD : PI-HAT > 0.2
: It requires at least 1000 independent SNPs.

- Identical twins, and duplicates, are 100%identical by descent (Pihat 1.0)
- First-degree relatives are 50% IBD (Pihat 0.5)
- Second-degree relatives are 25% IBD (Pihat 0.25)
- Third-degree relatives are 12.5% equal IBD (Pihat 0.125)
```
$ plink --file hetero_prun --genome --genome-full --min 0.2 # --max 0.5
  : plink.genome
```
```
import pandas as pd

df=pd.read_csv('plink.genome',sep='\s+')

ys, xs, patches=plt.hist(df['PI_HAT'].values,bins=[0,0.125,0.25,0.5,1],rwidth=0.8)
for i in range(0, len(ys)):
    plt.text(x=xs[i], y=ys[i],
             s=int(ys[i]),#s='{:0>4.1f}%'.format(ys[i]),
             fontsize=8,
             color='red')
y_min, y_max = plt.ylim()
plt.ylim(y_min, y_max+0.05)
plt.yticks([])
plt.xticks([0,0.125,0.25,0.5,1],fontsize=6)
plt.grid(ls='--',alpha=0.6)    
plt.show()
```
**Ex)** Z(IBD) = (0.4106, 0.0444, 0.5450), PI_HAT = 0.5672, IBS_DIST = 0.943380, IBS = (6, 53, 515)

- IBS (Identity by State) vs IBD (Identity by Descent)
![IBS_IBD](./image/IBS_IBD.PNG)
> : Chapter 8 in [A Statistical Approach to Genetic Epidemiology: With Access to E‐Learning Platform by Friedrich Pahlke, 2nd ed](https://onlinelibrary.wiley.com/doi/book/10.1002/9783527633654).

- P(IBD=0)=N(IBS=0)/N(IBS=0|IBD=0)
- P(IBD=1)=[N(IBS=1)-P(IBD=0)N(IBS=1|IBD=0)]/N(IBS=1|IBD=1)
- P(IBD=2)=[N(IBS=2)-P(IBD=1)N(IBS=2|IBD=1)-P(IBD=0)N(IBS=2|IBD=0)]/N(IBS=2|IBD=2)

![probIBD](./image/probIBD.PNG)
> : p12 in [PLINK: A Tool Set for Whole-Genome Association and Population-Based Linkage Analyses](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1950838/).


- The IBS method works best when only independent SNPs are included in the analysis.
- Independent SNP set for IBS calcuation is generally prepared by removing regions of extended LD and pruning the remaining regions so that no pair of SNPs within a given window (say, 50kb) is correlated.
- Related individuals will share more alleles IBS than expected by chance, with the degree of additional sharing proportional to the degree of relatedness.
<http://www.bioinf.wits.ac.za/courses/gwas/OLD/Qc_combined_final.pdf> P.18


# PCA (take clustered data)
```

```

# HWE : p < 1E-5
in controls.

- One way to find genotyping errors.
- Deviation from HWE may also be due to precesses related to disease, and in genenral it is best not to discard SNPs that are only mildly discordant with HWE, but only to flag them for extra checking if they do who association with phenotype.

- HWE holds only under the following assumption,
> - Random mating.
> - No selection or migration.
> - No mutation.
> - No population stratification.
> - Infinite population size.

- [A Note on Exact Tests of Hardy-Weinberg Equilibrium, Janis E. Wigginton, David J. Cutler and Gonc¸alo R. Abecasis, Am. J. Hum. Genet. 76:887–883, 2005.](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1199378/)
> - Source code : <https://csg.sph.umich.edu/abecasis/Exact/index.html>
- [Eighty Years Ago: The Beginnings of Population Genetics, James F. Crow and William F. Dove, Genetics 119:473–476, 1988.](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1203431/)

Evidence for departure from HWE has been userd in many applications of discrete P-values in HWE testing.

- Inferring the existence of natural selection :
> - [Wallace, B., 1958 The comparison of observed and calculated zygotic distributions. Evolution 12: 113–115.](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1558-5646.1958.tb02935.x)
> - [Lewontin, R. C., and C. C. Cockerham, 1959 The goodness-of-fit test for detecting natural selection in random mating populations. Evolution 13: 561–564.](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1558-5646.1959.tb03043.x)
- Chanllenging the statistical analysis of forensic DNA profile :
> - [Cohen, J. E., M. Lynch and C. E. Taylor, 1991 Forensic DNA tests and Hardy-Weinberg equilibrium. Science 253: 1037–1038.](https://science.sciencemag.org/content/253/5023/1037.long)
> - [Weir, B. S., 1992 Population genetics in the forensic DNA debate. Proc. Natl. Acad. Sci. USA 89: 11654–11659.](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC50614/)
- Detecting genotyping errors :
> - [Gomes, I., A. Collins, C. Lonjou, N. S. Thomas, J. Wilkinson et al., 1999 Hardy-Weinberg quality control. Ann. Hum. Genet. 63:
535–538.](https://onlinelibrary.wiley.com/doi/abs/10.1046/j.1469-1809.1999.6360535.x)
> - [Zou, G. Y., and A. Donner, 2006 The merits of testing Hardy-Weinberg equilibrium in the analysis of unmatched case-control data:
a cautionary note. Ann. Hum. Genet. 70: 921–933.](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1469-1809.2006.00267.x)


# After imputation
## Linear regression : R2 > 0.7
- The linear model regressing each imputed SNP on regional typed SNPs.

## MAF > 0.01

# Bonferonni-correction : p < 5E-8

# Q-Q plot
- To compare observed and expected quantities

#  LD Block

# Low quality SNP
- Genotype clusters of many SNPs demonstrate low quality genotyping due to:
> - Low DNA concentration
> - Poor binding and competitive binding by other sequences
> - Structural and copy number variants

# Reference
- A guide to genome-wide association analysis and post-analytic interrogation, <https://dx.doi.org/10.1002/sim.6605>
- GWAS QC-theory and steps, <http://www.bioinf.wits.ac.za/courses/gwas/OLD/Qc_combined_final.pdf>
