import { Injectable, UnauthorizedException } from '@nestjs/common';
import { FirestoreService } from 'src/firestore/services/firestore.service';
import { comparePassword, hashPassword } from 'src/utils/bcrypt';
import { User } from '../entities/user.entity';
import { sign } from 'jsonwebtoken';

@Injectable()
export class AuthService {
  constructor(private readonly db: FirestoreService) {}

  async register(userDetails: User): Promise<{ token: string }> {
    try {
      const password = await hashPassword(userDetails.password);
      await this.db.createUser('users', { ...userDetails, password });
      return await this.generateToken(userDetails);
    } catch (err) {
      console.log(err);
    }
  }

  async login(userDetails: User): Promise<{ token: string }> {
    try {
      const match = await this.validateUser(userDetails);
      if (!match) throw new UnauthorizedException();
      return await this.generateToken(userDetails);
    } catch (err) {
      throw new UnauthorizedException();
    }
  }

  async validateUser(userDetails: User): Promise<boolean> {
    try {
      const user = await this.db.loginUser('users', userDetails.email);
      if (!user) throw new UnauthorizedException();
      return await comparePassword(userDetails.password, user.password);
    } catch (err) {
      console.log(err);
    }
  }

  async generateToken(userDetails: User): Promise<{ token: string }> {
    const signToken = sign(
      { email: userDetails.email },
      process.env.ACCESS_SECRET,
      {
        expiresIn: '30d',
      },
    );
    return { token: signToken };
  }
}
