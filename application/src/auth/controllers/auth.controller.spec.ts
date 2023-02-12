import { Test, TestingModule } from '@nestjs/testing';
import { AuthController } from './auth.controller';
import { AuthService } from '../services/auth.service';
import { CreateUserDto } from '../dtos/createUser.dto';
import { LoginUserDto } from '../dtos/loginUser.dto';
import { FirestoreService } from 'src/firestore/services/firestore.service';

describe('Auth Controller', () => {
  let authController: AuthController;
  let authService: AuthService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AuthController],
      providers: [AuthService, FirestoreService],
    }).compile();

    authController = module.get<AuthController>(AuthController);
    authService = module.get<AuthService>(AuthService);
  });

  describe('AuthController', () => {
    it('should be defined', () => {
      expect(authController).toBeDefined();
    });

    describe('register', () => {
      it('should call authService.register', () => {
        const mockPayload: CreateUserDto = {
          username: Math.random().toString(36).substring(2, 10),
          email: Math.random().toString(36).substring(2, 15),
          password: Math.random().toString(36).substring(2, 10),
        };

        const result = {
          token: Math.random().toString(36).substring(2, 10),
        };

        jest
          .spyOn(authService, 'register')
          .mockImplementation(async () => result);

        expect(authController.register(mockPayload)).resolves.toEqual(
          expect.objectContaining(result),
        );
        expect(authService.register).toHaveBeenCalledTimes(1);
      });
    });

    describe('login', () => {
      it('should call authService.login', () => {
        const mockPayload: LoginUserDto = {
          email: Math.random().toString(36).substring(2, 15),
          password: Math.random().toString(36).substring(2, 10),
        };

        const result = {
          token: Math.random().toString(36).substring(2, 10),
        };

        jest.spyOn(authService, 'login').mockImplementation(async () => result);

        expect(authController.login(mockPayload)).resolves.toEqual(
          expect.objectContaining(result),
        );
        expect(authService.login).toHaveBeenCalledTimes(1);
      });
    });
  });
});
