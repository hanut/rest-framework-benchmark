import { Body, Controller, Post } from '@nestjs/common';
import { AppService } from './app.service';
import { LoginReqDto, LoginResDto } from './dtos/login.dto';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Post()
  login(@Body() body: LoginReqDto): LoginResDto {
    return this.appService.authenticate(body.email, body.password);
  }
}
