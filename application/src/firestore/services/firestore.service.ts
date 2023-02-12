import { DocumentData, Firestore } from '@google-cloud/firestore';
import { Injectable, NotFoundException } from '@nestjs/common';
import { User } from 'src/auth/entities/user.entity';
import { Task } from 'src/tasks/entities/task.entity';

@Injectable()
export class FirestoreService {
  private readonly db: Firestore;
  constructor() {
    this.db = new Firestore({
      projectId: 'nest-example-b38d4',
      keyFilename: 'credentials.json',
    });
  }

  async createUser(
    coll: string,
    userPayload: User,
  ): Promise<{ message: string }> {
    try {
      await this.db.collection(coll).doc(userPayload.email).set(userPayload);
      return { message: 'The user has been successfully created!' };
    } catch (err) {
      console.error(err);
    }
  }

  async loginUser(coll: string, email: string): Promise<DocumentData> {
    try {
      const userSnapshot = await this.db
        .collection(coll)
        .where('email', '==', email)
        .get();

      return userSnapshot.docs.map((doc) => doc.data())[0];
    } catch (err) {
      console.error(err);
    }
  }

  async createTask(coll: string, taskPayload): Promise<Task> {
    let lastTaskId = 0;
    try {
      const lastTaskSnapshot = await this.db
        .collection(coll)
        .where('email', '==', taskPayload.email)
        .orderBy('id', 'desc')
        .limit(1)
        .get();

      if (!lastTaskSnapshot.empty) {
        const lastTaskData = lastTaskSnapshot.docs[0].data();
        lastTaskId = lastTaskData.id + 1;
      }

      const documentId = `${taskPayload.email}-${lastTaskId}`;
      const customPayload = { ...taskPayload, id: lastTaskId };
      await this.db.collection(coll).doc(documentId).set(customPayload);
      return customPayload;
    } catch (err) {
      console.error(err);
    }
  }

  async updateTask(coll: string, taskPayload: Task): Promise<Task> {
    try {
      const documentId = `${taskPayload.email}-${taskPayload.id}`;
      const taskSnapshot = await this.db.collection(coll).doc(documentId).get();
      if (!taskSnapshot.exists) {
        throw new NotFoundException();
      }

      await this.db.collection(coll).doc(documentId).update(taskPayload);
      return { ...taskSnapshot.data(), ...taskPayload };
    } catch (err) {
      throw new NotFoundException();
    }
  }

  async deleteTaskById(
    coll: string,
    id: number,
    email: string,
  ): Promise<{ message: string }> {
    try {
      const documentId = `${email}-${id}`;
      const taskSnapshot = await this.db.collection(coll).doc(documentId).get();
      if (!taskSnapshot.exists) {
        throw new NotFoundException();
      }

      await this.db.collection(coll).doc(documentId).delete();
      return { message: 'Task deleted successfully!' };
    } catch (err) {
      throw new NotFoundException();
    }
  }

  async getAllTasks(coll: string, email: string): Promise<DocumentData[]> {
    try {
      const tasksSnapshot = await this.db
        .collection(coll)
        .where('email', '==', email)
        .orderBy('id', 'desc')
        .get();

      const tasksData = tasksSnapshot.docs.map((doc) => doc.data());
      return tasksData;
    } catch (err) {
      console.error(err);
    }
  }

  async getTaskById(
    coll: string,
    email: string,
    id: number,
  ): Promise<DocumentData> {
    try {
      const taskSnapshot = await this.db
        .collection(coll)
        .where('email', '==', email)
        .where('id', '==', id)
        .get();

      if (taskSnapshot.empty) {
        throw new NotFoundException();
      }

      const taskData = taskSnapshot.docs[0].data();
      return taskData;
    } catch (err) {
      throw new NotFoundException();
    }
  }
}
