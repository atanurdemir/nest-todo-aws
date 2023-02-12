import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { TasksService } from './services/tasks.service';
import { TasksController } from './controllers/tasks.controller';
import { PassportModule } from '@nestjs/passport';
import { JwtStrategy } from './strategies/jwt.strategy';
import { FirestoreModule } from 'src/firestore/firestore.module';
import { LoggerMiddleware } from './middlewares/logger.middleware';

@Module({
  imports: [
    PassportModule.register({ defaultStrategy: 'jwt' }),
    FirestoreModule,
  ],
  providers: [TasksService, JwtStrategy],
  controllers: [TasksController],
})
export class TasksModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(LoggerMiddleware).forRoutes('*');
  }
}
