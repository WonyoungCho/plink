# CSV to PLINK
: csv to (map, ped)

- CSV format : columns=[CHR, id, pheno, variant1, variant2,...]
> - CHR : chromosome
> - pheno : case 1 / control 0

```
#!/usr/bin/env python

import sys

infile_name = sys.argv[1]

pedDict = {
    "0" : "0 0",
    "1" : "A A",
    "2" : "A a",
    "3" : "a a"
}

def convertToPlink(infile_name):
    with open(infile_name, 'r') as infile:
        header = infile.readline().rstrip().split()
        chromosome = infile.readline().split()[0]
        with open('test' + chromosome + '.map', 'w') as mapfile:
            a=1
            for POS in header[3:]:
                mapfile.write("\t".join([chromosome,POS, "0", str(a)])+"\n")
                a+=1
    with open(infile_name, 'r') as infile:
        with open('test' + chromosome + '.ped', 'w') as pedfile:
            id_index = 0
            for line in infile:
                if not line.startswith("CHR"):
                    id_index += 1
                    ID = "i_" + str(id_index)
                    line = line.rstrip().split()
                    IID= line[1]
                    pheno = str(int(line[2])+1)

                    pedfile.write(" ".join([ID, IID, "0", "0", "0",pheno]+[pedDict[genotype] for genotype in line[3:]])+ "\n")

convertToPlink(infile_name)
```

# Include charactors or words

```
df=pd.read_csv('mydata.csv')
col=df.columns

searchfor=['hel','good']
s1=col[col.str.contains('|'.join(searchfor))]

print(s1.values)
```
```
['hello', 'hellgate', 'good_morning', 'good_afternoon']
```

# Split by separator
```
a=[['asd/123',34],['qwe/234',45],['zxc/456',67],['fgh/678',89]]

df=pd.DataFrame(a)

print(df)
print()
print(df[0].str.split('/'))
print(df[0].str.split('/').shape)
print(df[0].str.split('/',expand=True))
print(df[0].str.split('/',expand=True).shape)
```
```
         0   1
0  asd/123  34
1  qwe/234  45
2  zxc/456  67
3  fgh/678  89

0    [asd, 123]
1    [qwe, 234]
2    [zxc, 456]
3    [fgh, 678]
Name: 0, dtype: object
(4,)
     0    1
0  asd  123
1  qwe  234
2  zxc  456
3  fgh  678
(4, 2)
```

# Merge two dataframes
```
df_final=pd.merge(df_left,df_right,left_index=True, right_index=True,how='left')
```

# Contains value
```
import pandas as pd

df=pd.read_csv('mydata.csv',sep='\t+|\s+',header=None)

col=df[1]

s1=col[col.str.contains('.1', regex=False)]

print(len(s1))
```

# String to number in DF
```
df=df.apply(pd.to_numeric, errors='ignore')
```

# Merge dataframes
```
df2=pd.merge(df,df1, how='outer', left_index=True, right_index=True)
```

# Display all
```
with pd.option_context('display.max_rows', None, 'display.max_columns', None):
    print(df)
```

# Separate ID
```
import pandas as pd

df =pd.read_csv('list',sep='/',header=None)
df0=df[5].str.split('.',expand=True)[0]
step=100

for j in range(0,df.shape[0],step):
    if j== df.shape[0]//step*step:
        step=df.shape[0]%step
    ini=j
    fin=ini+step

    df1=pd.DataFrame(['hs38DH_re.txt'])
    df1=df1.append([step], ignore_index=True)

    for i in enumerate(df[5].tolist()):
        if (i[0]>=ini) and (i[0]<fin):
            df1=df1.append([i[1]], ignore_index=True)

    for i in enumerate(df0.tolist()):
        if (i[0]>=ini) and (i[0]<fin):
            df1=df1.append([i[1]], ignore_index=True)

    print(df1)

    #print(df1[0].to_string(index=False))
    df1.to_csv('In_File_'+str(ini)+'.txt',index=None,header=None)
```
