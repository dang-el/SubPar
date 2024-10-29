'use strict'

const http = require('http');

const server = http.createServer((req, res) => {
    //ESTABLISH SERVER ROUTES
    console.log(`the requested URL is: ${req.url}`)
    console.log(`The host address is ${req.headers.host}`); 
    console.log(`The HTTP method used is ${req.method}`); 

    res.writeHead(200, {'Content-Type': 'text/html'}); 
    res.end(`<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Hello World</title>
</head>
<body>
    <h1>Hello, World!</h1>
</body>
</html>`)
    
});



server.listen(60000, () => console.log('The server is up an running...'))
