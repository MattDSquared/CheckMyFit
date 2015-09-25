library(datasets); data(mtcars)

shinyServer(
    function(input, output) {
        output$myScatter <- renderPlot({
            plot(mtcars$am, mtcars$mpg, 
                 xlab="Transmission type", 
                 ylab="Miles Per Gallon", 
                 col="lightblue",
                 main="Find the slope and intercept for a best linear fit through the data.")
            alpha <- input$alpha
            beta <- input$beta
            abline(alpha, beta, col="red", lwd=3)
            mse <- mean((mtcars$mpg - (alpha + beta*mtcars$am))^2)
            
            textpos.x <- .25*max(mtcars$am)
            textpos.y <- .9*max(mtcars$mpg)
            textpos.linewidth <- diff(range(mtcars$mpg))/20
            text(textpos.x, textpos.y+2*textpos.linewidth, 
                 paste("intercept = ", alpha))
            text(textpos.x, textpos.y+textpos.linewidth, 
                 paste("slope = ", beta))
            text(textpos.x, textpos.y, 
                 paste("MSE = ", round(mse, 2)))
        })
        
    }
)
