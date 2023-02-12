import { ArgumentMetadata, Injectable, PipeTransform } from '@nestjs/common';

@Injectable()
export class TasksPipe implements PipeTransform {
  transform(value: any, metadata: ArgumentMetadata) {
    console.log(value);
    return value;
  }
}
