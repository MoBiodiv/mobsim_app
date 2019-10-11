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

		fluidPage(
			fluidRow(
				column(width=4,
					# Slider inputs
					sliderInput("N", "Number of individuals",
									min=10, max=5000, value=500, step=50, ticks=F),
					
					sliderInput("S", "Species Richness",
									min=5, max=500, value=5, step=5, ticks=F),
					
					selectizeInput("sad_type", "SAD Type", choices=c("lognormal"="lnorm","geometric"="geom","Fisher's log-series"="ls")),
					
					# This outputs the dynamic UI (user input) component (CV(abundance))
					uiOutput("CVslider")
				),
				column(width=4,
					selectizeInput("method_type", label="Method", choices=c("Random mother points"="random_mother_points", "Click for mother points"="click_for_mother_points", "User community file"="uploading_community_data"), selected="Random mother points", multiple=FALSE),
					
					#sliderInput("spatagg", "Spatial Aggregation (mean distance from mother points)", min = 0, max = 2, value = 0.1, step= 0.01, ticks=F),
					textInput(inputId="spatagg", label="Spatial Aggregation (mean distance from mother points)", value = 0.1),
											
					selectizeInput(inputId="spatdist", "Cluster parameter", choices = c("Number of mother points"="n.mother", "Number of clusters"="n.cluster")),
					
					textInput(inputId="spatcoef",label="Integer values separated by commas", value="1")
				),
				
				column(width=4,
					uiOutput("species_ID_input"),
					plotOutput("on_plot_selection",
						click = "plot_click",
						brush = "plot_brush"
					),
					
					uiOutput("rem_point_button"),
					uiOutput("rem_all_points_button"),
					
					# tableOutput("table"),
					uiOutput("info")
				)
			)
		),
		
		fluidRow(
			column(width=6, offset=4,
				fileInput(inputId="community", label="Choose rData  community File", multiple = FALSE,
					accept = "", width = NULL,
					buttonLabel = "Browse...", placeholder = "No file selected")	# c("text/csv", "text/comma-separated-values,text/plain", ".csv")
			),
			column(width=2)
		),
		
		fluidRow(
			column(width=6, offset=5,
				# Action button
				actionButton(inputId="Restart",label="Restart Simulation")#,
				
				# Check box
				# checkboxInput('keep', 'Keep last simulation', FALSE) 
			),
			column(width=1)				
		),
		
		fluidRow(
			column(width=8, offset=3,
				plotOutput("InteractivePlot", height="600px",width="750px")
			),
			column(width=1)
		)
	),
	
	tabPanel("Introduction", includeMarkdown("introduction.md"))
	# another tabPanel "Saved simulation" with the previous sim?
)