'use strict' 
 
const express = require('express'); 
const morgan = require('morgan'); 
 
const app = express(); 
 
app.use(morgan('dev')); 
app.use(express.json())

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
        return add_user_to_db(null, username, encrypt_password(password), email, phone_number, res)
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
        return check_str_for_invalid_chars(username)
    }
    else return false
    
}
function check_password(password){
    if(checkIfString(password)){
        if (password.length >= 8){
            if(is_password_valid(password)){
                return true
            } 
            else return false
        }
    }
    else return false
    
}
function check_email(email){
    return false
}
function check_phone(phone_number){
    return false
}
function add_user_to_db(db, username, password, email, phone_number, res){
    // return a http response
    const user_was_added_to_database = false
    if (user_was_added_to_database){
        return res.status(201).json ({ message: "User created successfully"})
    }
    else return res.status(409).json({ error: "Duplicate entry" })
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
function encrypt_password(password){
    //need to actually enctypt this
    return password
}