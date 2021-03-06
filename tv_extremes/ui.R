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
           tabPanel("Viewers",
                    fluidPage(
                      fluidRow(
                        column(8, 
                               tabsetPanel(type = "tabs",
                                           tabPanel("Plot", plotOutput(outputId ="view_plot")),
                                           tabPanel("Descriptive", tableOutput(outputId="view_desc")),
                                           tabPanel("Top 5", tableOutput(outputId="view_top_5"))
                               )),
                        column(4, radioButtons(
                          inputId="shows_view",
                          label="Select your show(s):", 
                          selected="Friends",
                          choices = show_names))
                      )
                    )),
           tabPanel("Increases",
                    fluidPage(
                      fluidRow(
                        column(8, 
                               tabsetPanel(type = "tabs",
                                           tabPanel("Plot", plotOutput(outputId ="inc_plot")),
                                           tabPanel("Descriptive", tableOutput(outputId="inc_desc")),
                                           tabPanel("Top 5", tableOutput(outputId="inc_top_5"))
                               ),
                               p(class="text-info", "See the blue text under tab ", em("Maxima"), "for an 
                                 explanation of ", em("increase"), "and the use of ", em("episodes for comparison."))),
                        column(4, radioButtons(
                          inputId="shows_inc",
                          label="Select your show(s):", 
                          selected="Friends",
                          choices = show_names), 
                          radioButtons(
                            inputId="comp_inc",
                            label="Episodes for comparison:", 
                            selected="3",
                            choices = c(1, 3, 5)))
                      )
                    )),
           tabPanel("Maxima",
                    fluidPage(
                      sidebarLayout(position = "right", 
                                    sidebarPanel(
                                      radioButtons(
                                        inputId="shows_max",
                                        label="Select your show(s):", 
                                        selected="All",
                                        choices = c("All", "Sitcoms", "Dramas", 
                                                    show_names)),
                                      radioButtons(
                                        inputId="comp_max",
                                        label="Episodes for comparison:", 
                                        selected="3",
                                        choices = c(1, 3, 5))),
                                    mainPanel(
                                      plotOutput(outputId ="block_max_plot"),
                                      p(class="text-primary", "The above graph shows the maximum increase in number of viewers 
                                        for each season. When multiple shows are selected a ", em("season"), "is a period of time beginning 
                                        in August of one year and ending in July of the next. The maximum is taken over all episodes in a season. 
                                        The definition of ", em("increase"), "depends on the number selected under ", em("episodes for comparison"), 
                                        "on the right: it is the proportion of either the previous episode's viewers (1), the average of 
                                        the previous three episodes' viewers (3), or the average of the previous five episodes' viewers (5)."
                                      )
                                    )
                      )
                    )
           ),
           tabPanel("Extremes", 
                    fluidPage(
                      fluidRow(
                        column(4, div(class="card border-success mb-3", style="max-width: 20rem;",
                                      div(class="card-body",
                                          p(class="card-text", "Choose an integer ", em("n"), ". The estimate returned is the maximum 
                                                increase you can expect to see in a run of ", em("n"), "seasons. Here, ", em("increase"), 
                                            " has the same meaning as under the ", em("Maxima"), "tab. Alternatively, you can consider 
                                                  ", em("1/n"), "to be the probability of an increase of this magnitude in a given season.", 
                                            em("Example: with n = 4, an estimate of 0.9 means that over a run of four seasons you would
                                                  expect to see a jump in viewers of 90% no more than once."))
                                      ) 
                        ), div(class="card border-primary mb-3", style="max-width: 20rem;",
                               div(class="card-body",
                                   p(class="card-text", "We use a block maxima approach to fit a generalized extreme 
                                                         value (GEV) distribution to our data. This is done using the R package ", em("extRemes"), ". 
                                                         A block is a season. Consequently, the data being fitted corresponds exactly to 
                                                         that in the plots under tab ", em("Maxima"), ". The selection made in ", 
                                     em("episodes for comparison"), "on the right plays the same role as it does in that tab.")
                               )
                        )),
                        column(5, tags$table(class="table table-hover",
                                             tags$tbody(
                                               tags$tr(class="table-success", 
                                                       tags$td("Choose ", em("n"), ":"), 
                                                       tags$td(numericInput(inputId="n", label=NULL, 2,
                                                                            2, 100, 1, width=100))
                                               ),
                                               tags$tr(class="table-success", 
                                                       tags$td("Estimate:"), 
                                                       tags$td(textOutput(outputId="est"))
                                               ),
                                               tags$tr(class="table-success", 
                                                       tags$td("95% confidence interval:"), 
                                                       tags$td(textOutput(outputId="ci"))
                                               )
                                             )
                        ),
                        plotOutput(outputId ="density_plot")
                        ),
                        column(3, radioButtons(
                          inputId="shows_ext",
                          label="Select your show(s):", 
                          selected="All",
                          choices = c("All", "Sitcoms", "Dramas", 
                                      show_names)),
                          radioButtons(
                            inputId="comp_ext",
                            label="Episodes for comparison:", 
                            selected="3",
                            choices = c(1, 3, 5)))
                      )
                    )
           )
)


