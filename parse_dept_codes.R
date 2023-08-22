library(rvest)

setwd(dirname(rstudioapi::getSourceEditorContext()$path))

curl::curl_download(url = 'https://catalog.colostate.edu/general-catalog/courses-az/',
                    'codes.html')

html <- rvest::read_html('codes.html')

raw <- html_nodes(html, 'li') |>
  html_text()

raw <- raw[grepl(pattern = '\\)$', x = raw)]
raw <- raw[grepl('-', raw)]

out <-
  data.frame(
    code = stringr::str_extract(pattern = '(?<=\\()(.*?)(?=\\))',
                                string = raw),
    longname = stringr::str_extract(pattern = '[^\\(.*\\)]*',
                                    string =  raw) |>
      trimws()
  )

write.csv(out, 'codes.csv', row.names = F)
