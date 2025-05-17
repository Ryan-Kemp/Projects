# Install packages if not already installed
# install.packages("readxl", type = "binary")
# install.packages("GGally")

# Load libraries
library(tidyverse)
library(ggplot2)
library(lubridate)
library(GGally)
library(broom)
library(readxl)

# Set working directory (adjust path if needed)
# setwd("~/Desktop")

# Read in the Excel file, skipping the first row if it's not the real header
nba <- read_excel("C:/Users/rkemp/Downloads/Copy of Player_Per_Game_Filtered.xlsx", skip = 1)

# Clean column names
names(nba) <- str_trim(names(nba))        # remove leading/trailing spaces
names(nba) <- tolower(names(nba))         # convert to lowercase for consistency

# Check if 'season' column exists (optional debug)
# print(colnames(nba))

# Create a decade column
nba$decade <- floor(nba$season / 10) * 10

# Group by decade and summarize key stats
stat_trends <- nba %>%
  group_by(decade) %>%
  summarize(
    PPG = mean(pts_per_game, na.rm = TRUE),
    RPG = mean(trb_per_game, na.rm = TRUE),
    APG = mean(ast_per_game, na.rm = TRUE),
    SPG = mean(stl_per_game, na.rm = TRUE),
    BPG = mean(blk_per_game, na.rm = TRUE),
    .groups = "drop"
  )

# Convert to long format for plotting
stat_trends_long <- stat_trends %>%
  pivot_longer(cols = -decade, names_to = "Stat", values_to = "Value")

# Plot stat trends over decades
ggplot(stat_trends_long, aes(x = decade, y = Value, color = Stat)) +
  geom_line(size = 1.2) +
  labs(
    title = "Evolution of Key Player Stats by Decade",
    x = "Decade", y = "Average per Game"
  ) +
  theme_minimal()


# --------------------------------------------------
# Create a simplified position column from the first listed position
nba <- nba %>%
  mutate(
    primary_pos = case_when(
      str_detect(pos, "G") ~ "Guard",
      str_detect(pos, "F") ~ "Forward",
      str_detect(pos, "C") ~ "Center",
      TRUE ~ NA_character_
    )
  )

# DEBUG: Check unique values in pos and primary_pos
print("Unique positions in 'pos':")
print(unique(nba$pos))

print("Unique simplified positions in 'primary_pos':")
print(unique(nba$primary_pos))

# Filter for valid data
nba_filtered <- nba %>%
  filter(!is.na(season), !is.na(primary_pos), !is.na(pts_per_game), !is.na(ast_per_game), !is.na(trb_per_game))

# Recalculate the decade (in case season wasn't numeric earlier)
nba_filtered <- nba_filtered %>%
  mutate(decade = floor(as.numeric(season) / 10) * 10)

# DEBUG: Check if any data remains
print("Filtered data sample:")
print(head(nba_filtered))

# Summarize average stats by decade and position
position_trends <- nba_filtered %>%
  group_by(decade, primary_pos) %>%
  summarize(
    PPG = mean(pts_per_game, na.rm = TRUE),
    RPG = mean(trb_per_game, na.rm = TRUE),
    APG = mean(ast_per_game, na.rm = TRUE),
    .groups = "drop"
  )

# DEBUG: Check summary output
print("Position trends summary:")
print(position_trends)

# Pivot longer for plotting
position_trends_long <- position_trends %>%
  pivot_longer(cols = c(PPG, RPG, APG), names_to = "Stat", values_to = "Value")

# Plot
ggplot(position_trends_long, aes(x = decade, y = Value, color = primary_pos)) +
  geom_line(size = 1.2) +
  facet_wrap(~ Stat, scales = "free_y") +
  labs(
    title = "Stat Trends by Simplified Position (Guard, Forward, Center)",
    x = "Decade", y = "Average per Game",
    color = "Position"
  ) +
  theme_minimal(base_size = 14)

#----------------------------------------------------------
# install.packages("ineq")     # run once
library(ineq)

# Calculate Gini coefficient of points per game by season
gini_trend <- nba %>%
  group_by(season) %>%
  summarize(gini_ppg = ineq(pts_per_game, type = "Gini", na.rm = TRUE))

# Plot the Gini coefficient over time
ggplot(gini_trend, aes(x = season, y = gini_ppg)) +
  geom_line(color = "firebrick", size = 1.2) +
  labs(
    title = "Scoring Inequality Over Time (Gini Coefficient)",
    x = "Season",
    y = "Gini Coefficient"
  ) +
  theme_minimal()

