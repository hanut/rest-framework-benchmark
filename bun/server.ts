import express from "express";
import pino from "pino";
const logger = pino(
  pino.destination({
    minLength: 4096,
    sync: false,
  })
);

const app = express();
app.use((req, res, next) => {
  logger.info(`${Date.now()} ${req.method} ${req.url}`);
  next();
});
app.use(express.json());

app.post(`/`, async (req, res) => {
  const { email, password } = req.body;

  if (email !== "hanutsingh@gmail.com" || password !== "qweasd@123") {
    res.status(401).send();
    return;
  }
  res.json({ username: "hanut", role: "super admin" });
});

const server = app.listen(3000, () =>
  console.log(`🍔 Server ready at: http://localhost:3000`)
);
