function(input, output) {
  
  output$block_max_plot <- renderPlot({
    
    if (input$shows_ext=="All"){
      shows=show_names
    } else if (input$shows_ext == "Sitcoms") {
      shows=sitcom_names
    } else if (input$shows_ext == "Dramas") {
      shows=drama_names
    } else {shows=input$shows_ext}
    
    ext_data(shows, input$comp_ext) %>%
      ggplot(aes(as.integer(tv_year), seas_max)) + geom_line() + 
      xlab("Season Start Year") + ylab("Season Maximum")
  })
  
}