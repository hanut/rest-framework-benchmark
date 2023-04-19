import Fastify from "fastify";
import pino from "pino";

const logger = pino(
  pino.destination({
    minLength: 4096,
    sync: false,
  })
);

async function bootstrap() {
  const app = Fastify({ logger: false });

  app.addHook("onRequest", (req, _res, next) => {
    logger.info(`${Date.now()} ${req.method} ${req.url}`);
    next();
  });

  app.post(
    `/`,
    {
      schema: {
        response: {
          200: {
            type: "object",
            properties: {
              username: { type: "string" },
              role: { type: "string" },
            },
          },
        },
      },
    },
    async (req, res) => {
      const { email, password } = req.body as {
        email: string;
        password: string;
      };

      if (email !== "hanutsingh@gmail.com" || password !== "qweasd@123") {
        res.status(401).send();
        return;
      }
      return { username: "hanut", role: "super admin" };
    }
  );

  const server = await app.listen({ port: 3000, host: "localhost" });
  console.log(`Node Server ready at: ${server}`);
}

bootstrap().catch((error) => {
  console.error(error);
  process.nextTick(() => process.exit(1));
});
