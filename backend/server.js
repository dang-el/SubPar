'use strict' 
 
const express = require('express'); 
const morgan = require('morgan'); 
const bcrypt = require('bcrypt');
const sqlite3 = require('sqlite3').verbose();

const app = express(); 
 
app.use(morgan('dev')); 
app.use(express.json({limit : '10mb'}))

app.listen(6000, () => console.log('The server is up and running...'));

const db_conn = new sqlite3.Database('../references/SubParDB.db', (err) => {
    if (err) {
        console.error("Error connecting to the database:", err.message);
    } else {
        console.log('Connected to the SQLite database.');
    }
});
app.post('/sign-in', (req, res) => {
    const data = req.body;
    
    // Early validation for username and password
    if (!data.username || typeof data.username !== 'string' || !check_username(data.username)) {
        return res.status(400).json({ error: "Invalid username" });
    }
    if (!data.password || typeof data.password !== 'string' || !check_password(data.password)) {
        return res.status(400).json({ error: "Invalid password" });
    }

    console.log(data);
    
    return sign_in_user(data.username, data.password, res);
});

async function sign_in_user(username, password, res) {
    console.log("signing in", username, password);

    db_conn.get(`
        SELECT Password
        FROM Golfers 
        WHERE Username = ?
    `, [username], async (err, row) => {
        if (err) return res.status(500).json({ error: "Internal server error", message: `${err.message}` });

        if (row) {
            const storedHash = row.Password;  // Get the stored bcrypt hash from DB

            // Compare the input password with the stored hash using bcrypt
            const isPasswordValid = await bcrypt.compare(password, storedHash);
            console.log("Password Match:", isPasswordValid); // Should print 'false' for incorrect passwords

            if (isPasswordValid) {
                db_conn.get(`
                    SELECT Golfer_ID
                    FROM Golfers
                    WHERE Username = ?
                `, [username], (err, row) => {
                    if (err) return res.status(500).json({ error: "Internal server error", message: `${err.message}` });
                    if (row) {
                        return res.status(200).json({ message: "Successful Sign-in", golfer_id: row.Golfer_ID });
                    } else {
                        return res.status(404).json({ message: `No user exists with username: ${username}` });
                    }
                });
            } else {
                return res.status(401).json({ message: "Incorrect password" });
            }
        } else {
            return res.status(404).json({ message: "Username not found" });
        }
    });
}



app.post('/register', (req, res) => {
    const data = req.body
    if (!data.username || typeof data.username !== 'string') {
        return res.status(400).json({ error: "Invalid or missing 'username' in request body" });
    }
    if (!data.password || typeof data.password !== 'string') {
        return res.status(400).json({ error: "Invalid or missing 'password' in request body" });
    }
    if(!(data.email || data.phone_number)){
        return res.status(400).json({ error: "Missing 'email or phone number' in request body" });
    }
    console.log('Recieved Data:', data)
    return register_new_golfer(data.username, data.password, data.email, data.phone_number, res)
})



app.post('/record-stroke', (req, res) => {
    const data = req.body
    if (!data.userID || typeof data.userID !== 'number' || data.userID === -1) {
        return res.status(400).json({ error: "Invalid or missing 'userID' in request body" });
    }
    if(!data.clubType || data.clubType === 'unassigned' || typeof data.clubType !== 'string'){
        return res.status(400).json({ error: "Invalid or missing 'clubType' in request body" });
    }
    if(!data.distance || typeof data.distance !== 'string'){
        return res.status(400).json({ error: "Invalid or missing 'distance' in request body" });
    }
    if(!data.rating || typeof data.rating !== 'string'){
        return res.status(400).json({ error: "Invalid or missing 'rating' in request body" });
    }
    if(checkclubType(data.clubType) && checkDistance(data.distance) && checkRating(data.rating)){
        //console.log('clubtype and distance and rating are good')
        recordStrokeInDatabase(data, res)
    }
    else return res.status(400).json({ error: "VALIDATION ERROR"})

    
});
app.post('/friend-requests', (req, res) => {
    const data = req.body
    console.log(data)

    if (!checkFriendRequestData(data)){
        return res.status(400).send()
    }
    const searchTerm = data.userID
    const query = ` SELECT g.Golfer_ID, g.Username
                    FROM Golfers AS g
                    JOIN GolferSendsFriendRequest AS gsfr
                    ON g.Golfer_ID = gsfr.RequestingGolferID
                    WHERE gsfr.ReceivingGolferID = ?;
                    `
    db_conn.all(query, [searchTerm], (err, rows) => {
        if (err) {
            console.error(err.message)
            return res.status(400).json({error : `${err.message}`})
        }
        console.log(`Golfers:`, rows)
        return res.status(200).json(rows)
    })
})


