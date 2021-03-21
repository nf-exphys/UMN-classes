library(easyPubMed)

my_query <- 'Damiano Fantini[AU] AND "2018"[PDAT]'
my_entrez_id <- get_pubmed_ids(my_query)

#extract with text format
my_abstracts_txt <- fetch_pubmed_data(my_entrez_id, format = "abstract")
head(my_abstracts_txt)

#extract with txt format
my_abstracts_xml <- fetch_pubmed_data(pubmed_id_list = my_entrez_id)
class(my_abstracts_xml)

#look for article title
my_titles <- custom_grep(my_abstracts_xml, "ArticleTitle", "char")

# use gsub to remove the tag, also trim long titles
TTM <- nchar(my_titles) > 75
my_titles[TTM] <- paste(substr(my_titles[TTM], 1, 70), "...", sep = "")

# Print as a data.frame (use kable)
head(my_titles)


#download records as txt
out.A <- batch_pubmed_download(pubmed_query_string = my_query, 
                               format = "txt", 
                               batch_size = 20,
                               dest_file_prefix = "easyPM_example",
                               encoding = "ASCII")


#### Analyzing PubMed records ####
my_PM_list <- articles_to_list(pubmed_data = my_abstracts_xml)
class(my_PM_list[1])

#extracting fields of interest using custom_grep function
curr_PM_record <- my_PM_list[1]
custom_grep(curr_PM_record, tag = "PubDate")

my.df <- article_to_df(curr_PM_record)
colnames(my.df)

custom_grep(curr_PM_record, tag = "Affiliation")


#### Making it work for me ####
library(easyPubMed); library(tidyverse)

#search for molecular exercise training, filter by last 5 years
my_query <- '(("exercise"[MeSH Terms] OR 
"exercise"[All Fields] OR 
("exercise"[All Fields] AND "training"[All Fields]) OR 
"exercise training"[All Fields]) AND ("molecular"[All Fields] OR 
"moleculars"[All Fields]) AND ("muscle, skeletal"[MeSH Terms] OR 
("muscle"[All Fields] AND "skeletal"[All Fields]) OR 
"skeletal muscle"[All Fields] OR ("skeletal"[All Fields] AND "muscle"[All Fields]))) AND (y_5[Filter])'

#Search entrez?  
my_entrez_id <- get_pubmed_ids(my_query)

#get data from pubmed
my_abstracts_xml <- fetch_pubmed_data(pubmed_id_list = my_entrez_id)

my_PM_list <- articles_to_list(pubmed_data = my_abstracts_xml)

length(my_PM_list)

affiliations <- lapply(my_PM_list, custom_grep, tag = "Affiliation")

states <- "Pennsylvania | DC | Virginia | Delaware | Maryland | New Jersey | West Virginia"

for (i in 1:length(affiliations)){
  affil_w_states <- grepl(pattern = states,affiliations[[i]])
  if (TRUE %in% affil_w_states){
    affiliations[[i]] <- affiliations[[i]]
  } else {affiliations[[i]] <- NA}
  
}

no_state_affil <- which(is.na(affiliations))
refined_affil <- affiliations[-no_state_affil]

#affil_w_states <- lapply(affiliations, str_detect, pattern = states)
which(affil_w_states == T)
str_replace_all()
which("__here__" %in% affil_w_states)
