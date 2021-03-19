library(easyPubMed)

my_query <- 'Damiano Fantini[AU] AND "2018"[PDAT]'
my_entrez_id <- get_pubmed_ids(my_query)
my_abstracts_txt <- fetch_pubmed_data(my_entrez_id, format = "abstract")
head(my_abstracts_txt)

my_abstracts_xml <- fetch_pubmed_data(pubmed_id_list = my_entrez_id)
class(my_abstracts_xml)

my_titles <- custom_grep(my_abstracts_xml, "ArticleTitle", "char")

# use gsub to remove the tag, also trim long titles
TTM <- nchar(my_titles) > 75
my_titles[TTM] <- paste(substr(my_titles[TTM], 1, 70), "...", sep = "")

# Print as a data.frame (use kable)
head(my_titles)

## Analyzing PubMed records ##
my_PM_list <- articles_to_list(pubmed_data = my_abstracts_xml)
class(my_PM_list[1])