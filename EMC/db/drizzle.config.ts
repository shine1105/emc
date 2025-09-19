import {defineConfig} from 'drizzle-kit';

export default defineConfig({
  out: './migrations',
  schema: './schema.ts',
  dialect: 'postgresql',
  dbCredentials: {
    host: Bun.env.DB_HOST ,
    port: Bun.env.DB_PORT ? Number(process.env.DB_PORT) : 5432,
    user: Bun.env.DB_USER ,
    password: Bun.env.DB_PASSWORD ,
    database: Bun.env.DB_NAME,
    ssl: true,
  },
})