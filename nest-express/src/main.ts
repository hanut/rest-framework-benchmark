import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { PinoLogger } from './logger.service';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    logger: new PinoLogger(),
  });

  app.useGlobalPipes(new ValidationPipe({ whitelist: true }));

  await app.listen(3000);
}
bootstrap();
