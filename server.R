library(datasets); data(mtcars)
library(ggplot2)

shinyServer(
    function(input, output) {
        
        # Helper functions and vars
        conflvl <- .9
        getConfInterval <- function(fit, xi, level) {
            sumCoef <- summary(fit)$coefficients
            sumCoef[xi,"Estimate"] + c(-1,1) * qt(.5+level/2, df = fit$df) * sumCoef[xi,"Std. Error"]
        }
        
        # plot showing fit curves and data
        output$myScatter <- renderPlot({
            gg <- ggplot(mtcars, aes(x=wt, y=mpg))
            gg <- gg + geom_point(colour="steelblue", size=3) +
                labs(x="Weight [1000 lb]") +
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
        
        # reactive function for calculating the real fit curve
        # FIXME: Once checkMe button is pressed, the linear model is fit on every
        # user operation. 
        calcFitCurve <- reactive({
            if (input$checkMe > 0) {
                myfit <<- lm(mpg ~ wt, data=mtcars)
                confInterval <<- rbind(getConfInterval(myfit, 1, conflvl), 
                                       getConfInterval(myfit, 2, conflvl))
            }
        })
        
        # reactive function for building the table
        fitDataValues <- reactive({
            
            estimate.rmse <- sqrt(mean((mtcars$mpg - (input$alpha + input$beta*mtcars$wt))^2))
            
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
                                                          myfit$coefficients["wt"],
                                                          sqrt(mean(myfit$residuals^2))),
                                                        3))
                lineStats$BestFit_Lower <- as.character(round(c(confInterval[,1],NA),3))
                lineStats$BestFit_Upper <- as.character(round(c(confInterval[,2],NA),3))
            }
            
            return(lineStats)
        })
        
        # table of statistics on the fit curves
        output$fitData <- renderTable({
            calcFitCurve()
            fitDataValues()
            })
        
        # user feedback text
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