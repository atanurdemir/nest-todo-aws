import { Module } from '@nestjs/common';
import { AuthService } from './services/auth.service';
import { AuthController } from './controllers/auth.controller';
import { FirestoreModule } from 'src/firestore/firestore.module';
@Module({
  controllers: [AuthController],
  imports: [FirestoreModule],
  providers: [AuthService],
})
export class AuthModule {}
