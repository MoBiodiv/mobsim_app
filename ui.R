#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(mobsim)

# Define UI for slider demo application
  
  fluidPage(theme="simplex.min.css",
            tags$style(type="text/css", "label {font-size: 12px;}"),
            tags$h2("Visualization of biodiversity pattern"),
    fluidRow(
    column(4, 
           # Check box
           selectInput("select", label = h3("SAD type"), 
                       choices = list("Log normal" = "lnorm"),#, "ls"="ls"), 
                       selected = "lnorm"), 
                                      #"bs" = "bs", "gamma"="gamma", "Geometric"="geom", 
                                      # "mzsm"="mzsm", "multinomial"="nbinom", "pareto"="pareto", "poison log"="poilog", 
                                      # "power"="power", "volkov"="volkov", "powbend"="powbend", "weibull"="weibull"
           
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
           submitButton("Restart Simulation")
           
    ),
    column(8, plotOutput("InteractivePlot", height="600px"))
  )  
)