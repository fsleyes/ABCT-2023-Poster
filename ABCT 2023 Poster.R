library(tidyverse)
library(lavaan)
library(haven)

raw_data <- read_sav("raw_data.sav")
test <- raw_data %>% select(contains("DASS"))



df <- raw_data %>% select(contains(c("UPPS_NegativeUrgency_Total",
                                     "DASS")),
                          "T1_DTS_Total", "T6_DTS_Total",
                          "POST_DTS_Total", "FU_DTS_Total",
                          "DEMO_Race", "DEMO_Gender",
                          "T1_PANAS_NA_Total", "T6_PANAS_NA_Total",
                          "POST_PANAS_NA_Total", "FU_PANAS_NA_Total",
                          "Condition") %>%
  mutate(PRE_DASS_Total = rowSums(across(PRE_DASS_Depression_Score:PRE_DASS_Stress_Score), na.rm = TRUE)) %>%
  mutate(MID_DASS_Total = rowSums(across(MID_DASS_Depression_Score:MID_DASS_Stress_Score), na.rm = TRUE)) %>%
  mutate(POST_DASS_Total = rowSums(across(POST_DASS_Depression_Score:POST_DASS_Stress_Score), na.rm = TRUE)) %>%
  mutate(FU_DASS_Total = rowSums(across(FU_DASS_Depression_Score:FU_DASS_Stress_Score), na.rm = TRUE)) %>%
  mutate(PRE_DASS_Total = na_if(PRE_DASS_Total, 0)) %>%
  mutate(MID_DASS_Total = na_if(MID_DASS_Total, 0)) %>%
  mutate(POST_DASS_Total = na_if(POST_DASS_Total, 0)) %>%
  mutate(FU_DASS_Total = na_if(FU_DASS_Total, 0))



#going to use T1 for PRE, T6 for MID in DTS measure

#covariates: DASS, PANAS NA, RACE, GENDER, CONDITION
model <- '
  MID_UPPS_NegativeUrgency_Total ~ 1 + T1_DTS_Total + MID_DASS_Total + T6_PANAS_NA_Total + DEMO_Race + DEMO_Gender + Condition
  T6_DTS_Total ~ 1 + PRE_UPPS_NegativeUrgency_Total + MID_DASS_Total + T6_PANAS_NA_Total + DEMO_Race + DEMO_Gender + Condition
  POST_UPPS_NegativeUrgency_Total ~ 1 + T6_DTS_Total + POST_DASS_Total + POST_PANAS_NA_Total + DEMO_Race + DEMO_Gender + Condition
  POST_DTS_Total ~ 1 + MID_UPPS_NegativeUrgency_Total + POST_DASS_Total + POST_PANAS_NA_Total + DEMO_Race + DEMO_Gender + Condition
  FU_UPPS_NegativeUrgency_Total ~ 1 + POST_DTS_Total + FU_DASS_Total + FU_PANAS_NA_Total + DEMO_Race + DEMO_Gender + Condition
  FU_DTS_Total ~ 1 + POST_UPPS_NegativeUrgency_Total + FU_DASS_Total + FU_PANAS_NA_Total + DEMO_Race + DEMO_Gender + Condition
  PRE_UPPS_NegativeUrgency_Total ~~ T1_DTS_Total
  MID_UPPS_NegativeUrgency_Total ~~ T6_DTS_Total
  POST_UPPS_NegativeUrgency_Total ~~ POST_DTS_Total
  FU_UPPS_NegativeUrgency_Total ~~ FU_DTS_Total '

fitModel <- sem(model, data = df, missing = "ml.x", fixed.x = FALSE)
summary(fitModel, fit.measures = T)


#constrained model
consmodel <- '
  MID_UPPS_NegativeUrgency_Total ~ 1 + T1_DTS_Total + a*MID_DASS_Total + b*T6_PANAS_NA_Total + DEMO_Race + DEMO_Gender + Condition
  T6_DTS_Total ~ 1 + PRE_UPPS_NegativeUrgency_Total + a*MID_DASS_Total + b*T6_PANAS_NA_Total + DEMO_Race + DEMO_Gender + Condition
  POST_UPPS_NegativeUrgency_Total ~ 1 + T6_DTS_Total + a*POST_DASS_Total + b*POST_PANAS_NA_Total + DEMO_Race + DEMO_Gender + Condition
  POST_DTS_Total ~ 1 + MID_UPPS_NegativeUrgency_Total + a*POST_DASS_Total + b*POST_PANAS_NA_Total + DEMO_Race + DEMO_Gender + Condition
  FU_UPPS_NegativeUrgency_Total ~ 1 + POST_DTS_Total + a*FU_DASS_Total + b*FU_PANAS_NA_Total + DEMO_Race + DEMO_Gender + Condition
  FU_DTS_Total ~ 1 + POST_UPPS_NegativeUrgency_Total + a*FU_DASS_Total + b*FU_PANAS_NA_Total + DEMO_Race + DEMO_Gender + Condition
  PRE_UPPS_NegativeUrgency_Total ~~ T1_DTS_Total
  MID_UPPS_NegativeUrgency_Total ~~ T6_DTS_Total
  POST_UPPS_NegativeUrgency_Total ~~ POST_DTS_Total
  FU_UPPS_NegativeUrgency_Total ~~ FU_DTS_Total '

fitConsmodel <- sem(consmodel, data = df, missing = "ml.x", fixed.x = FALSE)
summary(fitConsmodel, fit.measures = T)


# fit4b <- sem(m4b, data = RiseDatSmall, missing= "ml.x")
# summary(fit4b, fit.measures=T)



# example
# m4b <- '
#   #regressions
#   work512 ~ 1 + MH1 + subst + psych + hmls + race + cond + inc #work512 is the outcome, the others are predictors
#   work1326 ~ 1 + work512 + MH2 + subst + psych + hmls + race + cond +inc
#   work2752 ~ 1 + MH3 + work1326 + work512 + subst + psych + hmls + race + cond + inc
#   MH2 ~ 1 + MH1 + pathd*work512 + pathf*subst + psych + hmls +race +cond + inc #I used "pathd" to constran the path from work to mental health (d on diagram)
#   MH3 ~ 1 + MH2 + pathd* work1326 + pathf*subst + psych + hmls + race + cond + inc #I used "pathf" to constrain the path from substance use to mental health
#   MH4 ~ 1 + MH3 + pathd*work2752 + pathf*subst + psych + hmls + race + cond + inc
#   MH1 ~~ work512 #THIS IS NOT IN THE DIAGRAM, BUT ITS HOW YOUD COVARY IF YOU WANTED TO
# '


