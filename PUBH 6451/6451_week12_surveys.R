#### Software Lesson Code ####
library(haven); library(survey)
hhpub = haven::read_xpt(file="hhpubR.xpt")
perpub = haven::read_xpt(file="perpubR.xpt")

head(hhpub)
summary(perpub)

library(survey)
hhdesign=svydesign(
  data=hhpub #the dataset to use
  , id= ~HOUSEID #unique observations at the level of analysis
  #squiggle indicates that the variables is stored on the previously specified dataset
  , weight= ~WTHHFIN #survey weights 
)

#WEIGHTED ESTIMATES OF MEANS
#estimate means and totals by providing analysis variable and survey design
  #add na.rm=T if missing vars
wt.tot.vehicles=svytotal(~HHVEHCNT, hhdesign)
wt.ave.vehicles=svymean(~HHVEHCNT, hhdesign) 

wt.tot.vehicles
wt.ave.vehicles

#get CIs
confint(wt.ave.vehicles)

#weighted estimates of the median with qunatiles=0.5
wt.med.vehicles=svyquantile(~HHVEHCNT, quantiles=.5, ci=TRUE, design=hhdesign, ties="rounded")
wt.med.vehicles

#WEIGHTED ESTIAMTES OF PROPORTIONS
#Answers question of what proportion of Americans use public transport when traveling? 
#USEPUBTR is where this data is stored, 01=Y and 02=N

#create survey design
perdesign=svydesign(
  data=perpub
  , id= ~PERSONID
  , weight= ~WTPERFIN
)

#find  mean proportion and indicate that variable is categorical
  #this doesn't work well when proportions are close to 0 or 1
  #use syvciprop() instead
wt.p.pubtr=svymean(~factor(USEPUBTR), perdesign)
wt.p.pubtr

#use when proportions close to 0 or 1
  #only allows for binary indicator variables, specified with I()
svyciprop(~I(USEPUBTR=="01"), perdesign)

#gives weighted frequency
wt.freq.pubtr=svytotal(~factor(USEPUBTR), perdesign)
wt.freq.pubtr


#### Homework Code ####
library(haven); library(survey); library(tidyverse)

ds = haven::read_xpt(file="DS2TOT_F.xpt")
#DS2DS is any supplements taken (1=Y, 2=N)
#DS2TFIBE is the fiber supplement intake
#DS2TVD is the vitamin D intake
#SEQN will serve as ID variable
#WTDR2D as weights

ds_clean <- ds %>% 
  select(DS2DS, DS2TFIBE, DS2TVD, SEQN, WTDR2D) %>% #keep only vars of interest
  drop_na(WTDR2D) #remove NAs in weight variable to avoid error in svydesign()

hhdesign=svydesign(
  data=ds_clean #the dataset to use
  , id= ~SEQN #unique observations at the level of analysis
  #squiggle indicates that the variables is stored on the previously specified dataset
  , weight= ~WTDR2D #survey weights 
  )

#WEIGHTED ESTIMATES OF MEANS
#estimate means and totals by providing analysis variable and survey design
#add na.rm=T if missing vars
wt.tot.vehicles=svytotal(~HHVEHCNT, hhdesign)
wt.ave.vehicles=svymean(~HHVEHCNT, hhdesign) 

wt.tot.vehicles
wt.ave.vehicles

#get CIs
confint(wt.ave.vehicles)

#weighted estimates of the median with qunatiles=0.5
wt.med.vehicles=svyquantile(~HHVEHCNT, quantiles=.5, ci=TRUE, design=hhdesign, ties="rounded")
wt.med.vehicles

#WEIGHTED ESTIAMTES OF PROPORTIONS
#Answers question of what proportion of Americans use public transport when traveling? 
#USEPUBTR is where this data is stored, 01=Y and 02=N

#create survey design
perdesign=svydesign(
  data=perpub
  , id= ~PERSONID
  , weight= ~WTPERFIN
)

#find  mean proportion and indicate that variable is categorical
#this doesn't work well when proportions are close to 0 or 1
#use syvciprop() instead
wt.p.pubtr=svymean(~factor(USEPUBTR), perdesign)
wt.p.pubtr

#use when proportions close to 0 or 1
#only allows for binary indicator variables, specified with I()
svyciprop(~I(USEPUBTR=="01"), perdesign)

#gives weighted frequency
wt.freq.pubtr=svytotal(~factor(USEPUBTR), perdesign)
wt.freq.pubtr
