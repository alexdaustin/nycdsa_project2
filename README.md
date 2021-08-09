# nycdsa_project2
Initial title 'Time series analysis of hit TV show audience numbers.'
Current title 'The One with the Data: An Extreme Value Analysis of Hit TV Show
Viewer Numbers.'

Author: Alex Austin
Data Science and Machine Learning Bootcamp, July 2021
NYC Data Science Academy
Submitted in fulfillment of the R Data Analysis Project.

At time of submission, in addition to this Readme and a .gitignore, the GitHub
repository should hold
(1) preproc.R, used to clean and process the data,
(2) extRemes_tutorial.pdf, a tutorial for the extRemes package (written by other
authors), and
(3) tv_extremes, a folder containing the constituent parts of a Shiny app.
To be precise, the contents of the tv_extremes folder are
(3a) global.R,
(3b) server.R,
(3c) ui.R, and
(3d) www, another folder that contains a single image file tv_friends.jpg.
The Shiny app depends on a csv file ts_shows.csv that is not contained in the
repository.

The viewers data was sourced from Wikipedia. In particular, we used shows taken
from https://en.wikipedia.org/wiki/Top-rated_United_States_television_programs_by_season
according to the following rules. A qualifying show is one that is fictional and
for adults. Examples of shows that are extremely popular but non-qualifying are
Barney & Friends, 60 Minutes, Survivor, and Sunday Night Football. For each table
listing shows from the 1990s and onwards we picked shows according to the
following rules:
(i) any qualifying show from the top three rated programs, but
(ii) if there is no qualifying show in the top three, then the single highest
rated qualifying show.
This resulted in the following list of shows: Cheers, CIS, Desperate Housewives,
ER, Frasier, Friends, Home Improvement, NCIS, Roseanne, Seinfeld, and The Big Bang
Theory. There were three shows that should have been included but were not because
ultimately we could not find enough viewer data, they were: Veronica's Closet,
Suddenly Susan, and Murphy Brown.

For each included show, we clicked on the appropriate link from the above Wikipedia
page, then typically needed to navigate to a further page that listed all episodes
of that show. For our sample, the viewer numbers looked to have been recorded in a
consistent way, typically with a citation to the Nielsen ratings published in say,
USA Today. The required data was in tabular form and rather than scrape, we simply
copy pasted these into Excel. The pasted tables were of a regular enough form that the
data could be neatly tabulated using vertical lookups, the cumulative episode number
serving as a unique identifier for the episodes within each show. From there, a csv
file for each show was read into R where further cleaning and processing took place.

Several of the shows deserve further comment:

Cheers: Only viewers data from season 9 onward was listed in a way consistent with the
other shows. Consequently, the Cheers data is incomplete.
Home Improvement: For some reason viewers data from the last season (season 8) was not
available, consequently the Home Improvement data is incomplete. Furthermore, viewer
numbers for seasons 3 and onwards appeared without the usual citation to Nielsen ratings.
We judge the Home Improvement data to be less reliable than the others.
Roseanne: The reboot seasons that began in 2018 were deliberately not included in our
analysis. You could consider the Roseanne data incomplete.

Of the shows and seasons we attempted to include, a list of missing values is available
from the preproc.R file. There were eight in total.

More details on the manner of the analysis can be found within the Shiny app.
