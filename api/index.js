const app = require("express")();

app.get("/generate", (req, res) => {
    res.status(200);
    res.send("000");
})

app.get("/task", (req, res) => {
    let taskId = req.query.id;
    //TODO: Perform actual task loading
    res.status(200);
    res.send({
        "info": {
            "taskId":"000",
            "name": "Clippy API Demo",
            "author":"Clippy dev team"
        },
        "text": "Hey there tester! Do you like the way this app works?",
        "qId": "000",
        "options": [
            {
                "text": "YASS!!!11",
                "rId": "001"
            },
            {
                "text": "No",
                "rId": "002"
            },
            {
                "text": "Prefer not to say",
                "rId": "003"
            },
            {
                "text": "Hmmm, is this any special deal?",
                "rId": "004"
            }
        ]
    })
})
app.get("/taskResponse", (req, res) => {
    //TODO: Do actual stuff
    let resp;
    switch (req.query.response){
        case "001":
            resp = {
                "text": "GUD boi",
                "qId": "000",
                "options": [
                    {
                        "text": "Ok",
                        "rId": "002"
                    },
                    {
                        "text": "No",
                        "rId": "001"
                    }
                ]
            };
            break;
        case "002":
            resp = {
                "text": "bad boi",
                "qId": "000",
                "options": [
                    {
                        "text": "Ok",
                        "rId": "001"
                    },
                    {
                        "text": "No",
                        "rId": "002"
                    }
                ]
            };
            break;
        case "003":
            resp = "";
            break;
        case "004":
            resp = {
                "otherBS": "Error"
            }
    }
    res.status(200);
    res.send(resp);
})

app.listen(9823, "0.0.0.0", () => {console.log("API server started")});