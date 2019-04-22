Group Project - Milestone 1 README
===

# Know Your Flow

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Know Your Flow is an app that helps women track their periods by letting them input their personal information and then predicting the next potential period.
### App Evaluation
- **Category:** Health and Fitness
- **Mobile:** This app would be developed for mobile with the potential of being functional as a web application as a way to set us apart from competitors.  
- **Story:** Track and predict users' menstrual cycle information.
- **Market:** Female health and fitness market.
- **Habit:** This app could be used either daily or only when the user's menstrual cycle begins and ends, since this would be the period of time that would help them understand their flows the most. 
- **Scope:** First, we would start with predicting the menstrual cycles based on the first 3 months of data if possible. Then, the app could evolve by including a way to log the level of flow and the moods experienced by the user as a way to give more insight into commonalities across cycles. There is some potential for use with companies such as Fitbit, MyFitnessPal, or other fitness-related applications that track daily health. 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* The user will be able to log in.
* The user will be able to log out.
* The user will be able input their period start and end dates.
* The user will be able to edit their inputted period start and end dates.
* The user will be able to see how many days until their next period.
* The user will be able to see their personal predicted period start and end dates on a calendar. 
* The user will be able to see their personal predicted fertility start and end dates.
*  The user will be able to check their previous history of periods.

**Optional Nice-to-have Stories**

* The user will be able to customize how heavy their flow is.
* The user will be able to input their mood for each day.
* The user will be able to share their information with another user. 
* The user will be able to see chart analysis of their period flow (weight fluctuation, cycle length, symptoms, mood)
* The user will be able to sync their Apple Health or Fitbit data with the app.
* The user will be able to use passcode protection to prevent prying eyes
* The user will be able to set timely reminders to take their prescription, log their cycle, drink water, etc ... 

### 2. Screen Archetypes
* Login
    * Upon Download/Reopening of the application, the user is prompted to log in to gain access to the app features.
* Register
   * Allows user to create a new account.
* Home Screen
   * Allow user to view summary of history.
   * Allow user to enter Log Screen to enter more information.
* Log Screen
    * Allow user to select a date as period start/end date and save this new entry.
* Calendar Screen
    * Allow user to visualize the history and app prediction.
    *  Allow user to enter Log Screen to enter/edit information.
* History Screen
    * List information of last menstrual cycle.
    * List last log activity
* Preference Screen
    * Allow user to edit basic information.
    * Allow user to set homescreen.
    * Allow user to signout.

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* History
* Projected Menstruation/Log
* Calendar
* User Preferences/Settings

**Flow Navigation** (Screen to Screen)

* Forced Login Screen -> Create account if no login available
   * Sign up if user doesn't have an account
   * Otherwise, login success => Home Screen
* Registration Screen
   * => Login Screen
* Edit/Add Cycle Screen
    * => Calendar Screen
* User Preferences/Settings
    * => Login Screen (if user signs out)

## Wireframes
<img src="https://i.imgur.com/4Kr4YL1.jpg" width=600>

### [BONUS] Digital Wireframes & Mockups
<img src="https://drive.google.com/file/d/1kjz0DKtQQ3pZDn02qbMfjvDMVK_oB8NX/view?usp=sharing" width=800>
### [BONUS] Interactive Prototype
<img src='http://g.recordit.co/AHQqBW2waO.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
