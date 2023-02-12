import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  Post,
  Put,
  Req,
  UseGuards,
  UsePipes,
  ValidationPipe,
} from '@nestjs/common';
import { Request } from 'express';
import { AuthGuard } from '@nestjs/passport';
import { TasksService } from '../services/tasks.service';
import { CreateTaskDto } from '../dtos/createTask.dto';
import { TasksPipe } from '../pipe/tasks.pipe';
import { UpdateTaskDto } from '../dtos/updateTask.dto';

@Controller('tasks')
@UseGuards(AuthGuard())
@UsePipes(new ValidationPipe())
export class TasksController {
  constructor(private taskService: TasksService) {}

  @Get()
  getTasks(@Req() request: Request | any): Promise<any> {
    const userPayload = request.user.email;
    return this.taskService.getAllTasks(userPayload);
  }

  @Get(':id')
  getTaskById(
    @Req() request: Request | any,
    @Param('id', ParseIntPipe) id: number,
  ) {
    const userPayload = request.user.email;
    return this.taskService.getTaskById(id, userPayload);
  }

  @Post()
  createTaskById(
    @Body(TasksPipe) taskPayload: CreateTaskDto,
    @Req() request: Request | any,
  ) {
    const userPayload = request.user.email;
    return this.taskService.createTask(taskPayload, userPayload);
  }

  @Put(':id')
  updateTaskById(
    @Param('id', ParseIntPipe) id: number,
    @Body(TasksPipe) taskPayload: UpdateTaskDto,
    @Req() request: Request | any,
  ) {
    const userPayload = request.user.email;
    return this.taskService.updateTask(taskPayload, userPayload, id);
  }

  @Delete(':id')
  deleteTaskById(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: Request | any,
  ) {
    const userPayload = request.user.email;
    return this.taskService.deleteTaskById(id, userPayload);
  }
}
