# Model dependency
```
def major_minor(df):
    for i in range(df.shape[0]):
        cnt=df.iloc[i].value_counts()
        if cnt[1] < cnt[3]:
            df.iloc[i]=df.iloc[i].replace(1,4)
            df.iloc[i]=df.iloc[i].replace(3,1)
            df.iloc[i]=df.iloc[i].replace(4,3)

    if model==1: df=df.replace(3,2)
    elif model==2: df=df.replace(3,1)
    elif model==3: df=df.replace(2,1); df=df.replace(3,2)
    
    return df
```

# Mask for models
ex) for 2 variants genotype, [[0 0] [0 1] [1 0] [1 1]],

1. Dominant : 0이 있으면 wild. [False False False  True]
1. Heterozygous : 1이 있으면 wild. [False  True  True  True]
1. Recessive : 0이 있으면 wild. [False False False  True]

```
def mask_array(gt,noCombo,model):
    a={1:2,2:2,3:2,4:3,5:0,6:1,7:0}
    print(gt)
    maskResult = np.full(a[model]**noCombo,True)
    if model!=4:
        zgt=list(set(np.argwhere(gt == a[model+4]).T[0]))
        maskResult[zgt]=False
        if model==2: maskResult=~maskResult

    return maskResult
```


# all, any

- all : 0이 없으면 True
- any : 전부 0이면 False

# Genotype table
```
def build_table(gt, cnt, noCombo,model):
    zgt=set(np.argwhere(gt == 0).T[0])
    ncnt=list(set(list(range(len(cnt))))-zgt)
    gt=gt[ncnt]
    cnt=cnt[ncnt]

    if model ==4: noGeno=3
    else: noGeno=2

    idx_weight = np.power(noGeno, np.arange(noCombo-1, -1, -1))
    idx = np.dot(gt-1, idx_weight)
    tb = np.zeros(noGeno**noCombo)
    tb[idx] = cnt
    tb = tb.astype(int)
    return tb
```

# Merge files
```
import pandas as pd
noCombo=3
mfile='myfile'
a= pd.read_csv(mfile+'_1.csv')
b= pd.read_csv(mfile+'_2.csv')
c= pd.read_csv(mfile+'_31.csv')
d= pd.read_csv(mfile+'_32.csv')

e=pd.merge(a,b.iloc[:,noCombo:],left_index=True, right_index=True,how='left')
f=pd.merge(c,d.iloc[:,noCombo:],left_index=True, right_index=True,how='left')
g=pd.merge(e,f,left_index=True, right_index=True,how='left')

g.to_csv(mfile+'.csv',index=False)
```

# Linkage disequilibrium
```
import numpy as np

def haplo_freq(n,PAB, PaB, PAb, Pab):
    x=n[4]*PAB*Pab/(PAB*Pab+PAb*PaB)
    y=n[4]-x

    PfAB=(n[0] + n[1]/2 + n[3]/2 + x/2)/sum(n)
    PfaB=(n[2] + n[1]/2 + n[5]/2 + y/2)/sum(n)
    PfAb=(n[6] + n[3]/2 + n[7]/2 + y/2)/sum(n)
    Pfab=(n[8] + n[5]/2 + n[7]/2 + x/2)/sum(n)

    return PfAB, PfaB, PfAb, Pfab


def haplo_iterative(n):
    PiAB=0.25; PiaB=0.25; PiAb=0.25; Piab=0.25
    a=1

    while True:
        PfAB, PfaB, PfAb, Pfab = haplo_freq(n,PiAB, PiaB, PiAb, Piab)

        D=PfAB*Pfab - PfaB*PfAb

        if D < 0:
            if PfAb-PiAb < 10**(-8): break
        elif D >=0 :
            if PfAB-PiAB < 10**(-8): break

        a+=1

        PiAB, PiaB, PiAb, Piab = PfAB, PfaB, PfAb, Pfab

    if D < 0: Dp= abs(D)/(min(PfAB, Pfab)-D)
    elif D >= 0: Dp= D/(min(PfaB, PfAb)+D)

    R2=D**2/((PfAB-D)*(Pfab-D))

    print(a,np.round([PfAB, PfaB, PfAb, Pfab, D, Dp, R2],8))


if __name__=='__main__':
    n=[726, 256, 43, 238, 245, 17, 49, 26, 0]

    n=[374, 212, 26, 471, 235, 24, 168, 80, 10]

    haplo_iterative(n)
```

