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
