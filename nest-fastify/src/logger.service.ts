import { LoggerService } from '@nestjs/common';
import { pino } from 'pino';

export class PinoLogger implements LoggerService {
  private logger = pino({ name: 'Nest Express' });

  log(message: any) {
    this.logger.info(message);
  }

  error(message: any) {
    this.logger.error(message);
  }

  warn(message: any) {
    this.logger.warn(message);
  }

  debug?(message: any) {
    this.logger.debug(message);
  }

  verbose?(message: any) {
    this.logger.trace(message);
  }
}
