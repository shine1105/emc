import { Hono } from 'hono'
import { serve } from 'bun'   
import organizations from './organizations/controller'

const app = new Hono()
const port = 3000

app.use('*', async (c, next) => {
    console.log(`Request: ${c.req.method} ${c.req.url}`)
    await next()
})

app.route('/organizations', organizations)

serve({ fetch: app.fetch, port })
console.log(`Server is running on port ${port}`)