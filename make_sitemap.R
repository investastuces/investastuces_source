## Function to make site map
library(dplyr)
site_map <- c("+++",
              'title = "Sitemap"',
              paste0("date = ", Sys.Date(), collapse=""),
              "+++", "", "")

## Home
site_map <- c(site_map, 
              "- [Accueil / Homepage](https://investastuces.com)")

## Blog
site_map <- c(site_map,
              "- [Blog](https://investastuces.com/blog)")
blog_df <- data.frame(Name=character(), link=character(), category=character())
for(i in 1:length(dir("content/blog/"))) {
  df <- data.frame(Name = read.table(paste0("content/blog/", dir("content/blog/")[i]), fill=TRUE, 
                                     stringsAsFactors = FALSE) %>% filter(V1 == "title", V2 == "=") %>% 
                     slice(1) %>%
                     select(V3) %>% unlist(), 
                   link = paste0("https://investastuces.com/blog/", 
                                 unlist(strsplit(dir("content/blog/")[i], split=".md"))),
                   category = read.table(paste0("content/blog/", dir("content/blog/")[i]), fill=TRUE, 
                                         stringsAsFactors = FALSE) %>% filter(V1 == "categories", V2 == "=") %>% 
                     slice(1) %>%
                     select(V3) %>% unlist() %>% strsplit(split = '\"', fixed=TRUE) %>% 
                     lapply(., function(x) x[2]) %>% unlist())
  blog_df <- bind_rows(blog_df, df)
}
blog_df <- blog_df %>% arrange(category, Name) %>%
  group_by(Name, link, category) %>%
  mutate(sm = paste0("        - ", paste0("[", Name, "](", link, ")", collapse="")))
for(j in unique(blog_df$category)) {
  site_map <- c(site_map, paste0("    - ", j, collapse = ""))
  tmp <- blog_df %>% filter(category == j)
  for(k in 1:nrow(tmp)) {
    site_map <- c(site_map, unlist(tmp[k, "sm"]))
  }
}
  

## Simulateurs
site_map <- c(site_map, 
              "- [Simulateurs / Simulators](https://investastuces.com/simulateurs)")

## Glossaire
site_map <- c(site_map, 
              "- [Glossaire / Glossary](https://investastuces.com/glossaire)")

## A propos
site_map <- c(site_map, 
              "- [A propos / About](https://investastuces.com/a-propos)")

## Contact
site_map <- c(site_map, 
              "- [Contact](https://investastuces.com/contact)")

## Mentions legales
site_map <- c(site_map, 
              "- [Mentions l&eacute;gales](https://investastuces.com/misc/mentions-legales)")

  
## Write out the file
fileConn <- file("content/misc/sitemap.md")
writeLines(site_map, fileConn)
close(fileConn)
  