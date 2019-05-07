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

- [x] 1. The user will be able to log in.
http://g.recordit.co/X9pOtxjEUq.gif
- [ ] 2. The user will be able to log out.
- [x] 3. The user will be able input their start dates.
http://g.recordit.co/X9pOtxjEUq.gif
- [ ] 4. The user will be able to edit their inputted period start and end dates.
- [ ] 5. The user will be able to see how many days until their next period.
- [ ] 6. The user will be able to see their personal predicted period start and end dates on a calendar. 
- [ ] 7. The user will be able to see their personal predicted fertility start and end dates.
- [ ] 8. The user will be able to check their previous history of periods.
- [x] 9. The user will be able to create a new account.

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
<img src="https://i.imgur.com/SxiAixK.png">

### [BONUS] Interactive Prototype
<img src='http://g.recordit.co/AHQqBW2waO.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />


## Schema 


### Models

#### PeriodHistory

Property | Type | Description
------------ | ------------- |  -------------
objectId	| String	| unique id for the user post (default field)
author	| Pointer to User	|  user
startDate | DateTime| date user starts period 
endDate	| DateTime	| date user ends period
flowType	| String	| type of flow (heavy, medium, light)
createdAt	| DateTime	| date when new cycle is created (default field)
updatedAt	| DateTime	| date when new cycle is last updated (default field)


#### User
Property | Type | Description
------------ | ------------- |  -------------
objectId	| String	| unique id for the user post (default field)
createdAt | DateTime | date when user is created (default field)
updatedAt | DateTime | date when user is last updated(default field)
username | String | username
password | String | hidden password
email | String | email address
cycleAverage | Number | number of average days between cycles

### Networking
- List of network requests by screen 
* Login 
    * (Read/GET) Query all information where user is author  
        ```javascript
        let query = PFQuery(className:"PeriodHistory")
        query.whereKey("author", equalTo: currentUser)
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (periodHistory: [PFObject]?, error: Error?) in
           if let error = error { 
              print(error.localizedDescription)
           } else if let periodHistories = periodHistories {
              print("Successfully retrieved \(posts.count) posts.")
          // TODO: Do something with posts...
           }
        }
        ```
* Registration
    * (Create/POST) Create new user with username, password, email.  
        ```javascript
        PFObject *user = [PFObject objectWithClassName:@"User"];
        gameScore[@"username"] = @"l33t";
        gameScore[@"password"] = @"hideplease";
        gameScore[@"email"] = @"test@temp.com";
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
          if (succeeded) {
            // The object has been saved.
          } else {
            // There was a problem, check error.description
          }
        }];
        ```

* Home/Log
    *  (Read/GET) Get user's profile image, name, age, email, average days between cycle, and status.  
        ```javascript
        let query = PFQuery(className:"PeriodHistory")
        query.whereKey("author", equalTo: currentUser)
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (periodHistory: [PFObject]?, error: Error?) in
           if let error = error { 
              print(error.localizedDescription)
           } else if let periodHistories = periodHistories {
              print("Successfully retrieved \(posts.count) posts.")
          // TODO: Do something with posts...
           }
        }
        ``` 
* Calendar
    * (Read/GET) Query user's period and fertility dates on calendar.  
        ```javascript
        PFQuery *query = [PFQuery queryWithClassName:@"Period"];
        [query getObjectInBackgroundWithId:@"xWMyZ4YEGZ" block:^(PFObject *period, NSError *error) {
            // Do something with the returned PFObject in the period variable.
            NSLog(@"%@", period);
        }];
        ```     
    * (Update/PUT) Update user's period and fertility dates on calendar.

        ```javascript
        PFObject *period = [PFObject objectWithClassName:@"Period"];
        period[@"startDate"] = @"04-19-2019";
        period[@"endDate"] = @"04-26-2019";
        period[@"flowType"] = @"Heavy";
        [period saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
          if (succeeded) {
            // The object has been saved.
          } else {
            // There was a problem, check error.description
          }
        }];
        ```
* History
    * (Read/GET) Query user's period history. 
        ```javascript
        let query = PFQuery(className:"PeriodHistory")
        query.whereKey("author", equalTo: currentUser)
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (periodHistory: [PFObject]?, error: Error?) in
           if let error = error { 
              print(error.localizedDescription)
           } else if let periodHistories = periodHistories {
              print("Successfully retrieved \(posts.count) posts.")
          // TODO: Do something with posts...
           }
        }
        ``` 
* Preference
    * (Read/GET) Query logged in user object.
        ```javascript
        let query = PFQuery(className:"PeriodHistory")
        query.whereKey("author", equalTo: currentUser)
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (periodHistory: [PFObject]?, error: Error?) in
           if let error = error { 
              print(error.localizedDescription)
           } else if let periodHistories = periodHistories {
              print("Successfully retrieved \(posts.count) posts.")
          // TODO: Do something with posts...
           }
        }
        ``` 
    * (Update/PUT) User's information (profile image, name, age, date).
        ```javascript
        PFQuery *query = [PFQuery queryWithClassName:@"User"];

        // Retrieve the object by id
        [query getObjectInBackgroundWithId:@"xWMyZ4YEGZ"
                                     block:^(PFObject *user, NSError *error) {
            user[@"name"] = @"Edd";
            user[@"age"] = @15;
            user[@"date"] = @"04-01-1996"
            user[@"profileImage"] = @"test.png";
            [user saveInBackground];
        }];
        ```

- [OPTIONAL: List endpoints if using existing API such as Yelp]

* Build Progress Gifs
   * Week1
   <img src='http://g.recordit.co/X9pOtxjEUq.gif' title='Video Walkthrough' width='' alt='Week 1 Video Walkthrough' />

   
