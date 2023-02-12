import { IsIn, IsOptional, IsString } from 'class-validator';

export class UpdateTaskDto {
  @IsString()
  @IsOptional()
  title: string;

  @IsString()
  @IsOptional()
  description: string;

  @IsOptional()
  @IsIn(['todo', 'doing', 'done'])
  status: string;
}
