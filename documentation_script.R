
# Documentation Script For Blogdown --------------------------------------------
library(blogdown)
setwd("C:\\Users\\GabzPC\\Documents\\blogdown_source")


# 1. Post 1 - Hands on R --------------------------------------------------
# new_post(title = "tester1", ext = ".Rmd")


# 2. Post 2 - ggplot and ggplotly -----------------------------------------
new_post(title = "ggplot_and_ggplotly", ext = ".Rmd")


# Final Compilation -------------------------------------------------------

build_site()
serve_site()
