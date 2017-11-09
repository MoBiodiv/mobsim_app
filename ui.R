#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyBS)
library(mobsim)

# Define UI for slider demo application
  
fluidPage(
  titlePanel("Visualization of biodiversity pattern"),
    
  sidebarLayout(
    
    sidebarPanel(
      
      # Slider inputs
      sliderInput("N", "Number of individuals",
                  min=10, max=5000, value=1000, step=50, ticks=F),
      
      sliderInput("S", "Species Richness",
                  min=10, max=500, value=50, step=10, ticks=F),
      
      selectizeInput("sad_type", "SAD Type", choices=c("lognormal"="lnorm","geometric"="geom","Fisher's log-series"="ls")),
      #,
      #               options = list(placeholder = 'Please select an option below',onInitialize = I('function() { this.setValue(""); }')),

      # This outputs the dynamic UI component
      uiOutput("ui"),

      sliderInput("spatagg", "Spatial Aggregation (mean distance from mother points)",
                  min = 0, max = 2, value = 0.1, step= 0.01, ticks=F),
      
      selectizeInput("spatdist", "Cluster parameter", choices = c("Number of mother points"="n.mother", "Number of clusters"="n.cluster")),
      
      textInput("spatcoef",""),
      
      # Action button
      actionButton(inputId="Restart",label="Restart Simulation")#,
      
      # Check box
#      checkboxInput('keep', 'Keep last simulation', FALSE)      
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Introduction", includeMarkdown("introduction.md")),
        tabPanel("Plot", plotOutput("InteractivePlot", height="600px",width="750px"))
      )
    )  
  )
  
)