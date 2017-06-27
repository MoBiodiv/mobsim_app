#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
# library(devtools)
# install_github('MoBiodiv/mobsim')    # downloads the latest version of the package
library(mobsim, lib.loc="./Library")

# Define server logic for slider examples
shinyServer(function(input, output) {
  
  # if(keep){
  #   ...
  # }
  
   ## plot theme
  output$InteractivePlot <- renderPlot({
    set.seed(229376)
    
    sim.com <- sim_thomas_community(s_pool = input$S, n_sim = input$N, sigma=input$spatagg, sad_type = input$select, sad_coef=list(cv_abund = input$cv.abund), fix_s_sim = T)

    layout(matrix(c(1,2,3,
                    4,5,6), byrow = T, nrow = 2, ncol = 3),
           heights = c(1,1), widths=c(1,1,1))
    
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