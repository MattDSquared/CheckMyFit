library(shiny)

shinyUI(pageWithSidebar(
    
    headerPanel("Beat the computer: Find the best fit line."),
    
    sidebarPanel(
        sliderInput('alpha', 'Guess at the intercept, alpha',
                    value = 30, min = 0, max = 50, step = .5),
        sliderInput('beta', 'Guess at the slope, beta',
                    value = 1, min = -10, max = 10, step = 0.1)
    ),
    
    mainPanel(
        plotOutput('myScatter'), 
        tableOutput("fitData")
    )
))