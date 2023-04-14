const express = require("express");
const pino = require("pino");

const logger = pino(
  pino.destination({
    minLength: 4096,
    sync: false,
  })
);

const app = express();

app.use(express.json());

app.use((req, res, next) => {
  logger.info(`${Date.now()} ${req.method} ${req.url}`);
  next();
});

app.post(`/`, async (req, res) => {
  const { email, password } = req.body;

  if (email !== "hanutsingh@gmail.com" || password !== "qweasd@123") {
    res.status(401).send();
    return;
  }
  res.json({ username: "hanut", role: "super admin" });
});

const server = app.listen(3001, () =>
  console.log(`Node Server ready at: http://localhost:3001`)
);
