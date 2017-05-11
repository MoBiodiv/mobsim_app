#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(devtools)
install_github('MoBiodiv/mobsim')    # downloads the latest version of the package
library(mobsim)


# Define server logic for slider examples
shinyServer(function(input, output) {
  
   ## plot theme
  output$InteractivePlot <- renderPlot({
    set.seed(229376)
    
    sim.com <- sim_thomas_community(s_pool = input$S, n_sim = input$N, sigma=input$spatagg, sad_type = input$select, sad_coef=list(cv_abund = input$cv.abund), fix_s_sim = T)

    layout(matrix(c(0,1,1,2,2,0,
                    0,3,3,3,3,0,
                    4,4,5,5,6,6), byrow = T, nrow = 3, ncol = 6),
           heights = c(1,1.2,1))
    
    sad1 <- community_to_sad(sim.com)
    sac1 <- spec_sample_curve(sim.com)
    divar1 <- divar(sim.com)
    dist1 <- dist_decay(sim.com)
    
    plot(sad1, method = "octave")
    plot(sad1, method = "rank")
    
    plot(sim.com)
    
    plot(sac1)
    plot(divar1)
    plot(dist1)
    
  })
})