app.post('/stroke-history', (req, res) => {
    const data = req.body
    
    const userID = data.userID
    console.log("Data recieved", userID)


    db_conn.all("SELECT * FROM GolferTakesStroke WHERE Golfer_ID = ?", [data.userID], (err, rows) => {
        if (err) {
            console.error(err.message);
            return res.status(400);
        }
        
        console.log(`User ${userID}'s Strokes:`, rows);
        return res.status(200).json(rows)
    });
    
})

app.post('/search/golfers', (req, res) =>{
    const data = req.body
    console.log(data)
    //validate input
    if (!checkSearchGolferRequestData(req, res)){
        return
    }
    return getGolfersOfNameFromDB(data.friendsName, res)

    
})

app.post('/search/friends', (req, res) =>{
    const data = req.body
    console.log(data)
    //validate input
    if(!data.userID){
        return res.status(400).json({error : "NO ID PROVIDED"})
    }
    if (!checkID(data.userID)){
        return res.status(400).json({error : "INVALID DATA IN USERID"})
    }
    const sql = `
                SELECT g.Golfer_ID, g.Username
                FROM GolferHasFriend ghf
                JOIN Golfers g ON ghf.FriendID = g.Golfer_ID
                WHERE ghf.GolferID = ?

                UNION

                SELECT g.Golfer_ID, g.Username
                FROM GolferHasFriend ghf
                JOIN Golfers g ON ghf.GolferID = g.Golfer_ID
                WHERE ghf.FriendID = ?;
                `
    
    db_conn.all(sql, [data.userID, data.userID], (err, rows) => {
        if (err) {
            console.error(err.message)
            return res.status(400).json({error : `${err.message}`})
        }
        console.log(`Golfers:`, rows)
        return res.status(200).json(rows)
    })


    
})

app.post('/addFriend', (req, res) => {
    const { requestingUserID, receivingUserID } = req.body;

    // Validate request data
    if (!checkAddFriendReqData({ requestingUserID, receivingUserID })) {
        return res.status(400).json({ error: "Invalid request data" });
    }

    // Check if a friend request already exists
    db_conn.get(`SELECT * FROM GolferSendsFriendRequest WHERE RequestingGolferID = ? AND ReceivingGolferID = ?`, [requestingUserID, receivingUserID], (err, row) => {
        if (err) {
            console.error("Error checking for existing friend request:", err.message);
            return res.status(500).json({ error: "An error occurred while checking for existing request." });
        }

        // If a request already exists, prevent sending another one
        if (row) {
            return res.status(400).json({ error: "Friend request already sent." });
        }

        // Insert the new friend request
        db_conn.run(`INSERT INTO GolferSendsFriendRequest (RequestingGolferID, ReceivingGolferID) VALUES (?, ?)`, [requestingUserID, receivingUserID], function(err) {
            if (err) {
                console.error("Error inserting friend request:", err.message);
                return res.status(500).json({ error: "An error occurred while processing your request." });
            }

            console.log("Friend request sent successfully.");
            return res.status(200).json({ message: "Friend request sent successfully!" });
        });
    });
});



app.post('/accept-friend-request', (req, res) => {
    const data = req.body
    console.log("recieved", data)
    if(!data.userID && data.friendID){
        return res.status(400).json({error : "MISSING ID"})
    }
    const userID = data.userID
    const friendID = data.friendID
    if(!(checkID(userID) && checkID(friendID))){
        return res.status(400).json({error : "ERROR CHECKING ID"})
    }
    //make a new entry in the GolferHasFriend Table
    db_conn.run(`INSERT INTO GolferHasFriend (GolferID, FriendID) VALUES (?, ?)`, [userID, friendID], function(err) {
        if (err) {
            console.error("Error inserting friend request:", err.message);
            return res.status(500).json({ error: "An error occurred while processing your request." });
        }

        console.log("Friend request sent successfully.");
        
    });

    //when we get here we have a userID and a friendID and the user trying to remove the friends request
    removeFriendRequestFromDB(res, userID, friendID)

})


