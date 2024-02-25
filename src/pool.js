import pkg from "pg";
const { Pool } = pkg;

// Create a new Pool instance
const pool = new Pool({
  user: "admin",
  host: "localhost",
  database: "rinha",
  password: "123",
  port: 5432,
});

export default pool;
