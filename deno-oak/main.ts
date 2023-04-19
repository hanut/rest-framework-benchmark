import { Application, Router } from "https://deno.land/x/oak@v12.2.0/mod.ts";
import { enable, info, log } from "npm:diary@0.4.4";

enable("*");

function createRouter(): Router {
  const router = new Router();
  router.post("/", async (ctx) => {
    const { email, password } = await ctx.request.body({ type: "json" }).value;
    if (email !== "hanutsingh@gmail.com" || password !== "qweasd@123") {
      return ctx.throw(401, "Unauthorized");
    }
    ctx.response.body = { username: "hanut", role: "super admin" };
  });
  return router;
}

function bootstrap() {
  const app = new Application();

  app.use(async (ctx, next) => {
    log(`${Date.now()} ${ctx.request.method} ${ctx.request.url}`);
    await next();
  });

  const router = createRouter();
  app.use(router.routes());
  app.use(router.allowedMethods());
  app.listen({ port: 3000, hostname: "localhost" });
  info(`🌲Deno + Oak server running on http://localhost:3000`);
}

bootstrap();
