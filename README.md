# Senior Thesis Project
# SubPar


## Introduction

### Purpose:
The purpose of this document is to illustrate the Use Cases as well as the Funtional and Non-Functional Requirements of SubPar. SubPar is an IOS Application designed to help a Golfer improve at his or her game while taking the work like keeping score and storing scorecards, as well as much more, off of the Golfer's hands so that they only need to worry about holding the club.

Some of the key goals of this Application are to:

- Assist Golfers with the simple "not fun" parts of golf like remembering, keeping, and calculating score, so that the Golfer only needs to worry about not hitting the trees and going in the drink. (we wish we could help you with your slice).

- Manage various Golfers's accounts, keeping log-in information secure, as well as seamless transitons between Golfers. Allowing multiple registered Golfer's individual games to be tracked from a single device.

- Assist Golfers with tips for which club they should use based on how they have shot in the past.

- Allow Golfers to reflect back on their proir games as well as track personal improvement.

### Scope:
This Application is intended for all Golfers to use as a "Pocket Caddy" to assist them with their game regardless of their experience. 

This Application will handle:

- Functionality to Sign-Up, Log-in, Delete, Sign-Out, And Reset Password for an Account.
- Upload Scorecard for Auto-Calculation.
- "Smart Caddy" club tips.
- Upload Single Stroke.
- Stroke Counter.
- View Golfer History.
### Definitions, Acronyms, and Abbreviations:
- **UC** - Use Case
- **FR** - Functional Requirements
- **NR** - Non-Functional Requirements
## Overview:        

### System Features:
1. **Secure Login**: Ensures that only authorized users have access to the System with authentication based on username, password, and a linked phone number or email address

2. **Scorecard Reading**: Upload a photo of your physical scorecard after the match. The handwriting on the scorecard will be read and auto-calculated.

3. **Stroke Counter**: Golfers are able to keep track of their stroke count for a single hole so that they never need to remember what stroke they are on.

4. **Maintain History**: Review past matches to see each stroke recorded during the match as well as the scorecard for the Golfer to reflect back on to track improvement. The history will also have a course filter so that the Golfer is able see all games for a specific course.

5. **Smart-Caddy**: Based on the history inputted by the Golfer the "Smart-Caddy" is a able to make recomendations based on how you have hit your clubs in the past.


## Use Cases:

### UC-1.1: Secure Sign-Up

#### Summary:
A User will be able to securely sign up for an Account.
#### Rationale:
Often times, a User will want to make an Account on an Application so that their information will be related to them. A User will want to have an Account for themselves where they can track their own personal improvement while keeping their personal information secure.
#### Users:
Any Client who wants a Golf Companion App
#### Preconditions:
1. Application must be installed, open, and on the Home screen.
#### Basic Course of Events:
1. The User will select the "Register New User" Button.
2. The Sign-Up screen is launched.
3. The Sign-Up screen promps the user for a username greater than 6 characters and a password greater than 8 characters containing at least one of each:
- Lowercase character
- Uppercase character
- Special character
- Number

Password must not contain any of the following:
- Comma - ,
- Period - .
- Space - " "

4. 2FA required with email or phone number.
5. Account details entered correctly and a new Account is registered unless an Account with the Username and Password already exists.
#### Alternitive Paths:
5. Account details entered incorrecly according to username/password requirements or a matching account already exists. An error is displayed and the Account requested will not be created.
#### Postconditions:
6. The Account is either registered in the system or the username and password will need to be changed to register the Account. (back to step 3).


### UC-1.2: Secure Log-in

#### Summary: 
A User will be able to log into an account after it has been registered for.

#### Rationale:
Once a User signs up for an account it is common for them to log out of their account from time to time. A User could be swapping devices or using someone elses. The login process should be secure and seamless to keep passwords hidden and make sure a User is able to log on regardless of the device they are using or account being logged into.
#### Users:
Any User with an Account
#### Preconditions:
1. **SubPar** must be insalled on an IOS device and on the Home screen
#### Basic Course of Events:
1. The user selects the "Returning User" Button and gets sent to the Log-in screen.
2. The user enters in a registered username
3. The user enters in the password for the registered username
4. The user selects the "Log-in" Button
#### Alternitive Paths:
**User Does Not Have An Account:**
5. The user will not have an Account to log into. An error is displayed. Registration required. Back to step 2.


**User Enters Incorrect Information:**
5. The User entered either an incorrect Username and/or Password. The User will not be logged in. Back to step 2.
#### Postconditions:
5. If the Username and Password are entered correctly matching a registered user the User will be logged in.
### UC-1.3: Secure Sign-Out
#### Summary:
A logged-in User is able to sign out of their account safely and securely.
#### Rationale:
Often times a logged-in User will want to sign-out of their Account and esure that their recent data will be saved in the system.
#### Users:
Any User with an Account
#### Preconditions:
1. **SubPar** is installed and opened.
2. A User logs into a registered account. The Main screen is displayed.
#### Basic Course of Events:
1. The User selects the "Sign-Out" Button. The "Sign-Out tab" opens.
2. The User selects the "Confirm Sign-Out" Button from the "Sign-Out tab".
#### Alternitive Paths:
2. The User selects the "Cancel" Button.
#### Postconditions:
**Successful**
If the "Confirm Sign-Out" Button is pressed then the logged-in User is signed out and returned to the Home screen.


**Unsuccessful**
If the "Cancel" Button is pressed then the "Sign-Out" tab is closed and the User is returned to the Main screen.

### UC-1.1: Secure Forgot-Password

#### Summary:
Allows a User to reset the password of their Account securely.
#### Rationale:
Unfortunately it is all too common to forget your password. There should be a way for a User to reset the password to their Account so that they dont lose access to the data they have been collection on their Game.
#### Users:
Any User.
#### Preconditions:
1. **SubPar** is installed and opened.
2. The "Returning User" Button is selected and the Log-in" screen is opened. 
#### Basic Course of Events:
1. The User selects the "Forgot-Password" Button and the "Forgot-Password" screen is opened.
2. The User enters in their Username and associated email or phone number.
3. The User selects the "Reset Password" Button.
4. The "Reset Password" screen is opened.
5. The User enters a new password and confirms the password.
6. The "Confirm" button is selected, if the password matches the requirements it will be updated as the new password for the user.
#### Alternitive Paths:
4. The email or phone number did not match an account with the inputted username
5. An error is displayed and User is taken back to the Home Screen
#### Postconditions:
**Successful**
The new Password will be saved for the user. The Home screen is displayed and the User is able to log in with their new password.

**Unsuccessful**
Either the User did not enter the correct username and email or password or the new password supplied was not sufficient. If the user needs to still change their password they will have to open the forgot password page again and input the correct information.

### Functional Requirements:

### Non-Functional Requirements:
### References: 
### TODO:
* Need to learn more about how the language works before i get more into the code

-  javascript - node

## Bugs:



