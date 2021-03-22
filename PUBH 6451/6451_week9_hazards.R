library(tidyverse); library(survival); library(multcomp); library(survminer)

# Verify the results in Table 3 of the article for the outcome of AIDS. The two research questions are:
#   Does the three-class strategy reduce the hazard of AIDS relative to the two-class strategy?
#   Does the answer to the previous question change after adjusting for clinical unit and baseline CD4 cell count?
# The relevant variables are qoi, t2qoi, and twoclass. 

#qoi - AIDS event excluding death
#t2qoi - time to AIDS event not including death or censoring (months)
#twoclass - treatment strategy, two class (1) or three class (2)

data_original <- read_csv("first6.csv")

data <- data_original %>%
  rename_with(., tolower) %>%
  dplyr::select(qoi, t2qoi, twoclass, unit, above200) %>% #pick relevant variables
  drop_na() %>% #remove NAs
  mutate(twoclass = as.factor(ifelse(twoclass==1, 2, 3)),
         unit = as.factor(unit),
         above200 = as.factor(above200))

str(data) #verify that data is coded correctly

#create survival variable
data$surv <- Surv(event = data$qoi, time = data$t2qoi, type="right")

#create cox regression model
cox.model <- coxph(surv ~ twoclass, data = data)
summary(cox.model) #summary stats

#create another regression model w/adjustment for CD4 and clinical unit
cox.model.adj <- coxph(surv ~ twoclass + unit + above200, data = data)
summary(cox.model.adj) #summary stats

#Kaplan-Meier plot by treatment group
km_surv <- survfit(surv ~ twoclass, data = data)
autoplot(km_surv) + xlab("Time (Months)") + ylab("%Survival")

#Couldn't get the summary stats by group to work, made separate data frames by group instead
class_2 <- data %>% filter(twoclass == 2) %>% mutate_if(is.factor, as.numeric)
class_3 <- data %>% filter(twoclass == 3) %>% mutate_if(is.factor, as.numeric)

library(psych)
describe(class_2$qoi)
describe(class_2$t2qoi)
describe(class_2$unit)
describe(class_2$above200)

describe(class_3$qoi)
describe(class_3$t2qoi)
describe(class_3$unit)
describe(class_3$above200)

#group of interest has lower hazard ratio relative to reference group
lar <- read_csv(file="Laryngoscope.csv")
##Modifying the intervention group variable
lar$Group <- factor(lar$Randomization, labels = c("Macintosh", "Pentax"))
##Modifying the Mallampati variable
lar$mallampati.f <- factor(lar$Mallampati,
                           labels=c("1 = Full Visibility",
                                    "2 = Upper Uvula",
                                    "3 = Uvula Base",
                                    "4 = Hard Palate"))
##Examining the asa variable
table(lar$asa)
##Modifying the asa variable
lar$asa.f <- factor(lar$asa, labels=c("II","III","IV"))
lar2 <- subset(lar, !is.na(attempt1_S_F) &
                 !is.na(Group) &
                 !is.na(asa.f) &
                 !is.na(BMI) &
                 !is.na(mallampati.f) &
                 !is.na(attempt1_time))
library(survival)
lar2$larsurv <- Surv(event = lar2$attempt1_S_F, time = lar2$attempt1_time, type="right")
cox.model.lar <- coxph(larsurv ~ Group + asa.f + BMI + mallampati.f, data=lar2)
summary(cox.model.lar)
