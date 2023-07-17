library(echarts4r)
library(tidyverse)
df <- readRDS(here::here("data/df.RDS")) %>% 
  filter(
    publish_date >= report_date - 7 
  ) 

df %>%
  e_charts(page_views) %>%
  e_data(data = group_by(df, content_id), x = kicker_title_abbrev) %>%
  e_scatter(page_views, bind = content_id) %>%
  e_mark_line(
    data = list(
      list(xAxis = 0, yAxis = "min"),
      list(xAxis = "max", yAxis = "max")
    ),
    symbol = list(
      "none",
      "roundRect"
    ),
    symbolSize = 10,
    lineStyle = list(
      width = 1,
      cap = "round",
      type = "dashed",
      opacity = 0.35,
      shadowColor = "gray",
      shadowBlur = 5,
      color = "black"
    )
  ) %>%
  e_color(color = "black") %>%
  e_data(data = df, x = kicker_title_abbrev) %>%
  e_bar(p0,
        bind = pvrounded,
        stack = "var",
        itemStyle = list(
          color = "transparent",
          barBorderColor  = "transparent"
        )
  ) |>
  e_bar(pupr, 
        bind = pvrounded,
        stack = "var",
        itemStyle = list(
          color = "lightgray",
          opacity = 0.5,
          roundCap = TRUE
        )
  ) |>
  e_tooltip(
    formatter = htmlwidgets::JS("
                                        function(params){
                                        return('<strong>' + params.value[1] +
                                        '</strong><br />Page Views erreicht: ' + params.name)   }  ")
  ) |>
  e_x_axis(
    interval = 0L,
    axisLabel = list(
      inside = FALSE,
      fontSize = 16
    ),
    axisTick = list(show = FALSE),
    axisLine = list(show = FALSE)
  ) %>%
  e_axis_labels(
    x = NULL,
    y = NULL
  ) %>%
  e_grid(left = "35%") %>%
  e_flip_coords() %>%# flip axis 
  e_legend(show = FALSE) # hide legend
