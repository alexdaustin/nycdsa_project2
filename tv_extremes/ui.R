navbarPage("The One with the Data", theme = bs_theme(bootswatch = "cyborg"),  
           tabPanel("Intro",
                    fluidPage(
                        sidebarLayout(position="right",
                                      sidebarPanel(
                                          div(class="card text-white bg-primary mb-3", style="max-width: 20rem;",
                                              div(class="card-body",
                                                  p(class="card-text", "The number of viewers of a TV show can suddenly increase from one week to 
                          the next. This may stretch the capacity of a provider and cause a deterioration in service. 
                          By looking at the past behavior of hit TV shows, we seek to understand what is the maximum 
                          increase we can reasonably expect. Our goal is accomplished using Extreme Value Theory. This provides
                          a statistical framework for modeling the tail of a distribution where observations may be scarce.")
                                              )
                                          ),
                                          div(class="card text-white bg-secondary mb-3", style="max-width: 20rem;",
                                              div(class="card-body",
                                                  p(class="card-text", "The TV shows contributing to our analysis are some of the most popular 
                          over the last thirty years:", em("The Big Bang Theory, NCIS, CIS, Desperate Housewives, Friends, ER, Frasier, 
                          Seinfeld, Home Improvement, Roseanne, and Cheers."))
                                              )
                                          ),
                                          p(class="text-info", "Viewers data sourced from Wikipedia.")
                                      ),
                                      mainPanel(h3("The One with the Data: An Extreme Value Analysis of TV Show Viewer Numbers"), 
                                                p(class="text-muted", "Alex Austin, NYC Data Science Academy"),
                                                img(src="tv_friends.jpg", width=550),
                                      )
                        )
                    )
           ),
           tabPanel("Explore"),
           tabPanel("Analyze"),
           tabPanel("Extremes",
                    fluidPage(
                        sidebarLayout(position = "right", 
                                      sidebarPanel(
                                          wellPanel(
                                              checkboxGroupInput(
                                                  "shows_ext",
                                                  "Select your show(s):",
                                                  choices = c("All", "Sitcoms", "Dramas", 
                                                              show_names)))),
                                      mainPanel(
                                          p("To be decided")
                                      )
                                      
                        )
                        
                    )
           )
)