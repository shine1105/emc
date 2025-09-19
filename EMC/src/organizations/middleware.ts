import { z } from 'zod';

export const organizationsSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  parentOrganizationId: z.any(),
  domain: z.string().min(1, 'Domain is required'),
  address_line1: z.string().min(1, 'Address line 1 is required'),
  address_line2: z.string().optional(),
  cityId: z.number().int().positive('City ID must be a positive integer'),
  stateId: z.number().int().positive('State ID must be a positive integer'),
  zipCode: z.string().min(1, 'Zip code is required'),
  countryId: z.number().int().positive('Country ID must be a positive integer'),
  contactDetails: z.string().optional(),
  billingEmail: z.string().email('Invalid email format').optional()      
});

export default organizationsSchema;