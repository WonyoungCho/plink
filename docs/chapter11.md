# Chi-square
```
$ plink --bfile mydata --allow-no-sex --model
plink.model
```
```
     CHR           Chromosome number
     SNP           SNP identifier
     TEST          Type of test : GENO, TREND, ALLELIC, DOM, REC
     AFF           Genotypes/alleles in cases
     UNAFF         Genotypes/alleles in controls
     CHISQ         Chi-squated statistic
     DF            Degrees of freedom for test
     P             Asymptotic p-value
```


# Confidence interval
```
$ plink --bfile mydata --allow-no-sex --assoc --ci 0.95
plink.assoc
```
```
     CHR     Chromosome
     SNP     SNP ID
     BP      Physical position (base-pair)
     A1      Minor allele name (based on whole sample)
     F_A     Frequency of this allele in cases
     F_U     Frequency of this allele in controls
     A2      Major allele name
     CHISQ   Basic allelic test chi-square (1df)
     P       Asymptotic p-value for this test
     OR      Estimated odds ratio (for A1, i.e. A2 is reference)
     L95     Lower bound of 95% confidence interval for odds ratio
     U95     Upper bound of 95% confidence interval for odds ratio 
```