#------------------------------------------------------------------
# Create z-scores for key stats
# Create a combined z-score average of Points, Rebounds, and Assists
nba_outliers <- nba_outliers %>%
  mutate(
    z_combined = (z_ppg + z_rpg + z_apg) / 3
  )

# Identify outlier seasons based on combined stat
top_players_combined <- nba_outliers %>%
  filter(z_combined > 2.575) %>%
  select(player, season, pts_per_game, trb_per_game, ast_per_game, z_combined) %>%
  arrange(desc(z_combined))

print(top_players_combined)


ggplot(top_players_combined, aes(x = season, y = z_combined, label = player)) +
  geom_point(color = "#0072B2", size = 3) +
  geom_text(hjust = 1.1, size = 3, check_overlap = TRUE) +
  labs(
    title = "Top Outlier Seasons by Combined Z-Score (Points, Rebounds, Assists)",
    x = "Season",
    y = "Combined Z-Score (PPG, RPG, APG)"
  ) +
  scale_x_continuous(limits = c(1950, NA)) +  # Set the lower limit to 1940
  theme_minimal()


#------------------------------------------------------------------
# Summarize each player's career
# install.packages("repel")     # run once
# Summarize each player's career
career_data <- nba %>%
  group_by(player) %>%
  summarize(
    career_length = n(),  # number of seasons
    avg_ppg = mean(pts_per_game, na.rm = TRUE),
    avg_rpg = mean(trb_per_game, na.rm = TRUE),
    avg_apg = mean(ast_per_game, na.rm = TRUE),
    .groups = "drop"
  )

# Add predictions to data
career_data$predicted_length <- predict(career_model)

# Plot: actual vs predicted
ggplot(career_data, aes(x = predicted_length, y = career_length)) +
  geom_point(alpha = 0.6, color = "#1f77b4") +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "firebrick") +
  labs(
    title = "Actual vs Predicted Career Length",
    subtitle = "Based on PPG, RPG, and APG",
    x = "Predicted Career Length (Seasons)",
    y = "Actual Career Length (Seasons)"
  ) +
  theme_minimal()

# Fit multiple regression model
career_model <- lm(career_length ~ avg_ppg + avg_rpg + avg_apg, data = career_data)
summary(career_model)

  #----------------------------------------------------
  # Simplify positions again (if needed)
  
  # Create a simplified position variable
  nba_anova <- nba %>%
    mutate(primary_pos = case_when(
      str_detect(pos, "G") ~ "Guard",
      str_detect(pos, "F") ~ "Forward",
      str_detect(pos, "C") ~ "Center",
      TRUE ~ NA_character_
    )) %>%
    filter(!is.na(primary_pos))  # Drop NAs in position
  
  # Define a function to run ANOVA for any stat
  run_anova <- function(stat) {
    formula <- as.formula(paste(stat, "~ primary_pos"))
    result <- aov(formula, data = nba_anova)
    print(paste("ANOVA for", stat))
    print(summary(result))
    cat("\n")
    return(result)
  }
  
  # Run ANOVA for each stat
  aov_ppg <- run_anova("pts_per_game")
  aov_apg <- run_anova("ast_per_game")
  aov_rpg <- run_anova("trb_per_game")
  aov_spg <- run_anova("stl_per_game")
  aov_bpg <- run_anova("blk_per_game")
  
  # Post-hoc comparisons
  TukeyHSD(aov_ppg)
  TukeyHSD(aov_apg)
  TukeyHSD(aov_rpg)
  TukeyHSD(aov_spg)
  TukeyHSD(aov_bpg)
  
  plot_stat_by_pos <- function(stat, y_label) {
    ggplot(nba_anova, aes(x = primary_pos, y = .data[[stat]], fill = primary_pos)) +
      geom_boxplot() +
      labs(
        title = paste("Distribution of", y_label, "by Position"),
        x = "Position",
        y = y_label
      ) +
      theme_minimal()
  }
  
  # Example:
  plot_stat_by_pos("pts_per_game", "Points Per Game")
  plot_stat_by_pos("ast_per_game", "Assists Per Game")
  plot_stat_by_pos("trb_per_game", "Rebounds Per Game")
  plot_stat_by_pos("stl_per_game", "Steals Per Game")
  plot_stat_by_pos("blk_per_game", "Blocks Per Game")
  
  
  #---------------------------------------------------------

  

