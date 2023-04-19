import express from "npm:express@4.18.2";
import { info, enable, log } from "npm:diary@0.4.4";
enable("*");

function bootstrap() {
  const app = express();

  app.use(express.json());

  app.use((req, res, next) => {
    // log(`${Date.now()} ${req.method} ${req.url}`);
    console.log(`${Date.now()} ${req.method} ${req.url}`);
    next();
  });

  app.post(`/`, (req: express.ExpressRequest, res: express.ExpressResponse) => {
    const { email, password } = req.body;

    if (email !== "hanutsingh@gmail.com" || password !== "qweasd@123") {
      res.status(401).send();
      return;
    }
    res.json({ username: "hanut", role: "super admin" });
  });

  app.use("*", (req, res) => {
    res.status(404).send("Not Found");
  });

  info(`Deno Server ready at: http://localhost:3000`);
  app.listen(3000);
}

bootstrap();
