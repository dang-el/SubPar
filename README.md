# Senior Thesis Project
# SubPar


## Introduction

### Purpose:
The purpose of this document is to illustrate the Funtional and Non-Functional Requirements of SubPar. SubPar is an IOS Application designed soley to help a Golfer improve at his or her game as well as taking the work of keeping score and storing scorecards off of the Golfer's hands, as well as much more, so that they only need to worry about holding the club.

Some of the key goals of this Application are:

- Assist Golfers with the simple "not fun" parts of golf like remembering, keeping, and calculating score, so that the Golfer only needs to worry about not hitting the trees and going in the drink. (we wish we could help you with your slice).

- Manage various Golfers's accounts, keeping log-in information secure, as well as seamless transitons between Golfers. Allowing multiple registered Golfer's individual games to be tracked from a single device.

- Assist Golfers with tips for which club they should use  based on how they have shot in the past.

- Allow Golfers to reflect back on their proir games as well as track personal improvement.

### Scope:
This Application is intended for all Golfers to use as a "Pocket Caddy" to assist them with their game regardless of Golfer experience. 

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
1. **Secure Login**: Ensures that only authorized users have access to the system, with authentication based one username, password, and a linked phone number or email address.
2. **Scorecard Reading**: Upload a photo of your physical scorecard after the match. The scorecard will have the handwriting read and auto-calculated.
3. **Stroke Counter**: Golfers are able to keep track of their  stroke count for a single hole so that they never need to remember what stroke they are on.
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

#### Rationale:

#### Users:

#### Preconditions:
#### Basic Course of Events:
#### Alternitive Paths:
#### Postconditions:


### UC-1.3: Secure Sign-Out

#### Summary:

#### Rationale:

#### Users:

#### Preconditions:
#### Basic Course of Events:
#### Alternitive Paths:
#### Postconditions:

### UC-1.1: Secure Forgot-Password

#### Summary:

#### Rationale:

#### Users:

#### Preconditions:
#### Basic Course of Events:
#### Alternitive Paths:
#### Postconditions:


### Functional Requirements:

### Non-Functional Requirements:
### References: 
### TODO:


- USE CASES


- Registration Page

- Sign-Up Page

- Home Page Button need to open secondary windows when created.
## Bugs:
Bugs Found 0.

