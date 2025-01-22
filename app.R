library(shiny)
library(leaflet)
library(readr)

r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

ui <- fluidPage(
    h1("Hello folks"),
    leafletOutput("mymap"),
    p(),
    actionButton("recalc", "New points"),
    tableOutput("table")
)

server <- function(input, output, session) {
    points <- eventReactive(input$recalc,
        {
            cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
        },
        ignoreNULL = FALSE
    )

    csv_file <- read_csv2("starwars.csv")

    output$table <- renderTable({
        head(csv_file)
    })

    output$mymap <- renderLeaflet({
        leaflet() %>%
            addProviderTiles(providers$CartoDB.Positron,
                options = providerTileOptions(noWrap = TRUE)
            ) %>%
            addMarkers(data = points())
    })
}

shinyApp(ui, server)
