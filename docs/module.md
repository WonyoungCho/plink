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
