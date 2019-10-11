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
library(ggplot2)

# Define server logic for slider examples
shinyServer(function(input, output, session) {
  
  # if(keep){
  #   ...
  # }
  
  # update range for species richness, an observed species has minimum one individual
	observe({
		updateSliderInput(session, "S", min=5, max=input$N, value=5, step=5)
	})
  # update the number of species in the drop down species list.
	observe({
		updateSelectInput(session, "species_ID", "Pick species ID", paste("species", 1:input$S, sep="_"))
	})

  values <- reactiveValues()
  values$DT <- data.frame(x = numeric(),
                         y = numeric(),
                         species_ID = factor())
  
output$CVslider <- renderUI({
	if (is.null(input$sad_type))
		return()
	switch(input$sad_type,
		"lnorm"=sliderInput("coef", label="CV(abundance), i.e. standard deviation of abundances divided by the mean abundance",value=1, min=0, max=5, step=0.1, ticks=F),
		"geom"=sliderInput("coef",label="Probability of success in each trial. 0 < prob <= 1",value=0.5,min=0,max=1,step=0.1, ticks=F),
		"ls"=textInput("coef",label="Fisher's alpha parameter",value=1)
	)
})

output$species_ID_input <- renderUI({
	if (input$method_type != "click_for_mother_points")	{
		return()
	} else {
		selectInput("species_ID", "Pick species ID", paste("species", 1:input$S, sep="_"))
	}
})

output$on_plot_selection <- renderPlot({
  if (is.null(input$method_type)) {
		return()
	} else {
		if(input$method_type=="click_for_mother_points") {
				color_vector <- rainbow(input$S)
				plot(x=values$DT$x, y=values$DT$y, col=color_vector[values$DT$species_ID], xlim=c(0,1), ylim=c(0,1), xlab="", ylab="", las=1, asp=1, pch=20)
				abline(h=c(0,1), v=c(0,1), lty=2)
		}
	}
})


output$rem_point_button <- renderUI({
	if (input$method_type != "click_for_mother_points")	{
		return()
	} else {
		actionButton("rem_point", "Remove Last Point")
	}
})

output$rem_all_points_button <- renderUI({
	if (input$method_type != "click_for_mother_points")	{
		return()
	} else {
		actionButton("rem_all_points", "Remove All Points")
	}
})


output$info <- renderUI({
	if (input$method_type != "click_for_mother_points")	{
		return()
	} else {
		verbatimTextOutput("info", placeholder=F)
	}
})


# observeEvent(input$community, {
	# if (is.null(input$community)) {
			# return()
		# } else {
			 # method_type <- reactiveValues(method_type="click_for_mother_points")
		# }
# })

 
observeEvent(input$plot_click, {
add_row = data.frame(x = input$plot_click$x,
						 y = input$plot_click$y,
						 species_ID = factor(input$species_ID, levels = paste("species", 1:input$S, sep="_")))
values$DT = rbind(values$DT, add_row)
})
	 

observeEvent(input$rem_all_points, {
 rem_row = values$DT[-(1:nrow(values$DT)), ]
 values$DT = rem_row
})
	 
observeEvent(input$rem_point, {
 rem_row = values$DT[-nrow(values$DT), ]
 values$DT = rem_row
})

## point coordinates
output$info <- renderText({
	xy_str <- function(e) {
		if(is.null(e)) return("NULL\n")
		paste0("x=", round(e$x, 1), " y=", round(e$y, 1), "\n")
	}
	xy_range_str <- function(e) {
	if(is.null(e)) return("NULL\n")
		paste0("xmin=", round(e$xmin, 1), " xmax=", round(e$xmax, 1), 
				 " ymin=", round(e$ymin, 1), " ymax=", round(e$ymax, 1))
	}
	paste0(
		"click: ", xy_str(input$plot_click),
		"brush: ", xy_range_str(input$plot_brush)
	)
})
		
  ## plot theme
   
  output$InteractivePlot <- renderPlot({
    input$Restart
    
    isolate({
      
		set.seed(229376)
			
		if(input$method_type != "uploading_community_data") {
		
			spatagg_num <- as.numeric(unlist(strsplit(trimws(input$spatagg), ",")))
			spatcoef_num <- as.numeric(unlist(strsplit(trimws(input$spatcoef), ",")))
		 
			if(input$spatdist=="n.mother") n.mother <- spatcoef_num else n.mother <- NA
			if(input$spatdist=="n.cluster") n.cluster <- spatcoef_num else n.cluster <- NA
			
			
			
			simulation_parameters <- switch(input$method_type,
									"random_mother_points"=list(mother_points=n.mother, cluster_points=n.cluster, xmother=NA, ymother=NA),
									"click_for_mother_points"=list(mother_points=NA, cluster_points=NA,
										xmother=tapply(values$DT$x, values$DT$species_ID, list),
										ymother=tapply(values$DT$y, values$DT$species_ID, list))
									)
			
			sim.com <- switch(input$sad_type,
									"lnorm"=sim_thomas_community(s_pool = input$S, n_sim = input$N, 
																		  sigma=spatagg_num, mother_points=simulation_parameters$mother_points, cluster_points=simulation_parameters$cluster_points, xmother=simulation_parameters$xmother, ymother=simulation_parameters$ymother,
																		  sad_type = input$sad_type, sad_coef=list(cv_abund=input$coef),
																		  fix_s_sim = T),
									"geom"=sim_thomas_community(s_pool = input$S, n_sim = input$N,
																			sigma=spatagg_num, mother_points=simulation_parameters$mother_points, cluster_points=simulation_parameters$cluster_points, xmother=simulation_parameters$xmother, ymother=simulation_parameters$ymother,
																			sad_type = input$sad_type, sad_coef=list(prob=input$coef),
																			fix_s_sim = T),
									"ls"=sim_thomas_community(s_pool = input$S, n_sim = input$N,
																			sad_type = input$sad_type, sad_coef=list(N=input$N,alpha=as.numeric(input$coef)),
																			sigma=spatagg_num, mother_points=simulation_parameters$mother_points, cluster_points=simulation_parameters$cluster_points, xmother=simulation_parameters$xmother, ymother=simulation_parameters$ymother,
																			fix_s_sim = T)
									
			)
			
		}
		
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
  
})