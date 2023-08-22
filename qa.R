library(dbplyr)

setwd(dirname(rstudioapi::getSourceEditorContext()$path))

con <- DBI::dbConnect(RSQLite::SQLite(), dbname = "main.sqlite")

courses <- dplyr::tbl(con, 'courses')

print(courses, n = 50)
