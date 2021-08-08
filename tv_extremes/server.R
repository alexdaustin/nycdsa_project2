function(input, output) {
  
  output$block_max_plot <- renderPlot({
    
    shows = show_select(input$shows_max)
    
    ext_data(shows, input$comp_max) %>%
      ggplot(aes(as.integer(tv_year), seas_max)) + geom_line() + 
      xlab("Season Start Year") + ylab("Season Maximum")
  
  })
  
  output$est <- renderText({
    
    round(
      return.level(fevd(
        seas_max, 
        ext_data(
          show_select(input$shows_ext), input$comp_ext)),
        return.period=input$n)[[1]],
      3)
    
  })
  
  output$ci <- renderText({
    
    ci = return.level(fevd(
      seas_max, 
      ext_data(
        show_select(input$shows_ext), input$comp_ext)),
      return.period=input$n, do.ci=TRUE)
    
    return(c("(", round(ci[[1]], 3), ", ", round(ci[[3]], 3), " )"))
  })
  
  output$density_plot <- renderPlot({
    
    plot(fevd(
      seas_max, 
      ext_data(
        show_select(input$shows_ext), input$comp_ext)),
      type="density", main="Fitted GEV Density Plot", xlab="Maximum Increase"
      )
    
  })
  
  output$view_plot <- renderPlot({
    
    ts_shows %>% filter(show==input$shows_view) %>%
      ggplot(aes(x=ep_num_show)) +
      geom_step(aes(y=viewers), color="blue") +
      xlab("Epsiode Number (cumulative)") +
      ylab("Viewers (millions)")
    
  })
  
  output$view_top_5 <- renderTable({
    
    data.frame(
      ts_shows %>% filter(show==input$shows_view) %>%
        slice_max(viewers, n=5) %>%
        select("Season"=seas, 
               "Episode"=ep_num_seas, 
               "Title"=title, 
               "Date"=air_date, 
               "Viewers (mil)"=viewers) %>%
        transform(Season=as.integer(Season),
                  Episode=as.integer(Episode),
                  Date=as.character(Date)),
    check.names = FALSE)
  })
  
  output$inc_plot <- renderPlot({
    
    ts_shows %>% filter(show==input$shows_inc) %>%
      ggplot(aes(x=ep_num_show)) +
      geom_line(aes(y=.data[[paste0("return_", input$comp_inc)]]), color="green") +
      xlab("Epsiode Number (cumulative)") +
      ylab("Increase")
    
  })
  
  output$inc_top_5 <- renderTable({
    
    data.frame(
      ts_shows %>% filter(show==input$shows_inc) %>%
        slice_max(.data[[paste0("return_", input$comp_inc)]], n=5) %>%
        select("Season"=seas, 
               "Episode"=ep_num_seas, 
               "Title"=title, 
               "Date"=air_date, 
               "Increase"=.data[[paste0("return_", input$comp_inc)]]) %>%
        transform(Season=as.integer(Season),
                  Episode=as.integer(Episode),
                  Date=as.character(Date))
    )
  })
  
  output$view_desc <- renderTable({
    
    stats = stat.desc(
      ts_shows %>% 
        filter(show==input$shows_view) %>%
        select(viewers)
    )
    
    return(data.frame(Statistic=row.names(stats), Value=stats$viewers))
  })
  
  output$inc_desc <- renderTable({
    
    stats = stat.desc(
      ts_shows %>% 
        filter(show==input$shows_inc) %>%
        select(incs=.data[[paste0("return_", input$comp_inc)]])
    )
    
    return(data.frame(Statistic=row.names(stats), 
                      Value=stats$incs))
  })
  
}