# Sample size
```
import pandas as pd
import numpy as np
from scipy import stats


def minor_allele_frequency(df,group,mafLower):
    df=df[df['pheno']==group].drop(columns='pheno')
    #print(len(df.index))
    total_af=[]
    for i in df.columns.values:
        af=[i,0,0,0]
        a=0
        for j in df[i].value_counts().index.values:
            if j==0: continue
            af[j]=df[i].value_counts().values[a]
            a+=1
        total_af.append(af)

    df_maf=pd.DataFrame(total_af,columns=['SNP','0_Count','1_Count','2_Count'])
    df_maf['maf']=(df_maf['1_Count']*0.5+df_maf['2_Count'])/(df_maf['0_Count']+df_maf['1_Count']+df_maf['2_Count'])
    
    # if it is required to distinguish major and minor allel frequency,
    idx = (df_maf['MAF'] > 0.5)

    df_maf.loc[idx,['MAF']] = 1-df_maf.loc[idx,['MAF']].values

    print(len(df_maf['SNP'][idx==True].values),'/',len(df_maf['SNP'].values),'(',round(len(df_maf['SNP'][idx==True].values)/len(df_maf['SNP'].values)*100,2),'% )')
    
    #print(df_maf['SNP'][idx==True].values)

    # 
    df_maf=df_maf[df_maf['MAF']>mafLower]
    
    return df_maf['maf'].mean()


def sample_size(df,sample,alpha,beta):
    pAa=minor_allele_frequency(df,1)
    pAu=minor_allele_frequency(df,0)

    print('- MAF in cases    :', pAa)
    print('- MAF in controls :', pAu)

    pbar=0.5*(pAa+pAu)

    p_alpha=stats.norm.ppf(1-(alpha*0.01)/2)
    p_beta=stats.norm.ppf(beta*0.01)

    n=2*((p_alpha*np.sqrt(2*pbar*(1-pbar))+p_beta*np.sqrt(pAa*(1-pAa)+pAu*(1-pAu)))**2)/((pAa-pAu)**2)

    p_beta1=(np.sqrt((sample*(pAa-pAu)**2)/2)-p_alpha*np.sqrt(2*pbar*(1-pbar)))/np.sqrt(pAa*(1-pAa)+pAu*(1-pAu))
    p_alpha=(np.sqrt((sample*(pAa-pAu)**2)/2)-p_beta*np.sqrt(pAa*(1-pAa)+pAu*(1-pAu)))/np.sqrt(2*pbar*(1-pbar))

    print('---------------------------------------')
    print('Samples :',int(round(n,0)), 'for',beta,'% power')
    print('Power   :',round(int(stats.norm.cdf(p_beta1)*1000)*0.1,1),'% for', sample, 'samples')
    print('S-level :',round(int((1-(stats.norm.cdf(p_alpha)))*2000)*0.1,1),'% for', sample, 'samples')

    
if __name__=='__main__':
    df1=pd.read_csv('test_set7.txt',sep='\t').drop(columns='CHR').set_index('id')
    df2=pd.read_csv('test_set8.txt',sep='\t').drop(columns='CHR').set_index('id')

    print('=======================================')
    sample_size(df1,len(df1.index),alpha=5,beta=80)
    print('=======================================')
    sample_size(df2,len(df2.index),alpha=5,beta=80)
    print('=======================================')
```
