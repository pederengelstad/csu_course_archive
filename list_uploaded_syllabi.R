library(Microsoft365R)
library(dplyr)

setwd(dirname(rstudioapi::getSourceEditorContext()$path))

odb <- get_business_onedrive()

dat <- odb$list_items('Apps/Microsoft Forms/Syllabus Upload Form/Question')

urls <- lapply(dat$id, function(x){
  odb$get_item_properties(itemid = x)$webUrl
}) |> 
  as.character()

dat <- dat |> 
  mutate(links = urls)

parse <- strsplit(dat$name, '_')

out <- lapply(1:length(parse), function(x){
  tibble(dept = parse[[x]][1],
         id = parse[[x]][2],
         year = parse[[x]][3],
         term = gsub('.pdf', '', parse[[x]][4]),
         link = urls[x]
         )
}) |> 
  bind_rows()

write.csv(out, 'syllabi_urls.csv', row.names = F)
