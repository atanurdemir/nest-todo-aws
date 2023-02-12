import {
  Body,
  Controller,
  Post,
  UsePipes,
  ValidationPipe,
} from '@nestjs/common';
import { AuthPipe } from '../pipe/auth.pipe';
import { AuthService } from '../services/auth.service';
import { CreateUserDto } from '../dtos/createUser.dto';
import { LoginUserDto } from '../dtos/loginUser.dto';

@Controller()
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('register')
  @UsePipes(new ValidationPipe())
  register(
    @Body(AuthPipe) userPayload: CreateUserDto,
  ): Promise<{ token: string }> {
    return this.authService.register(userPayload);
  }

  @Post('login')
  @UsePipes(new ValidationPipe())
  login(@Body(AuthPipe) userPayload: LoginUserDto): Promise<{ token: string }> {
    return this.authService.login(userPayload);
  }
}
