import 'dotenv/config';
import { drizzle } from 'drizzle-orm/node-postgres';
import { db} from './db.ts';
import { countries, states, cities } from './schema.ts';


async function seedCountriesStatesCities() {
  const countryInserted = await db
    .insert(countries)
    .values([
      {
        name: 'United States',
        countryCode: 'US',
        symbol: '$',
        isDefault: true,
        region: 'North America',
      },
      {
        name: 'India',
        countryCode: 'IN',
        symbol: '₹',
        region: 'Asia',
      },
    ])
    .returning({ id: countries.id, countryCode: countries.countryCode });

  const usa = countryInserted.find((c) => c.countryCode === 'US');
  const india = countryInserted.find((c) => c.countryCode === 'IN');
  if (!usa || !india) throw new Error('Required countries not found.');

  const stateInserted = await db
    .insert(states)
    .values([
      { name: 'California', countryId: usa.id, code: 'CA' },
      { name: 'New York', countryId: usa.id, code: 'NY' },
      { name: 'Maharashtra', countryId: india.id, code: 'MH' },
      { name: 'Karnataka', countryId: india.id, code: 'KA' },
    ])
    .returning({ id: states.id, name: states.name });

  const ca = stateInserted.find((s) => s.name === 'California');
  const ny = stateInserted.find((s) => s.name === 'New York');
  const mh = stateInserted.find((s) => s.name === 'Maharashtra');
  const ka = stateInserted.find((s) => s.name === 'Karnataka');
  if (!ca || !mh) throw new Error('Required states not found.');

  await db.insert(cities).values([
    { name: 'Los Angeles', stateId: ca.id, code: 'LA' },
    { name: 'San Francisco', stateId: ny.id, code: 'SF' },
    { name: 'Mumbai', stateId: mh.id, code: 'MUM' },
    { name: 'Pune', stateId: ka.id, code: 'PUN' },
  ]);

}

seedCountriesStatesCities()
  .then(() => {
    console.log('Seeding completed.');
    process.exit(0);
  })
  .catch((err) => {
    console.error(' Seeding failed:', err);
    process.exit(1);
  });
