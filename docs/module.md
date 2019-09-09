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
