import { Expose } from 'class-transformer';
import { IsEmail, IsString } from 'class-validator';

export class LoginReqDto {
  @IsEmail()
  email: string;

  @IsString()
  password: string;
}

@Expose()
export class LoginResDto {
  username: string;

  role: string;

  constructor(props: Partial<LoginResDto>) {
    this.username = props.username;
    this.role = props.role;
  }
}
