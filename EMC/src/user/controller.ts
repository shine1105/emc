import { Hono } from 'hono';
import 'dotenv/config';
import * as schema from '../../db/schema';
import { db } from '../../db/db';



export const userController = new Hono();

// userController.post('/signUp', async(c) => {
//     const { email, password } = await c.req.json();
//     const { data, error } = await supabase.auth.signUp({
//         email,
//         password,
//     });
//     if (error) {
//         return c.json({ error: error.message }, 400);
//     }
//     const { user, session } = data;
//     return c.json({ user, session });

// });


// userController.post('/login', async(c) => {
//     const { email, password } = await c.req.json();
//     const { data, error } = await supabase.auth.signInWithPassword({
//         email,
//         password,
//         });
//         if (error) {
//             return c.json({ error: error.message }, 400);
//             }
//             const { user, session } = data;
//             return c.json({ user, session });
// })

userController.post('/create', async(c) => {
    const { roleId,
          firstName,
          lastName,
          phone,
          languageId,
          address,
          countryId,
          stateId,
          cityId,
          zipCode,
          isActive } = await c.req.json();

const user = await db.insert(schema.users).values({
    roleId,
    firstName,
    lastName,
    phone,
    languageId,
    address,
    countryId,
    stateId,
    cityId,
    zipCode,
    isActive
}).returning();

return c.json({ user });
});

export default userController;