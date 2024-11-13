'use strict' 
 
const e = require('express');
const express = require('express'); 
const morgan = require('morgan'); 
const sqlite3 = require('sqlite3').verbose();

const app = express(); 
 
app.use(morgan('dev')); 
app.use(express.json())

const db_conn = new sqlite3.Database('../references/SubParDB.db', (err) => {
    if (err) {
        console.error("Error connecting to the database:", err.message);
    } else {
        console.log('Connected to the SQLite database.');
    }
});


app.post('/register', (req, res) => {
    const data = req.body
    console.log('Recieved Data:', data)
    return register_new_golfer(data.username, data.password, data.email, data.phone_number, res)
})

app.use((req, res) => { 
    res.status(404).send(`<h2>Uh Oh!</h2><p>Sorry ${req.url} cannot be found here</p>`); 
}); 

 
app.listen(6000, () => console.log('The server is up and running...'));

function register_new_golfer(username, password, email, phone_number, res){
    console.log("PROCEESSING GOLFER INFORMATION", username, password, email, phone_number)
    if (check_valid_user(username, password, email, phone_number)){
        return add_user_to_db(username, encrypt_password(password), email, phone_number, res)
    }
    else res.status(422).json({ error: "Data failed validation" });

}
function check_valid_user(username, password, email, phone_number){
    return (check_username(username) && check_password(password) && check_email(email) && check_phone(phone_number))
}
function check_username(username){
    if (!checkIfString(username)){
        return false
    }
    if (username.length >=6 ){
 
        if (check_str_for_invalid_chars(username)){
            console.log("username good")
            return true
        }
        else return false
    }
    else return false
    
}
function check_password(password){
    if(checkIfString(password)){
        if (password.length >= 8){
            if(is_password_valid(password)){
                console.log("password good")
                return true
            } 
            else return false
        }
    }
    else return false
    
}
function check_email(email){
    return validateEmail(email)
}
function check_phone(phone_number){
    return validatePhoneNumber(phone_number)
}

function check_if_username_present(username, callback){

    db_conn.get("SELECT * FROM Golfers WHERE Golfers.Username = ?", [username], (err, row) => {
        if (err) {
            console.error("Error checking username:", err.message);
            callback(err, null);  // Return error to callback
            return;
        }
        console.log("Query result row:", row);
        if (row) {
            // If row is found, the username exists
            callback(null, true);  // Pass 'true' to indicate the username exists
        } else {
            // If no row is found, the username is available
            callback(null, false);  // Pass 'false' to indicate the username is available
        }

    })
}
function add_user_to_db(username, password, email, phone_number, res, callback){
    //check if the username is present in the database

    check_if_username_present(username, (err, exists) =>{
        if(err) {
            console.error("An error occurred:", err);
            return res.status(500).json({ error: "INTERNAL SERVER ERROR"})
        } else {
            if (exists) {
                console.log("Username already taken.");
                return res.status(409).json({message : `USER ALREADY EXISTS WITH USERNAME ${username}`})
            } else {
                console.log("Username is available for use.");
                
                //run insert query 
                db_conn.run(`INSERT INTO Golfers (Username, Password, Email, Phone_number ) VALUES ( ?, ?, ?, ?)`,[username, password, email, phone_number], function(err) {
                    if (err) return console.error('Error inserting user:', err.message);
                    console.log(`User added with ID: ${this.lastID}`);
                    return res.status(201).json({message : "DATABASE SUCESSFULLY MODIFIED", golfer_id: "undefined"})
                } )
                
            }
        }
    })
}
function checkIfString(param) {
    return typeof param === 'string';
}
function check_str_for_invalid_chars(string){
    //return true if not of the bad values are present
    return (!(string.includes(" ") || string.includes(",") || string.includes("'") || string.includes("\"") || string.includes(".")))
}
function is_password_valid(string){
    // Ensure the string doesn't contain invalid characters
    if (!check_str_for_invalid_chars(string)) {
        return false;
    }

    let number_present = false;
    let lowercase_present = false;
    let uppercase_present = false;
    let symbol_present = false;

    for (let char of string) {
        const code = char.charCodeAt(0);
        
        if (code >= 48 && code <= 57) {  // ASCII range for '0' to '9'
            number_present = true;
        } else if (code >= 97 && code <= 122) {  // ASCII range for 'a' to 'z'
            lowercase_present = true;
        } else if (code >= 65 && code <= 90) {  // ASCII range for 'A' to 'Z'
            uppercase_present = true;
        } else if (
            (code >= 32 && code <= 47) ||
            (code >= 58 && code <= 64) ||
            (code >= 91 && code <= 96) ||
            (code >= 123 && code <= 126)
        ) {  // Special characters range
            symbol_present = true;
        }
        // Early exit if all conditions are met
        if (number_present && lowercase_present && uppercase_present && symbol_present) {
            return true;
        }
    }
    return (number_present && lowercase_present && uppercase_present && symbol_present);
}
function validateEmail(email) {
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailPattern.test(email);
}
function validatePhoneNumber(phone) {
    // Regular expression for common formats:
    // - (123) 456-7890
    // - 123-456-7890
    // - 123.456.7890
    // - 1234567890
    // - +31636363634 (international)
    const phonePattern = /^(\+?\d{1,3})?[-.\s]?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}$/;
    return phonePattern.test(phone);
}
function encrypt_password(password){
    //need to actually enctypt this
    return password
}