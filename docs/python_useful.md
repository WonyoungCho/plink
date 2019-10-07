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
