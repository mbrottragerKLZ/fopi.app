# Module UI
  
#' @title   mod_ts_ui and mod_ts_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_deepdive
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_deepdive_ui <- function(id){
  ns <- NS(id)
  pageContainer(
    # class = "light",
    # h2("Relevanz Deiner Artikel"),
    # shinyWidgets::radioGroupButtons(
    #   inputId = ns("value"),
    #   label = "Metric",
    #   choices = c("rank", "score"),
    #   checkIcon = list(
    #     yes = icon("ok",
    #     lib = "glyphicon")
    #   )
    # ),
    echarts4r::echarts4rOutput(ns("quickglance"), height = "50vh")
  )
}
    
# Module Server
    
#' @rdname mod_deepdive
#' @export
#' @keywords internal
    
mod_deepdive_server <- function(input, output, session){
  ns <- session$ns
  
  
  output$quickglance <- echarts4r::renderEcharts4r({
    
    k <- df %>% 
      dplyr::filter(publish_date >= report_date - 7) 
    k %>% 
      echarts4r::e_charts(page_views) %>% 
      echarts4r::e_data(data = dplyr::group_by(k, content_id), x = content_id) %>% 
      echarts4r::e_scatter(page_views, bind = content_id) %>% 
      echarts4r::e_mark_line(
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
      echarts4r::e_color(color = "black") %>% 
      echarts4r::e_data(data = k, x = content_id) %>% 
      echarts4r::e_bar(p0,
                       bind = pvrounded,
                       stack = "var",
                       itemStyle = list(
                         color = "transparent",
                         barBorderColor  = "transparent"
                       )
      ) %>%
      echarts4r::e_bar(pupr, 
                       bind = pvrounded,
                       stack = "var",
                       itemStyle = list(
                         color = "lightgray",
                         opacity = 0.5,
                         roundCap = TRUE
                       )
      ) %>%
      echarts4r::e_tooltip(
        formatter = htmlwidgets::JS("
                                        function(params){
                                        return('<strong>' + params.value[1] +
                                        '</strong><br />Page Views erreicht: ' + params.name)   }  ")
      ) %>%
      echarts4r::e_x_axis(
        interval = 0L,
        axisLabel = list(
          inside = FALSE,
          fontSize = 4
        ),
        axisTick = list(show = FALSE),
        axisLine = list(show = FALSE)
      ) %>% 
      echarts4r::e_axis_labels(
        x = NULL,
        y = NULL
      ) %>% 
      echarts4r::e_grid(left = "10%") %>% 
      echarts4r::e_flip_coords() %>% 
      echarts4r::e_legend(show = FALSE)
  })
}