app.post('/decline-friend-request', (req, res) => {
    const data = req.body
    console.log("recieved", data)
    if(!data.userID && data.friendID){
        return res.status(400).json({error : "MISSING ID"})
    }
    const userID = data.userID
    const friendID = data.friendID
    if(!(checkID(userID) && checkID(friendID))){
        return res.status(400).json({error : "ERROR CHECKING ID"})
    }
    //when we get here we have a userID and a friendID and the user trying to remove the friends request
    removeFriendRequestFromDB(res, userID, friendID)

})

app.post('/scorecards/upload', (req, res) => {
    const data = req.body
    console.log(data)
    const base64encodedImageData = data.image_data
    const userID = data.userID
    if(base64encodedImageData && userID){
        if (!checkUploadScoreCardData(base64encodedImageData, userID)){
            return res.status(400).json({error: "INVALID JSON BODY"})
        }
    }
    else{
        return res.status(400).json({error : "MISSING JSON BODY MEMBERS"})
    }
    const imageBuffer = Buffer.from(base64encodedImageData, 'base64');
    db_conn.run(`INSERT INTO Scorecards (img, Golfer_ID) VALUES (?, ?)`, [imageBuffer, userID], function(err) {
        if (err) {
            console.error("Error uploading scorecard", err.message);
            return res.status(500).json({ error: "An error occurred while uploading your scorecard." });
        }

        console.log("Scorecard successfully uploaded.");
        return res.status(200).send()
    });
    
})
function checkUploadScoreCardData(base64encodedImageData, userID){
    return checkID(userID)
}
app.post('/scorecards/retrieve', async (req, res) => {
    const data = req.body;
    console.log("Received Data:", data);
    

    if (!checkID(data.userID)) {
        return res.status(400).json({ success: false, message: "Invalid userID" });
    }

    const offset = Number.isInteger(data.page_num) ? data.page_num : 0;

    try {
        // Ensure db_conn.all() is properly awaited using a Promise
        const scorecards = await new Promise((resolve, reject) => {
            db_conn.all(
                'SELECT Scorecards.Scorecard_ID, Scorecards.img FROM Scorecards WHERE Scorecards.Golfer_ID = ? LIMIT ? OFFSET ?;',
                [data.userID, 10, offset],
                (err, rows) => {
                    if (err) {
                        reject(err);
                    } else {
                        resolve(rows);
                    }
                }
            );
        });

        console.log("Fetched Scorecards:", scorecards);
        //possibly zip images and then send the zip back in http response to be unzipped
        if (!Array.isArray(scorecards) || scorecards.length === 0) {
            return res.status(404).json({ success: false, message: "No scorecards found" });
        }

        const scorecardsBase64 = scorecards.map(scorecard => {
            if (!scorecard.img) {
                return { id: scorecard.Scorecard_ID, imageBase64: null };
            }

            try {
                return {
                    Scorecard_ID: scorecard.Scorecard_ID,
                    img: Buffer.isBuffer(scorecard.img) 
                        ? scorecard.img.toString('base64') 
                        : Buffer.from(scorecard.img).toString('base64')
                };
            } catch (error) {
                console.error("Failed to convert image to base64:", error);
                return { id: scorecard.Scorecard_ID, imageBase64: null };
            }
        });

        return res.json(scorecardsBase64);

    } catch (error) {
        console.error("Database query failed:", error);
        return res.status(500).json({ success: false, message: "Internal server error" });
    }
});

