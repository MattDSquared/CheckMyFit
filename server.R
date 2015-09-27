library(datasets); data(mtcars)
library(ggplot2)

shinyServer(
    function(input, output) {
        
        # FIXME: Once checkMe button is pressed, the linear model is fit on every
        # user operation. 
        calcFitCurve <- reactive({
            getConfInterval <- function(fit, xi, level) {
                sumCoef <- summary(fit)$coefficients
                sumCoef[xi,"Estimate"] + c(-1,1) * qt(.5+level/2, df = fit$df) * sumCoef[xi,"Std. Error"]
                }
            
            if (input$checkMe > 0) {
                myfit <- lm(mpg ~ am, data=mtcars)
                conflvl <- .9
                confInterval <- rbind(getConfInterval(myfit, 1, conflvl), 
                                      getConfInterval(myfit, 2, conflvl))
            }
        })
        
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
                gg <- gg + geom_smooth(method="lm", level=conflvl)
            }
            
            print(gg)
        })
        
        fitDataValues <- reactive({
            
            estimate.rmse <- sqrt(mean((mtcars$mpg - (input$alpha + input$beta*mtcars$am))^2))
            
            lineStats <- data.frame(
                Value = c("Intercept", 
                         "Slope",
                         "Mean Squraed Error (MSE)"),
                Estimate = as.character(c(input$alpha, 
                                        input$beta,
                                        round(estimate.rmse,3))), 
                stringsAsFactors=FALSE)  
            
            # Conditional graph display on button press. 
            if (input$checkMe > 0) {
                lineStats$BestFit <- as.character(round(c(myfit$coefficients["(Intercept)"], 
                                                          myfit$coefficients["am"],
                                                          sqrt(mean(myfit$residuals^2))),
                                                        3))
                lineStats$BestFit_Lower <- as.character(round(c(confInterval[,1],NA),3))
                lineStats$BestFit_Upper <- as.character(round(c(confInterval[,2],NA),3))
            }
            
            return(lineStats)
        })
        
        output$fitData <- renderTable({
            fitDataValues()
            })
        
        output$userFeedback <- renderText({
            if (input$checkMe > 0) {
                if ((input$alpha > confInterval[1,1]) & 
                    (input$alpha < confInterval[1,2]) & 
                    (input$beta > confInterval[2,1]) & 
                    (input$beta < confInterval[2,2])) {
                    sprintf("Nice! The red line is within the %d%% confidence interval (grey area).", 
                            conflvl*100)
                }
                else {
                    sprintf("Hmmm, The red line should be within the %d%% confidence interval (grey area).", 
                            conflvl*100)
                }
            }
        })
    }
)