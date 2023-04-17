import { Injectable } from '@nestjs/common';
import { LoginResDto } from './dtos/login.dto';

@Injectable()
export class AppService {
  authenticate(email: string, password: string): LoginResDto {
    if (email !== 'hanutsingh@gmail.com' || password !== 'qwead@123') {
      return undefined;
    }
    const userDetails = new LoginResDto({
      username: 'hanut',
      role: 'super admin',
    });
    return userDetails;
  }
}
