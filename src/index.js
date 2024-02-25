import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import routes from "./routes.js";
import pool from "./pool.js";

dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());
app.use(routes);

app.listen(3000);
console.log("Servidor iniciou");

// Example query
pool.query("SELECT NOW()", (err, res) => {
  if (err) {
    console.error("Error executing query", err);
  } else {
    console.log("Query result:", res.rows);
  }
});
