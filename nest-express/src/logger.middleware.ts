import { Injectable, Logger, NestMiddleware } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { PinoLogger } from './logger.service';

@Injectable()
export class LoggerMiddleware implements NestMiddleware {
  private readonly logger = new Logger(PinoLogger.name);

  use(req: Request, _res: Response, next: NextFunction) {
    this.logger.log(`${Date.now()} ${req.method} ${req.url}`);
    next();
  }
}
