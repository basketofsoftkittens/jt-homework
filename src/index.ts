import express, { Application } from "express";

const PORT = process.env.PORT || 8000;

const app: Application = express();

app.get("/podcast", async (_req, res) => {
    res.send({
        message: "Here is your podcast",
    });
});

app.post("/podcast/modify", async (_req, res) => {
    res.send({
        message: "The podcast was modified",
    });
});

app.listen(PORT, () => {
    console.log("Server is running on port", PORT);
});