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
      sliderInput("S", "Species Richness",
                  min=10, max=500, value=50, step=10),
      
      sliderInput("N", "Number of individuals",
                  min=500, max=10000, value=1000, step=100),
      
      sliderInput("cv.abund", "CV(SAD)",
                  min = 0.5, max = 3, value = 1, step= 0.5),
      
      sliderInput("spatagg", "Spatial Agregation",
                  min = 0.0, max = 1, value = 0.1, step= 0.1),
      
      # Action button
      submitButton("Restart Simulation")#,
      
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