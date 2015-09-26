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
                gg <- gg + geom_text(aes(x=.5, y=10, label = "hello world!"))
            }
            
            print(gg)
        })
        
        fitDataValues <- reactive({
            mse <- mean((mtcars$mpg - (input$alpha + input$beta*mtcars$am))^2)
            
            data.frame(
                Name = c("Intercept", 
                         "Slope",
                         "Mean Squraed Error (MSE)"),
                Value = as.character(c(input$alpha, 
                                       input$beta,
                                       mse)), 
                stringsAsFactors=FALSE)
        })
        
        output$fitData <- renderTable({
            fitDataValues()
        })
        
    }
)