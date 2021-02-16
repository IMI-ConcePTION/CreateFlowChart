rm(list=ls(all.names=TRUE))

#set the directory where the file is saved as the working directory
if (!require("rstudioapi")) install.packages("rstudioapi")

diroutput <- "./testing/g_output/"
dirinput <- "./testing/i_input/"


suppressWarnings( if (file.exists(diroutput)){
} else {
  dir.create(file.path( diroutput))
})

library(data.table)
if (!require("lubridate")) install.packages("lubridate")
library(lubridate)

library(CreateFlowChart)

dirtemp <- dirinput

date_format <- "%Y%m%d"
study_end <- as.Date(as.character(20200531), date_format)


# FLOWCHART ---------------------------------------------------------------
load(paste0(dirtemp,"D3_exclusion_no_op_start_date.RData"))
load(paste0(dirtemp,"D3_inclusion_from_OBSERVATION_PERIODS.RData"))
load(paste0(dirtemp,"D3_exclusion_observed_time_no_overlap.RData"))

load(paste0(dirtemp,"D3_inclusion_from_PERSONS.RData"))


#MERGE THE DATASET PERSONS AND OBSERVATION_PERIODS TO HAVE INFORMATION ON AGE SEX AND LOOKBACK IN THE SAME
PERSONS_OP <- merge(D3_inclusion_from_PERSONS,
                    D3_exclusion_no_op_start_date,
                    by="person_id",
                    all.x = T)
PERSONS_OP2 <- merge(PERSONS_OP,
                     D3_inclusion_from_OBSERVATION_PERIODS,
                     by="person_id",
                     all.x = T)
PERSONS_OP3 <- merge(PERSONS_OP2,
                     D3_exclusion_observed_time_no_overlap,
                     by="person_id",
                     all.x = T)

coords<-c("sex_or_birth_date_missing","birth_date_absurd","insufficient_run_in","observed_time_no_overlap","no_op_start_date")
PERSONS_OP3[, (coords) := replace(.SD, is.na(.SD), 0), .SDcols = coords]

# CREATE study_exit_date
PERSONS_OP3 <- PERSONS_OP3[,study_exit_date:=min(date_death, exit_spell_category, study_end, na.rm = T), by="person_id"]

#USE THE FUNCTION CREATEFLOWCHART TO SELECT THE SUBJECTS IN POPULATION

selected_population <- CreateFlowChart(
  dataset=PERSONS_OP3,
  listcriteria = c("sex_or_birth_date_missing","birth_date_absurd","no_op_start_date","observed_time_no_overlap","insufficient_run_in"),
  flowchartname = "FlowChart" )


# D4_study_population contains the starting information on age and days of follow up per each patient
D4_study_population <- unique(selected_population[,.(person_id,sex,date_of_birth,study_entry_date,study_exit_date)])
#Cohort0[,index_date:=index_date]
