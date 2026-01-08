# **__NBA Statistical Analysis Projects__**

This repository contains a collection of NBA analytics projects that explore how player performance, positional roles, and league-wide trends have evolved from the league’s early years to the modern era. These projects emphasize statistical rigor, clear visualization, and interpretable modeling, using both Python and R to answer basketball-driven questions with data.

The goal of this repository is twofold:
1) To apply formal statistical methods to real-world sports data
2) To translate complex results into insights that basketball fans and analysts can understand

## __Repository Structure__
### __1. NBA Dataset Analysis.ipynb__

A Python-based exploratory data analysis project built on a large, multi-table NBA dataset sourced from Kaggle. This notebook focuses on data inspection, cleaning, merging, and exploratory visualization to understand player scoring behavior, efficiency, and team-level trends.

__Dataset Scope:__
- Games: 26,000+ NBA games (2003–2022)
- Game details: 660,000+ player-game stat lines
- Supporting tables: players, teams, and standings

__Key Objectives:__
- Understand the structure and limitations of raw NBA data
- Build a clean, merged dataset suitable for player-level and team-level analysis
- Explore scoring distributions, player efficiency, and home-court advantage

__Key Analyses & Features:__
- Comprehensive Data Inspection
  - Automated inspection function to review shape, data types, missing values, and summary statistics
  - Used as a reference tool throughout the project for plotting and modeling
- Data Cleaning & Preparation
  - Filled missing stat values (FGM, FGA, PTS, etc.) with zeros where appropriate
  - Dropped irrelevant or high-null columns (e.g., COMMENT)
  - Verified duplicate rows across all datasets
  - Standardized date formats and column naming
- Dataset Merging
  - Merged player box-score data with player metadata and game-level information
  - Integrated team metadata for both home and away teams
  - Produced a unified player–game dataset for downstream analysis
- Scoring Distribution Analysis
  - Histogram analysis of points scored per game
  - Identified clear scoring tiers: end-of-bench players, role players, secondary options, and superstars
- Custom Player Efficiency Metric
  - Constructed a PER-style efficiency score using box-score statistics
  - Ranked top 10 players by average efficiency for the 2020 season
  - Results aligned closely with real-world elite players (e.g., Jokic, Giannis, Luka)
- Home Court Advantage Analysis
  - Calculated league-wide home win percentage (~58.7%)
  - Tracked home-court advantage by season
  - Observed a clear dip during the 2019–2020 COVID season and gradual recovery afterward
- Data Export
  - Final merged dataset exported as a CSV for future modeling and analysis

### **2. NBA Player Analysis.pdf + NBA Player Analysis.R**

A comprehensive, research-style project analyzing NBA player evolution, positional differences, and MVP-level performance using advanced statistical techniques in R. The PDF contains the full written analysis and interpretation, while the R script contains all data cleaning, transformation, modeling, and visualization code.

__Project Overview__
This project uses player per-game statistics from 1947–2024 to study how NBA performance has evolved across eras and positions. The analysis emphasizes statistical validity, interpretability, and historical context.

__Core Components of the R Analysis:__
- Data Cleaning & Feature Engineering
  - Standardized column naming and data types
  - Created decade-based groupings to enable era comparisons
  - Simplified player positions into Guard, Forward, and Center
- Decade-Level Trend Analysis
  - Tracked league-wide changes in PPG, RPG, APG, SPG, and BPG
  - Visualized how rule changes and play style shifts impacted statistical output
- Position-Based Analysis
  - Compared scoring, rebounding, and playmaking trends across positions
  - Demonstrated increasing role overlap and versatility over time
- Scoring Inequality (Gini Coefficient)
  - Measured how evenly scoring is distributed across players each season
  - Identified historical peaks (e.g., Wilt Chamberlain era) and modern declines due to team-oriented offenses
- Outlier Season Detection
  - Used combined Z-scores of points, rebounds, and assists
  - Highlighted historically dominant seasons (e.g., Wilt Chamberlain, Oscar Robertson, Russell Westbrook)
- Career Longevity Modeling
  - Built a multiple linear regression model to predict career length
  - Found that all-around contributors tend to have longer NBA careers
- Statistical Testing by Position
  - Applied ANOVA to test whether player stats differ significantly by position
  - Used Tukey HSD post-hoc tests to identify where differences occur
- MVP Finalist Prediction
  - Fit a logistic regression model using per-game stats and minutes played
  - Successfully identified statistically MVP-caliber profiles for the 2024 season

This project bridges basketball intuition with formal statistical modeling, demonstrating how traditional box-score data can be used to explain historical trends and predict elite performance.

### __Dataset Information__

- Source: Kaggle (historical NBA per-game player statistics)
  - Coverage: 1947–2024 seasons

__Data Cleaning & Preprocessing:__
- Removed players with insufficient games played per season
- Excluded irregular seasons (e.g., 2020 COVID-shortened season)
- Simplified positions into Guard, Forward, and Center
- Filtered extreme low-impact seasons to focus on meaningful contributors
