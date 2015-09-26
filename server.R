library(datasets); data(mtcars)
library(ggplot2)

shinyServer(
    function(input, output) {
        output$myScatter <- renderPlot({
            gg <- ggplot(mtcars, aes(x=am, y=mpg))
            gg <- gg + geom_point(colour="steelblue") +
                labs(x="Transmission type") +
                labs(y="Miles Per Gallon") + 
                labs(title="Find the slope and intercept for a best linear fit through the data.")
            alpha <- input$alpha
            beta <- input$beta
            gg <- gg + geom_abline(intercept = alpha, slope = beta, 
                                   colour = "red", size = 1.5)
            
            # Conditional graph display on button press. 
            if (input$checkMe > 0) {
                gg <- gg + geom_smooth(method="lm", level=.9)
            }
            
            print(gg)
        })
        
        fitDataValues <- reactive({
            
            estimate.rmse <- sqrt(mean((mtcars$mpg - (input$alpha + input$beta*mtcars$am))^2))
            
            lineStats <- data.frame(
                Name = c("Intercept", 
                         "Slope",
                         "Mean Squraed Error (MSE)"),
                Estimate = c(input$alpha, 
                             input$beta,
                             estimate.rmse))  
            
            # Conditional graph display on button press. 
            # TODO: move fit calculation outside of function so results can be
            # used over mulitple functions w/o incurring computation time.
            if (input$checkMe > 0) {
                myfit <- lm(mpg ~ am, data=mtcars)
                lineStats$BestFit <- c(myfit$coefficients["(Intercept)"], 
                                       myfit$coefficients["am"],
                                       sqrt(mean(myfit$residuals^2)))
            }
            
            # round numbers for printing
            # TODO: find a way to do this in the render function. Digits=x doesn't
            # appear to work if using the reactive function.
            #lineStats <- data.frame(round(lineStats, 3))
            
            return(lineStats)
        })
        
        output$fitData <- renderTable({
            fitDataValues()
            })
        
    }
)