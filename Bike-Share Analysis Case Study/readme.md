# Bike-Share Analysis Case Study

## Intro
This is a fictitious bike-share analysis case study that I will use to learn how to properly set up my portfolios and showcase my learning. I'll be documenting the following data analysis process: **Ask, Prepare, Process, Analyze, Share, and Act**.

## Scenario
As a junior data analyst at Cyclistic, a Chicago bike-share company, your team aims to maximize annual memberships by understanding the distinct usage patterns of casual riders versus annual members. These insights will inform a marketing strategy to convert casual riders into annual members, requiring compelling data and professional visualizations for executive approval.

## Stakeholders

- **Cyclistic**: A bike-share program with over 5,800 bikes and 600 docking stations, offering traditional, reclining, hand tricycles, and cargo bikes for inclusivity. Most riders prefer traditional bikes, with approximately 30% using them for commuting.
- **Lily Moreno**: Director of marketing, responsible for developing promotional campaigns across various channels.
- **Cyclistic Marketing Analytics Team**: A group of data analysts focused on data collection and analysis to inform marketing strategies. You joined this team six months ago to support Cyclistic's mission and goals as a junior data analyst.
- **Cyclistic Executive Team**: The detail-oriented team that will decide on the approval of the proposed marketing program.

## About the Fictitious Company
In 2016, Cyclistic launched a successful bike-share program, now featuring 5,824 geotracked bikes across 692 Chicago stations. The bikes can be unlocked at one station and returned at any other. Previously, Cyclistic's marketing focused on general awareness and a broad audience through flexible pricing: single-ride passes for casual riders and annual memberships for Cyclistic members. Finance analysts determine that annual members are significantly more profitable. To drive growth, Moreno aims to convert casual riders into annual members, leveraging their existing awareness of Cyclistic. Her goal is to design targeted marketing strategies after analyzing historical bike trip data to understand the differences between members and casual riders, their motivations for membership, and the potential impact of digital media.

---

## Ask
I will be looking into producing a report with the following deliverables:

- A clear statement of the business task
- A description of all data sources used
- Documentation of any cleaning or manipulation of data
- A summary of your analysis
- Supporting visualizations and key findings
- Your top three recommendations based on your analysis

## Problem Statement
Cyclistic wants to grow its business, but needs money to do so. They know that annual memberships are much more profitable. So, what can they do to raise the number of annual memberships?

### Key Questions:
- How do annual members and casual riders use Cyclistic bikes differently?
- Why would casual riders buy Cyclistic annual memberships?
- How can Cyclistic use digital media to influence casual riders to become members?

For this project, as a fresh data analyst, I will be answering the **first question**:

### **How do annual members and casual riders use Cyclistic bikes differently?**

---

## Business Task
Considering my previous reflection, I shall help the company's marketing team, that I identified as a key stakeholder, by doing the following task:

- Use the company's past year trip data to identify cyclist insights and trends for the marketing team.

---

## Prepare

### Data Information
The data selected for this case study is the past year's trip data from a bike-share company called **Divvy**. The files were manually extracted from Divvy's AWS and then stored onto Kaggle Dataset Repository as **2024 Divvy Trip Data**.

This dataset comprises twelve CSV files that correspond to each month of the year 2024. Each file contains thirteen identical columns, including attributes such as biker type, trip start and end times, and station information, which provide sufficient data for analyzing and comparing bike usage between casual riders and subscription members.

### Bias and Credibility
This section will evaluate five criteria to determine the data's suitability: **Reliability, Originality, Currency, Proper Citation**, and **Comprehensiveness**.

- **Reliability and Originality**: The data is directly sourced from the bikeshare service. It is safe to assume that the data is both reliable and original, as it is not obtained from a third party.
- **Currency**: The data is current, as our analysis is based on last year's trip data.
- **Proper Citation**: The dataset is appropriately cited, includes its own licensing, and is publicly available.
- **Comprehensiveness**: It could be beneficial to gather data on demographic factors and weather conditions to facilitate the comparison of various trends. However, the data collection methodology is restricted to acquiring a bicycle from designated stations.
- **Bias**: The dataset is exclusively derived from the bike-sharing service in Chicago, which may not accurately reflect the overall transportation usage patterns of the population.

### License, Privacy, Security, and Accessibility
The data originates from **Lyft Bikes and Scooters, LLC** (“Bikeshare”), which operates the Divvy bicycle-sharing service in Chicago. Both Bikeshare and the City of Chicago advocate for bicycling as a viable alternative transportation option. The City has authorized Bikeshare to publicly disseminate specific Divvy system data in accordance with the Data License Agreement.

The Data License Agreement grants a non-exclusive, royalty-free, perpetual license to access, reproduce, analyze, copy, modify, distribute in a product and use the data for any lawful purpose. [Click here for all the details](https://www.lyft.com/bike-and-scooter).

