#' quickglance UI Function
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_quickglance
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
#' 
mod_quickglance_ui <- function(id){
  ns <- NS(id)
  pageContainer(
    class = "header dark",
    h2("Performance Deiner Artikel"),
    echarts4r::echarts4rOutput(ns("quickglance"), height = "75vh")
  )
}

# Module Server

#' @rdname mod_quickglance
#' @export
#' @keywords internal
#' 
mod_quickglance_server <- function(input, output, session){
  ns <- session$ns

  
  output$quickglance <- echarts4r::renderEcharts4r({
    k <- df %>% 
      dplyr::filter(publish_date >= report_date - 7) %>% 
      dplyr::mutate(kicker_title_abbrev = stringr::str_wrap(kicker_title, 50))
    k %>% 
      echarts4r::e_charts(page_views) %>% 
      echarts4r::e_data(data = dplyr::group_by(k, kicker_title_abbrev), x = kicker_title_abbrev) %>% 
      echarts4r::e_scatter(page_views, bind = kicker_title_abbrev, y_index = 0, x_index = 0) %>% 
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
      echarts4r::e_data(data = k, x = kicker_title_abbrev) %>% 
      echarts4r::e_bar(p0,
                       bind = pvrounded,
                       stack = "var",
                       itemStyle = list(
                         color = "transparent",
                         barBorderColor  = "transparent"
                       ),
                       y_index = 0, x_index = 0
      ) %>%
      echarts4r::e_bar(pupr, 
                       bind = pvrounded,
                       stack = "var",
                       itemStyle = list(
                         color = "lightgray",
                         opacity = 0.5,
                         roundCap = TRUE
                       ),
                       y_index = 0, x_index = 0
      ) %>%
      echarts4r::e_tooltip(
        formatter = htmlwidgets::JS("
                                        function(params){
                                        return('<strong>' + params.value[1] + '</strong>' + params.name)   }  ")
      ) %>%
      echarts4r::e_x_axis(
        interval = 0L,
        axisLabel = list(
          inside = FALSE,
          #show = FALSE,
          fontSize = 12
        ),
        axisTick = list(show = FALSE),
        axisLine = list(show = FALSE)
      ) %>% 
      echarts4r::e_axis_labels(
        x = NULL,
        y = NULL
      ) %>% 
      echarts4r::e_grid(left = "50%") %>% 
      echarts4r::e_flip_coords() %>% 
      echarts4r::e_legend(show = FALSE) %>% 
      echarts4r::e_datazoom(
        y_index = c(0,1),
        show = TRUE,
        type = "slider",
        id = "sliderY",
        yAxisIndex = 0,
        start = 50,
        end = 100,
        color = "green",
        fillerColor = 'lightgray',
        borderColor = '#2f2f2f',
        shadowColor = '#2f2f2f',
        handleStyle = list(
          color = "rgba(47, 47, 47, 1)",
          shadowColor = "black",
          opacity = 0.5,
          borderJoin = 'round',
          borderCap = 'round'
        ),
        handleSize = '65%',
        moveHandleSize = 7,
        moveHandleStyle = list(
          color = "rgba(47, 47, 47, 1)",
          shadowColor = "black",
          opacity = 0.5,
          borderJoin = 'round',
          borderCap = 'round'
        ),
        zoomOnMouseWheel =  FALSE,
        moveOnMouseMove = TRUE,
        moveOnMouseWheel = TRUE
      ) 
  })
}


