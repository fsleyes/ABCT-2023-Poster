library(tidyverse)
library(lavaan)
library(haven)

raw_data <- read_sav("raw_data.sav")
test <- raw_data %>% select(contains("DTS_Total"))

df <- raw_data %>% select(contains(c("UPPS_NegativeUrgency_Total")),
                                   "T1_DTS_Total", "T6_DTS_Total",
                                   "POST_DTS_Total", "FU_DTS_Total")
#going to use T1 for PRE, T6 for MID in DTS measure

model <-




#example
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
