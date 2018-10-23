##
# devtools::install_github("dkahle/ggmap")
names(clean_df)
ggplot(clean_df,aes(x=pickup_longitude,y=pickup_latitude))+
  geom_point(size = 0.1,alpha=0.5)