app.post('/golfer/info', async (req, res) => {
    const data = req.body;
    console.log("Received request:", data);

    if (!checkID(data.UserID)) {
        return res.status(400).json({ error: "MISSING USERID" });
    }

    db_conn.get(
        `SELECT Golfers.Username, Golfers.Email, Golfers.Phone_Number FROM Golfers WHERE Golfers.Golfer_ID = ?;`,
        [data.UserID],
        async (err, row) => { // Make the callback async
            if (err) {
                return res.status(400).json({ error: "COULD NOT RECEIVE GOLFER INFO FROM SERVER" });
            }
            if (!row) {
                return res.status(400).json({ error: "GOLFER DOES NOT EXIST" });
            }

            try {
                const isAdmin = await isAdministrator(data.UserID); // Await the Promise
                const isEst = await isEstablishment(data.UserID);  // Await the Promise

                const response = { user: row, isAdministrator: isAdmin, isEstablishment: isEst };

                return res.status(200).json(response);
            } catch (error) {
                return res.status(500).json({ error: "DATABASE ERROR", details: error.message });
            }
        }
    );
});
app.post('/golfer/update/information', async (req, res) => {
    const data = req.body;
    console.log(data);
    //check if the data is in the body
    if (!('OldUsername' in req.body) || 
        !('NewUsername' in req.body) || 
        !('NewPassword' in req.body) || 
        !('NewEmail' in req.body) || 
        !('NewPhoneNumber' in req.body) || 
        !('UserID' in req.body)) {
            return res.status(400).json({ message: "Missing required fields in the request body" });
    }
    const oldUsername = data.OldUsername;
    const newUsername = data.NewUsername;
    const newPassword = data.NewPassword;
    const newEmail = data.NewEmail;
    const newPhoneNumber = data.NewPhoneNumber;
    const userID = data.UserID;
    //make sure the ID is valid
    if(!checkID(userID)){
        return res.status(401).json({message : `USER ID NOT SUPPLIED`});
    }

    //check the database to see if the username matches the ID so that we for sure have the correct user
    try{
        const user = await getGolferNameFromID(userID);
        if(oldUsername !== user.Username){
            return res.status(402).json({message : `original username doesnt match User ID.\nPlease try again`})
        }
        //check to see if we are updating the username 
        let updatingUsername = false;
        let usernameValid = false;
        if(newUsername !== ""){
            //we are updating the username
            updatingUsername = true;
            //check to see if the username is valid
            if(check_username(newUsername)){
                //if the new username that is being provided by the user meets the username requirements
                usernameValid = true;
                
            }
        }
        //check to see if we are updating the password
        let updatingPassword = false;
        let passwordValid = false;
        if(newPassword !== ""){
            //we are updating the password
            updatingPassword = true;
            if(check_password(newPassword)){
                //if the new password that is being provided by the user meets the password requirements
                passwordValid = true;
                
            }
        }
        //check to see if we are updating the email
        let updatingEmail = false;
        let emailValid = false;
        if(newEmail !== ""){
            //we are updating the email
            updatingEmail = true;
            if(check_email(newEmail)){
                //if the new email that is being provided by the user meets the email requirements
                emailValid = true;
            }
        }
        //check to see if we are updating the email
        let updatingPhone = false;
        let phoneValid = false;
        if(newPhoneNumber !== ""){
            //we are updating the email
            updatingPhone = true;
            if(check_phone(newPhoneNumber)){
                //if the new phone number that is being provided by the user meets the phone number requirements
                phoneValid = true;
            }
        }
        let userResult = null;
        let passwordResult = null;
        let emailResult = null;
        let phoneResult = null;

        //call asyncronoyus functions to add database insertion functions to the callback queue

        if(updatingUsername && usernameValid){
            try{
                userResult = await updateUsername(userID, newUsername);
                console.log(userResult);
            }
            catch(error){
                console.log(error);
            }
            
        }
        if(updatingPassword && passwordValid){
            try{
                passwordResult = await updatePassword(userID, newPassword);
                console.log(passwordResult);
            }
            catch(error){
                console.log(error);
            }
        }
        if(updatingEmail && emailValid){
            try{
                emailResult = await updateEmail(userID, newEmail);
                console.log(emailResult);
            }
            catch(error){
                console.log(error);
            }
        }
        if(updatingPhone && phoneValid){
            try{
                phoneResult = await updatePhoneNumber(userID, newPhoneNumber);
                console.log(phoneResult);
            }
            catch(error){
                console.log(error);
            }
        }
        
        return res.status(200).json({message : checkGolferUpdateQueryResults(userResult, passwordResult, emailResult, phoneResult, updatingUsername, updatingPassword, updatingEmail, updatingPhone)});

    }
    catch(err){
        console.log(err);
        return res.status(500).send()
    }
});
function checkGolferUpdateQueryResults(username, password, email, phone_number, updatingUsername, updatingPassword, updatingEmail, updatingPhone) {
    let success_message = "Changes made: ";
    let failure_message = "Requested but not updated: ";
    let changesMade = false;
    let failedChanges = false;

    // Check username update
    if (updatingUsername) { // User requested username change
        if (username !== null && username.status === 200) {
            success_message += "Username updated. ";
            changesMade = true;
        } else {
            failure_message += "Username. ";
            failedChanges = true;
        }
    }

    // Check password update
    if (updatingPassword) { // User requested password change
        if (password !== null && password.status === 200) {
            success_message += "Password updated. ";
            changesMade = true;
        } else {
            failure_message += "Password. ";
            failedChanges = true;
        }
    }

    // Check email update
    if (updatingEmail) { // User requested email change
        if (email !== null && email.status === 200) {
            success_message += "Email updated. ";
            changesMade = true;
        } else {
            failure_message += "Email. ";
            failedChanges = true;
        }
    }

    // Check phone number update
    if (updatingPhone) { // User requested phone number change
        if (phone_number !== null && phone_number.status === 200) {
            success_message += "Phone number updated. ";
            changesMade = true;
        } else {
            failure_message += "Phone number. ";
            failedChanges = true;
        }
    }

    // Determine final message
    if (!changesMade && !failedChanges) {
        return "No changes were requested.";
    } else if (!changesMade && failedChanges) {
        return failure_message.trim();
    } else if (changesMade && !failedChanges) {
        return success_message.trim();
    } else {
        return success_message.trim() + " " + failure_message.trim();
    }
}


