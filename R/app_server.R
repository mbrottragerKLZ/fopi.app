#' @import shiny
app_server <- function(input, output, session) {

  echarts4r::e_common(
    font_family = "Playfair Display",
    theme = "vintage"
  )

  output$title <- typedjs::renderTyped({
    typedjs::typed(c("Hi there ... ^1000", "Willkommen in Deinem^500<br>CUE Dashboard"), typeSpeed = 25, smartBackspace = TRUE)
  })

  callModule(mod_quickglance_server, "quickglance")
  callModule(mod_deepdive_server, "deepdive")
  

}
