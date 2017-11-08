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
shinyServer(function(input, output, session) {
  
  # if(keep){
  #   ...
  # }
  
  # update range for species richness, an observed species has minimum one individual
  observe({
    updateSliderInput(session, "S", min=5, max=input$N, value=5, step=5)
  })
  
  output$ui <- renderUI({
    if (is.null(input$sad_type))
      return()
    switch(input$sad_type,
           "lnorm"=sliderInput("coef", label="CV(abundance), i.e. standard deviation of abundances divided by the mean abundance",value=1, min=0, max=5, step=0.1, ticks=F),
           "geom"=sliderInput("coef",label="Probability of success in each trial. 0 < prob <= 1",value=0.5,min=0,max=1,step=0.1, ticks=F),
            "ls"=textInput("coef",label="Fisher's alpha parameter",value=1)
    )
  })
    
  ## plot theme
  output$InteractivePlot <- renderPlot({
    set.seed(229376)
    
    n.mother <- ifelse(input$spatdist=="n.mother", as.numeric(input$spatcoef), NA)
    n.cluster <- ifelse(input$spatdist=="n.cluster", as.numeric(input$spatcoef), NA)
    
    sim.com <- switch(input$sad_type,
                      "lnorm"=sim_thomas_community(s_pool = input$S, n_sim = input$N, 
                                                   sigma=input$spatagg, mother_points=n.mother, cluster_points=n.cluster,
                                                   sad_type = input$sad_type, sad_coef=list(cv_abund=input$coef),
                                    fix_s_sim = T),
                      "geom"=sim_thomas_community(s_pool = input$S, n_sim = input$N,                                                    sigma=input$spatagg, mother_points=n.mother, cluster_points=n.cluster, sad_type = input$sad_type, 
                                                   sad_coef=list(prob=input$coef),
                                                   fix_s_sim = T),
                      "ls"=sim_thomas_community(s_pool = input$S, n_sim = input$N,                                                    sigma=input$spatagg, mother_points=n.mother, cluster_points=n.cluster,
 sad_type = input$sad_type, 
                                                   sad_coef=list(N=input$N,alpha=as.numeric(input$coef)),
                                                   fix_s_sim = T)
                      
    )

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