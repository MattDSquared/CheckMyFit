library(shiny)

shinyUI(pageWithSidebar(
    
    headerPanel("Beat the computer: Find the line that best fits the data."),
    
    sidebarPanel(
        numericInput('alpha', 'Guess at the intercept [mpg]',
                    value = 25, min = 0, max = 100, step = .5),
        numericInput('beta', 'Guess at the slope, [mpg/x-var]',
                    value = 0, min = -20, max = 20, step = 0.1),
        actionButton("checkMe", "Check It!")
    ),
    
    mainPanel(
        plotOutput('myScatter'), 
        tableOutput("fitData"),
        textOutput('userFeedback')
    )
))