library(shiny)

shinyUI(fluidPage(
  column(width = 11, offset = 1,
         radioButtons("Q0", label = "For all journeys combined, in the past 12 months, how frequently have you used a car, truck, or van as a driver",
                      choices = list("Never" = 1,
                                     "Less than once a month" = 2,
                                     "1-3 days/month" = 3,
                                     "about 1 day/week" = 4,
                                     "2-4 days/week" = 5,
                                     "5-7 days/week" = 6),
                      inline = TRUE, selected = character(0)
         ),
         uiOutput("DriverInput"),
         uiOutput("NonDriverInput")
  ),

  fluidRow(align = "center",
           actionButton("GoButton", "Submit"),
           tags$head(
             tags$style(HTML("hr {border-top: 1px solid #000000;}"))
           ),
           hr(),
           conditionalPanel(
             condition = "input.GoButton",
             h1("Result")
           ),
           htmlOutput("GroupName"),
           column(align = "center", width = 10, offset = 1,
                  textOutput("GroupDesc"))
           
  ),
  br(), br()
))