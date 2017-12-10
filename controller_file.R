
# Controller File ---------------------------------------------------------
library(ggthemes)
library(reshape2)
library(ggplot2)
library(dplyr)
library(data.table)
library(plotly)
options(scipen = 999)
premium_tank_list <- c("T-54 mod.1", "T26E5", "FV4202", "T34", "Cromwell B", "T25 Pilot 1", "WZ-120-1G", "Strv S1")


### Loading and Cleaning the data 

df <- read.csv("Z:\\Analytics Work\\Side Projects\\World of Tanks\\raw_data.csv")

names(df)[1] <- "date"
df$credits[is.na(df$credits)] <- 0
df$date <- as.Date(df$date, format = "%d/%m/%Y")
df <- df %>% filter(!is.na(experience_earned))
df$survived <- as.numeric(df$survived)
df$tank_type <- as.character(df$tank_type)
df <- as.data.frame(df)
df <- df %>% 
  mutate(damage_blocked = as.numeric(damage_blocked),
         damage_spotting = as.numeric(damage_spotting),
         damage_blocked = as.numeric(damage_blocked),
         credits = as.numeric(credits),
         tier = as.numeric(tier))
df$tank_type <- factor(df$tank_type, levels = c("heavy","medium","light","tank destroyer","SPG"), labels = c("Heavy", "Medium", "Light", "Tank Destroyer", "SPG"))



# 1. Including number of sessions -----------------------------------------
## These are the individual days I have played. 

df <- df %>% 
  select(date) %>% 
  group_by(date) %>% 
  mutate(session = length(unique(date))) %>% 
  distinct(.) %>% 
  ungroup() %>% 
  mutate(session = cumsum(session)) %>% 
  inner_join(., df, by = c("date"))


# 2. Getting game number per session -----------------------------


df <- df %>% 
  select(date) %>% 
  group_by(date) %>% 
  mutate(game_number = length(unique(date))) %>% 
  group_by(date) %>% 
  mutate(game_number = cumsum(game_number)) %>% 
  select(game_number) %>% 
  bind_cols(df) %>% 
  select(-date1) %>% 
  as.data.frame() 


write.csv(df, "C:\\Users\\GabzPC\\Documents\\blogdown_source\\public\\2017\\12\\data_files\\raw_data.csv")

# 3. Win Rate data frame and Graph -------------------------------------------------------

win_rate <- df %>% 
  group_by(session) %>%
  summarise(games_played = length(game_number),
            win_rate = round(length(game_number[outcome == "win"]) / length(game_number)*100,2)) %>% 
  melt(id.vars = 1)

win_rate$variable <- factor(win_rate$variable, levels = c("games_played", "win_rate"), 
                            labels = c("Games Played", "Win Rate (%)"))

P1 <- ggplot(win_rate, aes(session, value,  fill=variable))+
  geom_bar(stat = "identity", position = "dodge")+
  scale_fill_tableau(palette = "tableau10")+
  scale_x_continuous(name = "Session", breaks = 1:max(win_rate$session))+
  scale_y_continuous(name = "")+
  labs(title = "Win Rate Per Session")+
  theme(plot.title = element_text(hjust = 0.5))








