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

# Distribution
```
def dist_plot(all_geno,all_group,df_gene,title):
    df_fcnt=pd.DataFrame(all_geno,index=all_group)
    fig, ax = plt.subplots((len(all_group)-1)//8+1,8)#,constrained_layout=True)

    for i in enumerate(df_fcnt.index):
        rects=ax.flat[i[0]].bar(list(range(len(df_fcnt.columns))),df_fcnt.loc[i[1]],color=('dodgerblue','orange','mediumspringgreen','dodgerblue','orange','mediums\
pringgreen'),label=i[1])
        ttag=i[1].split('_')
        ax.flat[i[0]].set_title(ttag[0]+'_'+ttag[1], fontsize=6,fontweight="bold",position=(0.5, 1.0+0.1))
        #ax.flat[i[0]].axis('off')
        #ax.flat[i[0]].tick_params(labelsize=0)
        ax.flat[i[0]].set_xlabel(df_gene.loc[i[1]],fontsize=6,labelpad=0.5)

        ax.flat[i[0]].tick_params(which='both',labelleft=False,bottom=False,labelbottom=False)

        #ax.flat[i[0]].legend()
        for rect in rects:
            height = rect.get_height()
            ax.flat[i[0]].annotate('{}'.format(height),
                                   xy=(rect.get_x() + rect.get_width() / 2, height),
                                   xytext=(0, 3),  # 3 points vertical offset
                                   textcoords="offset points",
                                   fontsize=5,
                                   ha='center', va='bottom')

    for i in range(len(df_fcnt.index),len(ax.flat)):
        ax.flat[i].bar([0,1,2],[0,0,0])
        ax.flat[i].tick_params(which='both',labelleft=False,bottom=False,labelbottom=False,labelsize=0)
    fig.set_constrained_layout_pads(w_pad=2./72., h_pad=2./72.,
                                    hspace=0., wspace=0.)
    #plt.subplots(constrained_layout=True)
    #plot_children(fig, fig._layoutbox, printit=False)
    plt.tight_layout(pad=0.4, w_pad=0.5, h_pad=0.5)
    plt.subplots_adjust(hspace = 1.6)
    plt.savefig('fig_variant_'+title,dpi=300)

    plt.show()
```
