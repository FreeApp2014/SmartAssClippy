const app = require("express")();

app.get("/generate", (req, res) => {
    res.status(200);
    res.send("000");
})

app.listen(9823, "0.0.0.0", () => {console.log("API server started")});