import { Hono } from 'hono';
import * as schema from '../../db/schema';
import { db } from '../../db/db';
import { eq, or } from 'drizzle-orm';
import organizationsSchema from '../organizations/middleware';
import { zValidator } from '@hono/zod-validator';

export const organizationsController = new Hono();

const selectOrganizationFields = {
  organizationName: schema.organizations.name,
  domain: schema.organizations.domain,
  addressLine1: schema.organizations.address_line1,
  addressLine2: schema.organizations.address_line2,
  cityName: schema.cities.name,
  stateName: schema.states.name,
  postalCode: schema.organizations.zipCode,
  countryName: schema.countries.name,
  phone: schema.organizations.contactDetails,
  billingEmail: schema.organizations.billingEmail,
  supportEmail: schema.organizations.supportEmail,
};

const applyJoins = (baseQuery: any) =>
  baseQuery
    .innerJoin(schema.cities, eq(schema.cities.id, schema.organizations.cityId))
    .innerJoin(schema.states, eq(schema.states.id, schema.organizations.stateId))
    .innerJoin(schema.countries, eq(schema.countries.id, schema.organizations.countryId));



organizationsController.get('/getAll', async (c) => {
  debugger;
  const organizations = await applyJoins(
    db.select(selectOrganizationFields).from(schema.organizations)
  );
  return c.json(organizations);
});


organizationsController.post('/create', zValidator('json', organizationsSchema), async (c) => {
  const body = c.req.valid('json');
  await db.insert(schema.organizations).values(body);
  return c.json({ message: 'Organization created successfully' }, 201);
});


organizationsController.put('/update/:id', zValidator('json', organizationsSchema), async (c) => {
  const id = Number(c.req.param('id'));
  const body = c.req.valid('json');
  await db.update(schema.organizations).set(body).where(eq(schema.organizations.id, id));
  return c.json({ message: 'Organization updated successfully' });
});


organizationsController.delete('/delete/:id', async (c) => {
  const id = Number(c.req.param('id'));
  await db.delete(schema.organizations).where(eq(schema.organizations.id, id));
  return c.json({ message: 'Organization deleted successfully' });
});


organizationsController.get('/get/:id', async (c) => {
  const id = Number(c.req.param('id'));
  const org = await applyJoins(
    db.select(selectOrganizationFields).from(schema.organizations).where(eq(schema.organizations.id, id))
  );
  return c.json(org);
});


organizationsController.get(
  '/search/:query',
  async (c) => {
    const query = c.req.param('query');
    const orgs = await applyJoins(
      db.select(selectOrganizationFields)
        .from(schema.organizations)
        .where(or(eq(schema.organizations.name, query), eq(schema.organizations.domain, query)))
    );

    if (orgs.length === 0) {
      return c.json({ message: 'No organizations found matching the search' }, 404);
    }
    return c.json(orgs);
  }
);


organizationsController.get('/children/:name', async (c) => {
  const name = c.req.param('name');

  const parentOrg = await db
    .select({ id: schema.organizations.id })
    .from(schema.organizations)
    .where(eq(schema.organizations.name, name))
    .limit(1);

  if (parentOrg.length === 0) {
    return c.json({ message: 'Parent organization not found' }, 404);
  }

  const children = await applyJoins(
    db.select(selectOrganizationFields)
      .from(schema.organizations)
      .where(eq(schema.organizations.parentOrganizationId, parentOrg[0].id))
      .orderBy(schema.organizations.name)
  );

  return c.json(children);
});


export default organizationsController;
