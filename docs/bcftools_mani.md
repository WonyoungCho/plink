# Variant classification
<https://genome.sph.umich.edu/wiki/Variant_classification>

**Simple Biallelic Examples**
```
   SNP

   REF  A       
   ALT  G     #SNP, 1 ts  
   
   MNP

   REF  AT     
   ALT  GC    #MNP, 2 ts
   
   INDEL

   REF  AT      
   ALT  A     #INDEL, 1 del
   
   INDEL

   REF  AT      
   ALT  T     #INDEL, 1 del
              #Note that although the padding base differs - A vs T, this is actually a simple indel because it is simply a deletion of a A base.  
              #If you right align this instead of left aligning, then the padding will be T on both the reference and alternative alleles.
              #Simple Indel classification should be invariant whether it is left or right aligned.
   
   SV

   REF  A    
   ALT <DEL>  #SV
```



**Complex Biallelic Examples**
```
   SNP|INDEL

   REF  AT           
   ALT  G           #SNP, INDEL, 1 ts
                    #Note that it is ambiguous as to which pairing should be a SNP, as such, the transition or transversion contribution is actually
                    #not defined.  In this case, assuming it is a A/G SNP, we get a transition, but we may also consider this as a T/G SNP which
                    #is a transversion.  In such ambiguous cases, we simply consider the aligned bases after left alignment to get the transition
                    #and transversion contribution.  But please be very clear that this is an ambiguous case.  It is better to consider this simply
                    #as a complex variant.
   
   MNP|INDEL

   REF  ATT          
   ALT  GG          #MNP, INDEL, 1 ts, 1 tv, 1 del
   
   MNP|CLUMPED

   REF  ATTTT        
   ALT  GTTTC       #MNP, CLUMPED, 2 ts
                    #since all the alleles are of the same length, classified as MNP too.
   
   INDEL|CLUMPED

   REF  ATTTTTTTT    
   ALT  GTTTC       #INDEL, CLUMPED, 2 ts, 1 del
```

**Simple Multiallelic Examples**
```
   SNP

   REF  A       
   ALT  G           #SNP, 1 ts
   ALT  C           #SNP, 1 tv
   
   MNP

   REF  AG      
   ALT  GC          #MNP, 1 ts, 1 tv
   ALT  CT          #MNP, 2 tv 
   
   INDEL

   REF  ATTT    
   ALT  ATT         #INDEL, 1 del
   ALT  ATTTT       #INDEL, 1 ins
```

**Complex Multiallelic Examples**
```
   SNP|MNP

   REF  AT    
   ALT  GT          #SNP, 1 ts
   ALT  AC          #SNP, 1 ts
                    #since all the alleles are of the sample length, classified as MNP too.
   
   SNP|MNP|CLUMPED

   REF  ATTTG    
   ALT  GTTTC       #CLUMPED, 1 ts, 1 tv
   ALT  ATTTC       #SNP, 1 tv, note that we get the SNP after truncating the bases ATTT to reveal a G/C transversion SNP
                    #since all the alleles are of the sample length, classified as MNP too.
   
   SNP|MNP|INDEL

   REF  GT    
   ALT  CT          #SNP, 1 tv
   ALT  AG          #MNP, 2 tv
   ALT  GTT         #INDEL, 1 ins
   
   SNP|MNP|INDEL|CLUMPED

   REF  GTTT    
   ALT  CG          #MNP, INDEL, 2 tv, 1 del
   ALT  AG          #MNP, INDEL, 1 ts, 1 tv
   ALT  GTGTG       #SNP, INDEL, CLUMPED, 1 tv, 1 ins
```

**Structured Variants Examples**
```
   SV

   REF  G    
   ALT <INS:ME:LINE1>    #SV
   
   SV

   REF  G    
   ALT <CN4>             #SV
   ALT <CN12>            #SV
```

# Preparation
```
$ bgzip -c data.vcf > data.vcf.gz && tabix -p vcf data.vcf.gz
```

# BCFtools
```
$ bcftools view -I data.vcf.gz -Oz -o data_remove_indels.vcf.gz
$ bcftools view -v snps data.vcf.gz -Oz -o data_only_snps.vcf.gz
$ bcftools norm -d all data.vcf.gz -Oz -o data_remove_duplicate.vcf.gz  # snps|indels|both|all|exact
```
