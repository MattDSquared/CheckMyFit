library(shiny)

shinyUI(pageWithSidebar(
    
    headerPanel("Check My Fit: Find the line that best fits the data."),
    
    sidebarPanel(
        p(paste0("Use the input boxes below to get the red line as ",
                      "close to the data as possible. Once you think you have ",
                      "it, click 'Check It!'")),
        numericInput('alpha', 'Guess at the intercept [mpg]',
                    value = 30, min = 0, max = 100, step = .5),
        numericInput('beta', 'Guess at the slope, [mpg/x-var]',
                    value = 0, min = -20, max = 20, step = 0.1),
        actionButton("checkMe", "Check It!")
    ),
    
    mainPanel(
        plotOutput('myScatter'), 
        tableOutput("fitData"),
        strong(textOutput(invisible('userFeedback')))
    )
))