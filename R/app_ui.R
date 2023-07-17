#' @import shiny
app_ui <- function() {

  options <- list()

  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    pagePiling(
      sections.color = c('#2f2f2f', '#f9f7f1', '#f9f7f1', '#2f2f2f'),
      opts = options,
      menu = c(
        "Home" = "home",
        "Quick Glance" = "quickglance",
        "Deep Dive" = "deepdive",
        "About" = "about"
      ),
      pageSectionImage(
        center = TRUE,
        img = "www/img/mac.jpg",
        menu = "home",
        h1(typedjs::typedOutput("title"), class = "header shadow-dark"),
        h3(
          class = "light footer",
          tags$a("Data Team", href = "https:/kleinezeitung.at", class = "link"), "powered by", emo::ji("coffee")
        )
      ),
      pageSection(
        center = TRUE,
        menu = "quickglance",
        mod_quickglance_ui("quickglance")
      ),
      pageSection(
        center = TRUE,
        menu = "deepdive",
        mod_deepdive_ui("deepdive")
      ),
      pageSection(
        center = TRUE,
        menu = "about",
        h1("About", class = "header shadow-dark"),
        h2(
          class = "shadow-light",
          tags$a("The code", href = "https://github.com/news-r/fopi.app", target = "_blank", class = "link"),
          "|",
          tags$a("The API", href = "https://github.com/news-r/fopi", target = "_blank", class = "link")
        ),
        h3(
          class = "light footer",
          tags$a("Data Team", href = "https:/kleinezeitung.at", class = "link"), "powered by", emo::ji("coffee")
        )
      )
    )
  )
}

#' @import shiny
golem_add_external_resources <- function(){
  
  addResourcePath(
    'www', system.file('app/www', package = 'fopi.app')
  )
 
  tags$head(
    golem::activate_js(),
    golem::favicon(),
    tags$link(
      rel = "stylesheet", href = shinythemes::shinytheme("sandstone")
    ),
    tags$link(rel = "stylesheet", type = "text/css", href = "www/css/style.css"),
    tags$script(async = NA, src = "https://www.googletagmanager.com/gtag/js?id=UA-74544116-1"),
    tags$script(
      "window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-74544116-1');"
    )
  )
}
