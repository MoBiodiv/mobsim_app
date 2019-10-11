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
  
navbarPage("Visualization of biodiversity pattern",
	tabPanel("Plot", 

		sidebarLayout(
    
			sidebarPanel(
      
      # Slider inputs
      sliderInput("N", "Number of individuals",
                  min=10, max=5000, value=500, step=50, ticks=F),
      
      sliderInput("S", "Species Richness",
                  min=5, max=500, value=5, step=5, ticks=F),
      
      selectizeInput("sad_type", "SAD Type", choices=c("lognormal"="lnorm","geometric"="geom","Fisher's log-series"="ls")),
      #,
      #               options = list(placeholder = 'Please select an option below',onInitialize = I('function() { this.setValue(""); }')),
		
		selectizeInput("method_type", label="Method", choices=c("Random mother points"="random_mother_points", "Click for mother points"="click_for_mother_points", "User community file"="uploading_community_data"), selected="Random mother points", multiple=FALSE),
      
		selectInput("species_ID", "Pick species ID", paste("species", 1:4, sep="_")),
		
		
		# This outputs the dynamic UI component
		uiOutput("ui"),
		
		fileInput(inputId="community", label="Choose rData  community File", multiple = FALSE,
			accept = "", width = NULL,
			buttonLabel = "Browse...", placeholder = "No file selected"),	# c("text/csv", "text/comma-separated-values,text/plain", ".csv")
		
		plotOutput("on_plot_selection",
			click = "plot_click",
			brush = "plot_brush"
		),
		
		actionButton("rem_point", "Remove Last Point"),
		actionButton("rem_all_points", "Remove All Points"),
		
		# tableOutput("table"),
		
		verbatimTextOutput("info", placeholder=F),

      #sliderInput("spatagg", "Spatial Aggregation (mean distance from mother points)", min = 0, max = 2, value = 0.1, step= 0.01, ticks=F),
		textInput(inputId="spatagg", label="Spatial Aggregation (mean distance from mother points)", value = 0.1),
						      
      selectizeInput("spatdist", "Cluster parameter", choices = c("Number of mother points"="n.mother", "Number of clusters"="n.cluster")),
      
      textInput("spatcoef",label="Integer values separated by commas", value="1"),
      
      # Action button
      actionButton(inputId="Restart",label="Restart Simulation")#,
      
      # Check box
#      checkboxInput('keep', 'Keep last simulation', FALSE)      
    ),
	 mainPanel(
		plotOutput("InteractivePlot", height="600px",width="750px")
    )
  )
),
	tabPanel("Introduction", includeMarkdown("introduction.md"))
	# another tabPanel "Saved simulation" with the previous sim?
)