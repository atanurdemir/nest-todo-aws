import { Injectable, NotFoundException } from '@nestjs/common';
import { FirestoreService } from 'src/firestore/services/firestore.service';
import { CreateTaskDto } from '../dtos/createTask.dto';
import { UpdateTaskDto } from '../dtos/updateTask.dto';
import { Task } from '../entities/task.entity';

@Injectable()
export class TasksService {
  constructor(private readonly db: FirestoreService) {}

  async getAllTasks(userPayload: string): Promise<any> {
    try {
      return await this.db.getAllTasks('tasks', userPayload);
    } catch (err) {
      console.log(err);
    }
  }

  async getTaskById(id: number, userPayload: string): Promise<any> {
    try {
      return await this.db.getTaskById('tasks', userPayload, id);
    } catch (err) {
      throw new NotFoundException();
    }
  }

  async createTask(
    taskDetails: CreateTaskDto,
    userPayload: string,
  ): Promise<Task> {
    try {
      return await this.db.createTask('tasks', {
        ...taskDetails,
        email: userPayload,
      });
    } catch (err) {
      console.log(err);
    }
  }

  async updateTask(
    taskDetails: UpdateTaskDto,
    userPayload: string,
    postId: number,
  ): Promise<Task> {
    try {
      const task = await this.db.getTaskById('tasks', userPayload, postId);
      if (task.empty) {
        throw new NotFoundException();
      }
      return await this.db.updateTask('tasks', {
        ...taskDetails,
        email: userPayload,
        id: postId,
      });
    } catch (err) {
      console.log(err);
      throw new NotFoundException();
    }
  }

  async deleteTaskById(id: number, userPayload: string): Promise<any> {
    try {
      return await this.db.deleteTaskById('tasks', id, userPayload);
    } catch (err) {
      console.log(err);
      throw new NotFoundException();
    }
  }
}
