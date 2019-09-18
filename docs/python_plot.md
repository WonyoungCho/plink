# Hierarchical heatmap
```
def hierarchy_heatmap(pfile):
    df_h=pd.read_csv(pfile).set_index('id')
    gp_re=gp.sort_values('group', ascending=False)
    gp1_re= gp_re[gp_re['test']==1].index.values
    gp2_re= gp_re[gp_re['test']==2].index.values

    sns.clustermap(df_h.loc[gp1].dropna(), cmap='coolwarm', robust=True)
    plt.savefig('gp1_hmap',dpi=300)
    plt.clf()

    sns.clustermap(df_h.loc[gp2].dropna(), cmap='coolwarm', robust=True)
    plt.savefig('gp2_hmap',dpi=300)
    plt.clf()
```

