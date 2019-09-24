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

# Image map
```
def color_table(df_given,group,title,test):
    df=df_given

    a=df.loc[group]
    x=a.values.astype(int)

    ye=a.shape[0]
    xe=a.shape[1]

    #levels = [0, 1, 2]
    #colors = ['white','orangered', 'mediumspringgreen','dodgerblue']
    levels = [0, 1, 2, 3, 4]
    colors = ['red','dodgerblue','orange','mediumspringgreen',]

    cmap, norm = matplotlib.colors.from_levels_and_colors(levels, colors)

    fig, ax = plt.subplots()

    ax.imshow(x, interpolation='none', cmap=cmap, norm=norm)
    ax.set_title(title+' ( '+str(ye)+' / '+str(xe)+' )')
    ax.set_xlabel('Variants')
    ax.set_ylabel('Samples')

    plt.xticks(np.arange(-0.5, xe+0.5, step=10),labels=range(0,xe+1,10),fontsize=6)
    plt.yticks(np.arange(-0.5, ye+0.5, step=5),labels=range(0,ye+1,5),fontsize=6)
    plt.grid()
    #plt.subplots_adjust(left = 0, bottom = 0, right = 1, top = 1, hspace = 0, wspace = 0)
    #plt.show()
    plt.tight_layout(pad=0.4, w_pad=0.5, h_pad=0.5)
    plt.savefig('fig_table'+str(test)+'_'+title, bbox_inces='tight', pad_inches=0, dpi=300)
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

# Filtering
```
def filter_123(group,subgroup,title):
    df_group = df123.loc[group].T
    nonsubgroup=np.setdiff1d(group,subgroup)

    df_gene=df0['gene']
    all_group=[]
    all_geno=[]
    all_geno2=[]
    all_geno3=[]
    all_geno4=[]

    for i in df_group.index:
        vc0=df_group.loc[i].value_counts()
        vg00=0; vg01=0; vg02=0

        if len(vc0.index.values) >= 2:
            if len(subgroup)*0.05 < 2:
                thres=2
            else: thres=len(subgroup)*0.05

            if 1 in vc0: vg00=vc0[1]
            if 2 in vc0: vg01=vc0[2]
            if 3 in vc0: vg02=vc0[3]
            #if vg00>=thres and vg01>=thres and vg02>=thres:
            #################
            if vg01>=thres and (vg00>=thres or vg02>=thres):

                if vg00 < vg02:
                    df_group.loc[i]=df_group.loc[i].replace(1,4)
                    df_group.loc[i]=df_group.loc[i].replace(3,1)
                    df_group.loc[i]=df_group.loc[i].replace(4,3)
                ############

                vc1=df_group.loc[i].value_counts()
                vc2=df_group.loc[i,subgroup].value_counts()
                vc3=df_group.loc[i,nonsubgroup].value_counts()

                vg10=0; vg11=0; vg12=0
                vg20=0; vg21=0; vg22=0
                vg30=0; vg31=0; vg32=0

                if 1 in vc1: vg10=vc1[1]
                if 2 in vc1: vg11=vc1[2]
                if 3 in vc1: vg12=vc1[3]
                if 1 in vc2: vg20=vc2[1]
                if 2 in vc2: vg21=vc2[2]
                if 3 in vc2: vg22=vc2[3]
                if 1 in vc3: vg30=vc3[1]
                if 2 in vc3: vg31=vc3[2]
                if 3 in vc3: vg32=vc3[3]

                all_geno2.append([vg20,vg21,vg22])
                all_geno3.append([vg30,vg31,vg32])
                all_geno4.append([vg20,vg21,vg22,vg30,vg31,vg32])

                all_geno.append([vg10,vg11,vg12])

                all_group.append(vc0.name)

    df_fgeno=df_group.loc[all_group].T

    new_col=[]
    for i in df_fgeno.columns:
        new_col.append(df_gene.loc[i]+'/'+i)

    df_fgeno.columns=new_col

    color_table(df_fgeno,group,title,5)
    dist_plot(all_geno,all_group,df_gene,title+'_all')
    dist_plot(all_geno4,all_group,df_gene,title)
    
    return df_fgeno
```

