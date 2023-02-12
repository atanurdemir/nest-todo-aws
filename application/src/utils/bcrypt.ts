import * as bcrypt from 'bcrypt';

export async function generateSalt(): Promise<string> {
  return bcrypt.genSalt();
}

export async function hashPassword(password: string): Promise<string> {
  const salt = await generateSalt();
  return bcrypt.hash(password, salt);
}

export async function comparePassword(
  password: string,
  hash: string,
): Promise<boolean> {
  return bcrypt.compare(password, hash);
}
