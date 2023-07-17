########################
# load the packages    #
########################
library(echarts4r) # charts
# remotes::install_github("JohnCoene/echarts4r.assets")

library(tidyverse) # general use
library(lubridate) # dates and times

###################
# get the data    #
###################
data <- readRDS("C:/Users/brottrmi/Desktop/Git/author_dashboard/data/data.RDS")

###########################
# horizontal bar chart    #
###########################

df <- data |> 
  select(
    content_id,
    kicker_title,
    url,
    report_date,
    publish_date,
    page_views,
    relevance_lwr,
    relevance_upr
  ) |> 
  mutate(
    content_id = as.character(content_id)
  ) |> 
  dplyr::rowwise() |> 
  mutate(
    p0 = quantile(relevance_lwr:relevance_upr, 0),
    p15 = quantile(relevance_lwr:relevance_upr, 0.15),
    p50 = quantile(relevance_lwr:relevance_upr, 0.50),
    p75 = quantile(relevance_lwr:relevance_upr, 0.75),
    p100 = quantile(relevance_lwr:relevance_upr, 1),
    pupr = p100-p0
  ) |> 
  dplyr::rowwise() |> 
  mutate(
    page_views = runif(1) * p100 * 1.5
  ) |> 
  tibble::rownames_to_column("model") |> 
  mutate(
    rcolour = case_when(
      (page_views < 300) | (page_views < p0*0.95) ~ "red",
      (page_views >= p0*0.95 & page_views < p0*1.05) | (page_views >= p100*1.05 & p0 < 15000) ~ "orange",
      (page_views >= p0*1.05 & page_views < p100*1.05) | (p0 == 15000 & page_views > p100) ~ "green",
      TRUE ~ "black"
    )
  ) |> 
  mutate(
    rcolour = factor(rcolour, levels = c("green", "orange", "red"))
  ) |> 
  mutate(
    symbol =  case_when(
      rcolour == "red" ~ "\U0002573",
      rcolour == "orange" & (page_views >= p100*1.05 & p0 < 15000) ~ "\U00026A0",
      rcolour == "orange" & (page_views >= p0*0.95 & page_views < p0*1.05) ~ "\U00026A0",
      rcolour == "green" & (p0 == 15000 & page_views > p100) ~ "\U0002730",
      TRUE ~ "\U0002611"
    )
  ) |> 
  arrange(p100, page_views) |> 
  mutate(
    kicker_title_abbrev = paste(kicker_title, symbol, sep = "   "), # paste(stringr::str_trunc(kicker_title, 40), symbol, sep = "   "),
    infonotice = case_when(
      rcolour == "red" ~ "Leider konnte Dein Artikel Deine Erwartungen nicht erfüllen!",
      rcolour == "orange" & (page_views >= p100*1.05 & p0 < 15000) ~ "Du hast einen Nerv getroffen! <br> Trau' die das nächste mal eine höhere Relevanzkategorie zu, um noch mehr aus Deinem Artikel zu holen!",
      rcolour == "orange" & (page_views >= p0*0.95 & page_views < p0*1.05) ~ "Probier's das nächste Mal mit einer niedrigeren Relevanzkategorie. <br> Das hilft uns Artikel insgesamt besser zu platzieren!",
      rcolour == "green" & (p0 == 15000 & page_views > p100) ~ "Wow! Besser geht's nicht!",
      TRUE ~ "Punktlandung! Deine gute Einschätzung hilft uns dabei, <br> Deine Artikel besser zu platzieren!"
    )
  ) |> 
  mutate(
    pvrounded = paste0(
      '<p style="text-align:left">', 
        'Erzielte Reichweite: ', round(page_views),
        '<br>',
        'Erwartete Reichweite: ', '[',p0, '-', p100, '] ', symbol,
        '<br>',
        '<br>',
        '<strong>', infonotice, '</strong>',
      '</p>'
      )
  ) 

saveRDS(df, here::here("data/df.RDS"))

