import { Module } from '@nestjs/common';
import { FirestoreService } from './services/firestore.service';

@Module({
  exports: [FirestoreService],
  providers: [FirestoreService],
})
export class FirestoreModule {}
