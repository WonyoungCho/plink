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

# Heterozygosity : |F| = (1-O/E) < 0.1
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

# LD : R2 > 0.2
```
$ plink --file ld_prun --r2 d inter-chr with-freqs --ld-window-r2 0.2
  : plink.ld
```
# PCA (take clustered data)
```

```

# HWE : p < 1E-6
in controls.

- One way to find genotyping errors.

# After imputation
## Linear regression : R2 > 0.7
- The linear model regressing each imputed SNP on regional typed SNPs.

## MAF > 0.01

# Bonferonni-correction : p < 5E-8

# Q-Q plot
- To compare observed and expected quantities

#  LD Block

# Reference
- A guide to genome-wide association analysis and post-analytic interrogation, <https://dx.doi.org/10.1002/sim.6605>