async function getGolferNameFromID(user_id, oldUsername){
    if(!checkID(user_id)){
        return false;
    }
    return new Promise((resolve, reject) => {
        const sql = `SELECT Golfers.Username FROM Golfers WHERE Golfers.Golfer_ID = ?;`;
        db_conn.get(sql, [user_id], function (err, row) {
            if(err){
                console.log("Database Error:", err.message);
                reject(false);
            }
            if(row){
                console.log("Row returned:", row);
                resolve(row);
            }
            else{
                console.log("NO ROW RETURNED, NO USERNAME TO RETRIEVE FOR USERID");
                reject(false);
            }
        });
    });
}

async function updateEmail(userID, newEmail){
    return new Promise((resolve, reject) => {
        const sql = `UPDATE Golfers SET Email = ? WHERE Golfer_ID = ?;`;
        db_conn.run(sql, [newEmail, userID], function (err) {
            if(err){
                console.log(`Database Error:`, err.message);
                reject({ status: 500, message: "DATABASE ERROR UPDATING EMAIL" });
            }
            else if(this.changes > 0){
                console.log("Email successfully modified in database");
                resolve({ status: 200, message: "UPDATED EMAIL SUCCESSFULLY" });
            }
            else {
                console.log("Email update failed (no rows affected)");
                reject({ status: 406, message: "EMAIL NOT CHANGED" });
            }
        });
    });
}
async function updatePhoneNumber(userID, newPhone){
    return new Promise((resolve, reject) => {
        const sql = `UPDATE Golfers SET Phone_Number = ? WHERE Golfer_ID = ?;`;
        db_conn.run(sql, [newPhone, userID], function (err) {
            if(err){
                console.log(`Database Error:`, err.message);
                reject({ status: 500, message: "DATABASE ERROR UPDATING PHONE NUMBER" });
            }
            else if(this.changes > 0){
                console.log("Phone Number successfully modified in database");
                resolve({ status: 200, message: "UPDATED PHONE NUMBER SUCCESSFULLY" });
            }
            else {
                console.log("Phone Number update failed (no rows affected)");
                reject({ status: 406, message: "PHONE NUMBER NOT CHANGED" });
            }
        });
    });
}
async function updateUsername(userID, newUsername){
    
    return new Promise((resolve, reject) => { 
        check_if_username_present(newUsername, (err, exists) =>{
            if(err) {
                console.error("An error occurred:", err);
                reject({status : 500, message : "INTERNAL SERVER ERROR WHILE CHECKING IF USERNAME TAKEN\nPLEASE TRY AGAIN. SORRY!"})
            } else {
                if (exists) {
                    console.log("Username already taken.");
                    reject({status : 409, message : `USER ALREADY EXISTS WITH USERNAME ${newUsername}, PLEASE TRY ANOTHER USERNAME`})
                } else {
                    console.log("Username is available for use.");
                    
                    
                    //if the username was valid run an insert query to change it
                    let sql = `UPDATE Golfers SET Username = ? WHERE Golfer_ID = ?;`;
                    db_conn.run(sql, [newUsername, userID], function (err) {  // Use function() instead of () => {}
                        if (err) {
                            console.log(`❌ Database error:`, err.message);
                            reject({ status: 500, message: "DATABASE ERROR UPDATING USERNAME" });
                        }
                        else if (this.changes > 0) {
                            console.log("Username successfully modified in database");
                            resolve({ status: 200, message: "UPDATED USERNAME SUCCESSFULLY" });
                        } else {
                            console.log("Username update failed (no rows affected)");
                            reject({ status: 406, message: "USERNAME NOT CHANGED" });
                        }
                    });
                }
            }
        });           
    });

    


}
async function updatePassword(userID, newPassword) {
    try {
        // Wait for the password to be hashed
        const newHashedPassword = await encrypt_password(newPassword);
        console.log("Hashed Password:", newHashedPassword);

        // SQL query
        const sql = `UPDATE Golfers SET Password = ? WHERE Golfer_ID = ?;`;

        // Execute the query inside a Promise to handle async behavior
        return new Promise((resolve, reject) => {
            db_conn.run(sql, [newHashedPassword, userID], function (err) {
                if (err) {
                    console.error("Database Error:", err.message);
                    reject({ status: 500, message: "DATABASE ERROR UPDATING PASSWORD" });
                } else if (this.changes > 0) {
                    console.log("Password successfully modified in database");
                    resolve({ status: 200, message: "UPDATED PASSWORD SUCCESSFULLY" });
                } else {
                    console.log("Password update failed (no rows affected)");
                    reject({ status: 406, message: "PASSWORD NOT CHANGED" });
                }
            });
        });

    } catch (error) {
        console.error("Error hashing password:", error);
        throw { status: 500, message: "ERROR HASHING PASSWORD" };
    }
}

