library(DBI)
library(dplyr)
library(readr)
library(RSQLite)

setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# Create an ephemeral in-memory RSQLite database
con <- dbConnect(SQLite(), "main.sqlite")

# Import department history CSVs
courses <-
  list.files('depts', full.names = T)

courses <-
  read_csv(courses,
           show_col_types = F,
           col_types = c('c')) |>
  bind_rows()

syllabi <- read_csv('syllabi_urls.csv',
                    show_col_types = F,
                    col_types = c('c')) |>
  dplyr::mutate(
    id = as.character(id),
    link = case_when(!is.na(link) ~ paste0('<a href="',
                          link,
                          '" target="_blank">Syllabus</a>'),
    TRUE ~ NA_character_
  ))

courses <- courses |>
  left_join(syllabi, by = c('dept','id','term','year'))

dbWriteTable(con, "courses", courses, overwrite = T)

dbDisconnect(con)
