import { Hono } from "hono";
import { poweredBy } from "hono/powered-by";
import pinetto from "pinetto";

const logger = pinetto({ level: "debug" });

const app = new Hono();

app.use("*", poweredBy());

app.use("*", async (c, next) => {
  logger.info(`${Date.now()} ${c.req.method} ${c.req.url}`);
  await next();
});

app.post("/", async (c) => {
  const { email, password } = await c.req.json();
  if (email !== "hanutsingh@gmail.com" || password !== "qweasd@123") {
    c.status(401);
    return c.text("Unauthorized");
  }
  return c.json({ username: "hanut", role: "super admin" });
});

export default {
  port: 3000,
  fetch: app.fetch,
};
