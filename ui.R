library(shiny)

shinyUI(pageWithSidebar(
    
    headerPanel("Beat the computer: Find the best fit line."),
    
    sidebarPanel(
        numericInput('alpha', 'Guess at the intercept [mpg]',
                    value = 25, min = 0, max = 100, step = .5),
        numericInput('beta', 'Guess at the slope, [mpg/x-var]',
                    value = 0, min = -20, max = 20, step = 0.1),
        actionButton("checkMe", "Check Me!")
    ),
    
    mainPanel(
        plotOutput('myScatter'), 
        tableOutput("fitData")
    )
))