function isAdministrator(user_id) {
    return new Promise((resolve, reject) => {
        db_conn.get(
            `SELECT 1 FROM Administrators WHERE Administrators.Golfer_ID = ?;`,
            [user_id],
            (err, row) => {
                if (err) {
                    reject(err);
                } else {
                    resolve(row ? true : false); // Ensure it returns a Boolean
                }
            }
        );
    });
}

function isEstablishment(user_id) {
    return new Promise((resolve, reject) => {
        db_conn.get(
            `SELECT 1 FROM Establishments WHERE Establishments.Golfer_ID = ?;`,
            [user_id],
            (err, row) => {
                if (err) {
                    reject(err);
                } else {
                    resolve(row ? true : false); // Ensure it returns a Boolean
                }
            }
        );
    });
}


function removeFriendRequestFromDB(res, userID, friendID){
    // SQL query to delete the entry
    const query = `DELETE FROM GolferSendsFriendRequest WHERE ReceivingGolferID = ? AND RequestingGolferID = ?`;

    db_conn.run(query, [userID, friendID], function (err) {
        if (err) {
            console.error('Error running delete query:', err.message);
            return res.status(500).json({ error: "Database error" });
        }

        if (this.changes === 0) {
            // No rows were affected, meaning no matching entry was found
            return res.status(404).json({ error: "No matching friend request found" });
        }

        console.log(`Deleted friend request: userID=${userID}, friendID=${friendID}`);
        return res.status(200).json({ message: "Friend request declined" });
    });
}



function checkID(id){
    if(id && typeof id == 'number' && id > -1) return true
    else return false
    
}



function recordStrokeInDatabase(data, res){
    console.log('recording stroke', data)
    const userID = data.userID
    const clubType = data.clubType
    const distance = parseInt(data.distance)
    const rating = parseFloat(data.rating)
    //console.log(userID, clubType, distance, rating)
    //need to insert values into database
    checkRecordStrokeData(userID, clubType, distance, rating)
    db_conn.run(`INSERT INTO GolferTakesStroke (Golfer_ID, ClubType, Distance, Rating ) VALUES (?, ?, ?, ?)`, [userID, clubType, distance, rating])


    return res.status(200).json({message : `club type: ${data.clubType}, distance: ${data.distance}, rating: ${data.rating}`})
}
function checkRecordStrokeData(userID, clubtype, distance, rating){
    //we should probably futher check the information here to make sure the requests are properly being handled
}

