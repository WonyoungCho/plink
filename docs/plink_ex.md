# LD calculation

<http://zzz.bwh.harvard.edu/plink/ld.shtml>

```
plink --bfile mydata --ld rs2840528 rs7545940  # LD between rs2840528 and rx7545940
plink --bfile mydata --r2 --ld-window 10 --ld-window-kb 1000 --ld-window-r2 0.2 # these are default values

```
