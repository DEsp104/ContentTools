const express = require("express");

// const cors = require("cors");

const logger = require("morgan");

const editRoutes = require("./routes/edits");

const app = express();

app.use(express.json());

app.use(express.urlencoded({ extended: false }));

app.use(logger("dev"));

// app.use(cors());

app.get("/", (req, res) => res.send("API is running!"));

app.use("/api", editRoutes);


module.exports = app;