function checkclubType(clubType){
    return true
    //need to veryify that clubtype is actually correcty and not being injected with bad data other than actual clubs 
}
function checkDistance(distance){
    if (/^\d+$/.test(distance)) return ((parseInt(distance, 10) <= 600) && parseInt(distance) > 0) 
        else return false

}
function checkRating(rating){
    // Check if the rating is a valid number (can be an integer or a float)
    const parsedRating = parseFloat(rating);
    
    // Ensure the parsed rating is a valid number, is within the range [0, 10], and matches the string exactly
    return !isNaN(parsedRating) && parsedRating >= 0 && parsedRating <= 10 && String(parsedRating) === rating;
}


//need to only gather the IDS of the golfers the player is not currently friends with
function getGolfersOfNameFromDB(friendsName, res){
    const query = "SELECT Golfer_ID, Golfers.Username FROM Golfers WHERE Golfers.Username LIKE ?";
    const searchTerm = `%${friendsName}%`; // Add '%' to friendsName before passing it as a parameter

    db_conn.all(query, [searchTerm], (err, rows) => {
        if (err) {
            console.error(err.message)
            return res.status(400).json({error : `${err.message}`})
        }
        console.log(`Golfers:`, rows)
        return res.status(200).json(rows)
    })
}
function checkSearchGolferRequestData(req, res){
    const data = req.body
    console.log(data)
    //check for friendsName and that it is a string
    if(!data.friendsName || typeof data.friendsName !== 'string'){
        res.status(400).json({error: "Invalid Data"})
        return false
    }
    else{
        if(!check_str_for_invalid_chars(data.friendsName)){
            //bad values found in string
            res.status(400).json({error: "Invalid Characters in Request Body"})
            return false
        }
        else return true
        
    }
}



// Helper function to validate the request data
function checkAddFriendReqData(data) {
    if (!data.requestingUserID || typeof data.requestingUserID !== 'number' || data.requestingUserID === -1) {
        return false;
    }
    if (!data.receivingUserID || typeof data.receivingUserID !== 'number' || data.receivingUserID === -1) {
        return false;
    }
    return true;
}


function checkFriendRequestData(data){
    return true
}




app.use((req, res) => { 
    res.status(404).send(`<h2>Uh Oh!</h2><p>Sorry ${req.url} cannot be found here</p>`); 
}); 

 


async function register_new_golfer(username, password, email, phone_number, res) {
    console.log("PROCEESSING GOLFER INFORMATION", username, password, email, phone_number);

    if (check_valid_user(username, password, email, phone_number)) {
        try {
            const hashedPassword = await encrypt_password(password); // Await here
            return add_user_to_db(username, hashedPassword, email, phone_number, res);
        } catch (error) {
            console.error("Error hashing password:", error);
            return res.status(500).json({ error: "Internal server error" });
        }
    } else {
        res.status(422).json({ error: "Data failed validation" });
    }
}
function check_valid_user(username, password, email, phone_number){
    return (check_username(username) && check_password(password) && (check_email(email) || check_phone(phone_number)))
}
function check_username(username){
    if (!checkIfString(username)) return false
    if (username.length >=6 ){
        if (check_str_for_invalid_chars(username)) return true
        else return false
    }
    else return false
}
function check_password(password){
    if(checkIfString(password)){
        if (password.length >= 8){
            if(is_password_valid(password)) return true
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
function add_user_to_db(username, password, email, phone_number, res){
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
                    //get the golfers if that was just registered
                    return res.status(201).json({message : "DATABASE SUCESSFULLY MODIFIED", golfer_id: this.lastID})
                } )
                
            }
        }
    })
}

function checkIfString(param) {
    return typeof param === 'string';
}
function check_str_for_invalid_chars(string) {
    string = string.trim();  // Remove leading/trailing whitespace if any
    console.log("Checking string:", string);  // Log the string for debugging
    return (!(string.includes(" ") || string.includes(",") || string.includes("'") || string.includes("\\") || string.includes(".")));
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
async function encrypt_password(password){
    // 10 is the salt rounds, which defines the strength of the hashing
    return await bcrypt.hash(password, 10);
}

