import { relations } from 'drizzle-orm';
import { pgTable, serial, text, timestamp, boolean, integer, pgEnum, json, numeric, index } from 'drizzle-orm/pg-core';

export const AdminRole = pgEnum('AdminRole', ['OWNER', 'ORGADMIN', 'MANAGER']);
export const chapterTypeEnum = pgEnum('CHAPTERTYPE', ['VIDEO', 'MCQ', 'RESOURCE', 'WEBINAR', 'VIDEOVDOCIPHER', 'VIDEOTPSTREAMS', 'COMMON', 'PROJECT']);
export const userCourseAccessTypeEnum = pgEnum('USERCOURSEACCESSTYPE', ['PAID', 'FREE']);
export const mcqAttemptResultEnum = pgEnum('MCQATTEMPTRESULT', ['PASS', 'FAIL']);
export const mcqAttemptStatusEnum = pgEnum('MCQATTEMPTSTATUS', ['STARTED', 'CLOSED', 'COMPLETED']);
export const orderStatusEnum = pgEnum('ORDERSTATUS', ['CREATED', 'SUCCESS']);
export const limitedType = pgEnum('limitedType', ['DATE', 'DAY']);
export const installmentType = pgEnum('installmentType', ['MONTHLY', 'WEEKLY']); 
export const additionalPriceType = pgEnum('additionalPriceType', ['PERCENT', 'AMOUNT']);
export const couponDiscountType = pgEnum('couponDiscountType', ['PERCENTAGE', 'AMOUNT']);
export const courseType = pgEnum('courseType', [' WEBINAR', 'LIVE', 'COURSE', 'BOOTCAMP']);
export const courseAvailability = pgEnum('courseavailability', ['TIMEBASED', 'LIFETIME']);
export const courseLevel = pgEnum('courseLevel', ['BEGINNER', 'INTERMEDIATE', 'ADVANCED']);
export const statusType = pgEnum('platformFeeStatus', [ 'PENDING', 'BILLED','PAID','REFUNDED', ]);
export const channelChatType = pgEnum('channelChatType', ['TEXT', 'FILE']);
export const userFriendRequestStatus = pgEnum('userFriendRequestStatus', ['PENDING', 'ACCEPTED', 'REJECTED']);
export const CommentFeedbackValue = pgEnum('CommentFeedbackValue', ['LIKE', 'DISLIKE']);
export const ProjectStatus = pgEnum('projectStatus', ['SUBMITTED', 'REVIEWED']);
export const CourseRegistrationStatus = pgEnum('courseRegistrationStatus', ['CREATED', 'REGISTERED']);
export const AdminOrganizationRole = pgEnum('adminOrganizationRole', ['OWNER', 'ORGADMIN', 'MANAGER']);
export const  orgMetricEnum=pgEnum('orgMetricEnum', ['COURSE','USER','BILLING']);
export const userActivityTypeEnum = pgEnum('userActivityTypeEnum', ['LOGIN','LOGOUT','WATCHVIDEO','COMPLETECHAPTER','ATTEMPTMCQ','SUBMITPROJECT','COMMENT',
  'JOINWEBINAR','DOWNLOADCERTIFICATE','ENROLLCOURSE','COMPLETECOURSE', 'REQUESTSUPPORT']);
export const enquiryEnum= pgEnum('enquiryEnum', ['STUDENT', 'PROFESSIONAL']);
export const platformType = pgEnum('platformType', ['VIMEO', 'VDOCIPHER', 'TPSTREAMS']);

export let data = {
  createdAt: timestamp('createdAt').defaultNow(),
  updatedAt: timestamp('updatedAt').defaultNow(),
  createdById: integer('createdById').references(() => users.id),
  updatedById: integer('updatedById').references(() => users.id),
  status: boolean('status').default(true)};

export const countries = pgTable('countries', {
  id: serial('id').primaryKey().notNull(),
  name: text('name').notNull().unique(),
  countryCode: text('countryCode').notNull().unique(),   
  symbol: text('symbol').notNull().unique(),     
  isDefault: boolean('isDefault').default(false),
  region: text('region'),    
  ...data});

export const countriesRelations = relations(countries, ({ many }) => ({
  states: many(states),
  organizations: many(organizations),
  users: many(users),
})
);

export const states = pgTable('states', {
  id: serial('id').primaryKey().notNull(),
  name: text('name').notNull().unique(),
  countryId: integer('countryId').references(() => countries.id),
  code: text('code').notNull().unique(),
  ...data});

export const statesRelations = relations(states, ({ many, one }) => ({
  country: one(countries, { fields: [states.countryId], references: [countries.id] }),
  cities: many(cities),
  organizations: many(organizations),
  users: many(users),
}));

export const cities = pgTable('cities', {
  id: serial('id').primaryKey().notNull(),
  name: text('name').notNull().unique(),
  stateId: integer('stateId').references(() => states.id),
  code: text('code').notNull().unique(),
  ...data});

export const citiesRelations = relations(cities, ({ many, one }) => ({
  state: one(states, { fields: [cities.stateId], references: [states.id] }),
  organizations: many(organizations),
  users: many(users),
}));

export const organizations = pgTable('organizations', {
  id: serial('id').primaryKey().notNull(),
  parentOrganizationId: integer('parentorganizationId').references(() => organizations.id),
  name: text('name').notNull(),
  domain: text('domain').unique(),
  address_line1: text('address_line1'),
  address_line2: text('address_line2'),
  contactDetails: text('contactDetails'),
  countryId: integer('countryId').references(() => countries.id).notNull(),
  stateId: integer('stateId').references(() => states.id).notNull(),
  cityId: integer('cityId').references(() => cities.id).notNull(),
  zipCode: text('zipCode'),
  billingEmail: text('billingemail'),
  supportEmail: text('supportemail'),
  ...data,
}
);

export const organizationRelations = relations(organizations, ({ many, one }) => ({
  users: many(organizationUsers),
  country: one(countries, {
    fields: [organizations.countryId],
    references: [countries.id],
  }),
  parent: one(organizations, {
    fields: [organizations.parentOrganizationId],
    references: [organizations.id],
  }),
}));
 
export const languages = pgTable('languages', {
  id: serial('id').primaryKey().notNull(),
  name: text('name').notNull().unique(),
  code: text('code').notNull().unique(),
  countryId: integer('countryId').references(() => countries.id).notNull(),
  ...data});
 
export const users = pgTable('user', {
  id: serial('id').primaryKey().notNull(),
  roleId: integer('roleId').notNull().references(() => role.id),
  firstName: text('firstName').notNull(),
  lastName: text('lastName'),
  email: text('email').notNull().unique(),
  phone: text('phone'),
  password: text('password'),
  image: text('image'),
  googleUserId: text('googleUserId').unique(),
  isVerified: boolean('isVerified').default(false),
  requestPasswordUpdate: boolean('requestPasswordUpdate').default(true),
  languageId: integer('languageId').references(() => languages.id),
  address: text('address'),
  countryId: integer('countryId').references(() => countries.id).notNull(),
  stateId: integer('stateId').references(() => states.id),
  cityId: integer('cityId').references(() => cities.id),
  zipCode: text('zipCode'),
  isActive: boolean('isActive').default(true),
  ...data,
});
 
export const role = pgTable('role', {
  id: serial('id').primaryKey().notNull(),
  code: integer('code').unique(),
  name: text('name').notNull().unique(),
  ...data,});

 
 export const userRelations = relations(users, ({ many }) => ({
  organizationUsers: many(organizationUsers),
  courseReviews: many(courseReviews, { relationName: 'reviewer' }),
}));
 
export const organizationUsers = pgTable('organizationUsers', {
  id: serial('id').primaryKey().notNull(),
  userId: integer('userId').notNull().references(() => users.id),
  roleId: integer('roleId').notNull().references(() => role.id),
  organizationId: integer('organizationId').notNull().references(() => organizations.id),
  isActive: boolean('isActive').default(true),
  ...data,
}
);
 
export const organizationUserRelations = relations(organizationUsers, ({ one }) => ({
  organization: one(organizations, { fields: [organizationUsers.organizationId], references: [organizations.id] }),
}));

 
export const permissions = pgTable('permissions', {
  id: serial('id').primaryKey().notNull(),
  code: text('code').notNull().unique(),         
  description: text('description'),
  ...data});
 
export const rolePermissions = pgTable('rolePermissions', {
  id: serial('id').primaryKey().notNull(),
  roleId: integer('roleId').notNull().references(() => role.id, { onDelete: 'cascade' }),
  permissionId: integer('permissionId').notNull().references(() => permissions.id, { onDelete: 'cascade' }),
  ...data})
 
 
export const courseCategory = pgTable('courseCategory', {
  id: serial('id').primaryKey().notNull(),
  organizationId: integer('organizationId').references(() => organizations.id),
  name: text('name').notNull().unique(),
  description: text('description'),
  ...data});
 
export const courses = pgTable('courses', {
  id: serial('id').primaryKey().notNull(),
  title: text('title').notNull(),
  slug: text('slug').unique(),
  tags: text('tags').array().default([]),
  tagLine: text('tagLine'),
  languageId: integer('languageId').references(() => languages.id, { onDelete: 'set null' }),
  categoryId: integer('categoryId').notNull().references(() => courseCategory.id, { onDelete: 'restrict' }),
  description: text('description').notNull(),
  isPaid: boolean('isPaid').default(true),
  seoTitle: text('seoTitle'),
  seoDescription: text('seoDescription'),
  seoKeywords: text('seoKeywords'),
  courseType: courseType('courseType').default('COURSE'),
  startsOn: timestamp('startsOn'),
  availability: courseAvailability('availability').default('TIMEBASED'),
  thumbnail: text('thumbnail'),
  vimeoFolderUrl: text('vimeoFolderUrl'),
  vdocipherFolderId: text('vdocipherFolderId'),
  tpstreamsFolderId: text('tpstreamsFolderId'),
  maxEnrollments: integer('maxEnrollments'),
  enrollmentCount: integer('enrollmentCount').default(0),
  isPublished: boolean('isPublished'),
  visibility: text('visibility').default('PUBLIC'),
  duration: text('duration'),
  ...data,
}, (table) => ({
  idxCategoryLang: index('idx_courses_org_category_lang').on(table.categoryId, table.languageId),
  idxPublished: index('idx_courses_is_published').on(table.isPublished),
}));
 
export const courseRelations = relations(courses, ({ many, one }) => ({
  category: one(courseCategory, { fields: [courses.categoryId], references: [courseCategory.id] }),
  language: one(languages, { fields: [courses.languageId], references: [languages.id] }),
  details: many(courseDetails),
  instructors: many(courseInstructors),
  reviews: many(courseReviews),
  pricing: many(coursePricing),
  userCourseAccess: many(userCourseAccess),
  courseProgress: many(userCourseProgress),
  orders: many(orders),
  metrics: many(courseMetrics),
  channel: many(courseChannel),
  analytics: many(courseAnalytics),
  registrants: many(courseRegistrants),
  certificates: many(courseCertificates),
  certificateDownloadUsers: many(courseCertificateDownloadUsers),
  prebook: many(coursePrebook),
  splitAmounts: many(courseSplitAmounts),
  mcqDetails: many(courseProgressMcq),
  videoDetails: many(courseProgressVideo),
  liveWebinar: many(liveWebinars),  
}));
   
export const courseDetails = pgTable('courseDetails', {
  id: serial('id').primaryKey().notNull(),
  courseId: integer('courseId').references(() => courses.id, { onDelete: 'cascade' }),
  courseDuration: text('courseDuration'),
  courseLanguage: text('courseLanguage'),
  courseLevel: courseLevel('courseLevel').array().default([]),
  courseSubtitleLanguage: text('courseSubtitleLanguage').array().default([]),
  overview: text('overview'),
  includes: json('includes'),
  learningOutcomes: json('learningOutcomes'),
  curriculum: json('curriculum'),
  requirements: json('requirements'),
  targetAudience: json('targetAudience'),
  ...data,
});
 
export const courseDetailsRelations = relations(courseDetails, ({ one }) => ({
  course: one(courses, { fields: [courseDetails.courseId], references: [courses.id] }),
}));
 
export const courseInstructors = pgTable('courseInstructors', {
  id: serial('id').primaryKey().notNull(),
  courseId: integer('courseId').references(() => courses.id, { onDelete: 'cascade' }),
  thumbnail: text('thumbnail'),
  name: text('name'),
  role: text('role'),
  ratings: text('ratings'),
  experience: text('experience'),
  studentCounts: text('studentCounts'),
  description: text('description'),
  ...data,
});
 
export const courseInstructorsRelations = relations(courseInstructors, ({ one }) => ({
  course: one(courses, { fields: [courseInstructors.courseId], references: [courses.id] }),
}));
 
 
 
export const courseReviews = pgTable('courseReviews', {
  id: serial('id').primaryKey().notNull(),
  courseId: integer('courseId').references(() => courses.id, { onDelete: 'cascade' }),
  reviewerById: integer('reviewerById').references(() => users.id),
  ratings: integer('ratings'),
  comments: text('comments'),
  ...data,
},(table) => ({
    courseDetailsIndex: index('coursedetailsindex').on(table.courseId, table.reviewerById)
    }));
 
export const courseReviewRelations = relations(courseReviews, ({ one }) => ({
  course: one(courses, { fields: [courseReviews.courseId], references: [courses.id] }),
  reviewer: one(users, { fields: [courseReviews.reviewerById], references: [users.id] }),
}));
 
export const coursePricing = pgTable('coursePricing', {
  id: serial('id').primaryKey().notNull(),
  countryId: integer('countryId').notNull().references(() => countries.id),
  courseId: integer('courseId').references(() => courses.id).notNull(),
  totalPrice: integer('totalPrice').notNull(),
  taxPercentage: integer('taxPercentage'),
  taxDescription: text('taxDescription'),
  discountAmount: integer('discountAmount').notNull(),
  includeTaxOnDisplay: boolean('includeTaxOnDisplay').default(true),
  isInstallment: boolean('isInstallment').default(false),
  monthlyInstallments: integer('monthlyInstallments'),
  weeklyInstallments: integer('weeklyInstallments'),
  isLimited: boolean('isLimited').default(false),
  tillDate: text('tillDate'),
  tillDays: integer('tillDays'),
  limitedType: limitedType('limitedType'),
  installmentType: installmentType('installmentType'),
  isEnabled: boolean('isEnabled').default(true),
  ...data
});
 
export const coursePricingRelations = relations(coursePricing, ({ one }) => ({
  course: one(courses, { fields: [coursePricing.courseId], references: [courses.id] }),
  country: one(countries, { fields: [coursePricing.countryId], references: [countries.id] }),
}));
 
 
export const courseAdditionalPricing = pgTable('courseAdditionalPricing', {
  id: serial('id').primaryKey().notNull(),
  pricingId: integer('pricingId').notNull().references(() => coursePricing.id, { onDelete: 'cascade' }),
  type: additionalPriceType('type').default('PERCENT'),
  label: text('label').notNull(),
  value: integer('value').notNull(),
  ...data
});
 
export const courseAdditionalPricingRelations = relations(courseAdditionalPricing, ({ one }) => ({
  pricing: one(coursePricing, { fields: [courseAdditionalPricing.pricingId], references: [coursePricing.id] }),
}));
 
export const sections = pgTable('section', {
  id: serial('id').primaryKey().notNull(),
  title: text('title').notNull(),
  courseId: integer('courseId').references(() => courses.id, { onDelete: 'cascade' }).notNull(),
  sortOrder: integer('sortOrder').notNull(),
  allowedChapters: chapterTypeEnum('allowedChapters').default('COMMON'),
  isPublished: boolean('isPublished').default(false),
  isActive: boolean('isActive').default(true),
  ...data});

export const sectionRelations = relations(sections, ({ one, many }) => ({
  course: one(courses, { fields: [sections.courseId], references: [courses.id] }),
  chapters: many(chapters),
  schedule: many(scheduleSections),
}));

export const scheduleSections = pgTable('scheduleSection', {
  id: serial('id').primaryKey().notNull(),
  sectionId:integer('sectionId').notNull().references(() => sections.id, { onDelete: 'cascade' }),
  scheduleDate: timestamp('scheduleDate').notNull(),
...data});

export const scheduleSectionRelations = relations(scheduleSections, ({ one }) => ({
  section: one(sections, { fields: [scheduleSections.sectionId], references: [sections.id] }),
}));

export const contentTypeEnum = pgEnum('contentType', ['MCQ', 'VIDEO', 'RESOURCE', 'WEBINAR', 'PROJECT']);

export const content = pgTable('content', {
  id: serial('id').primaryKey().notNull(),
  type: contentTypeEnum('type').notNull(),
  content: text('content').notNull(),
  contentCode: integer('contentCode').notNull(),
  isActive: boolean('isActive').default(true),
  ...data
});

export const mcqContent = pgTable('mcqContent', {
  id: serial('id').primaryKey().notNull(),
  contentId: integer('contentId').notNull().references(() => content.id, { onDelete: 'cascade' }),
  isActive: boolean('isActive').default(true),
  ...data
});

export const videoContent = pgTable('videoContent', {
  id: serial('id').primaryKey().notNull(),
  contentId: integer('contentId').notNull().references(() => content.id, { onDelete: 'cascade' }),
  isActive: boolean('isActive').default(true),
  ...data
});

export const resourceContent = pgTable('resourceContent', {
  id: serial('id').primaryKey().notNull(),
  contentId: integer('contentId').notNull().references(() => content.id, { onDelete: 'cascade' }),
  isActive: boolean('isActive').default(true),
  ...data
});

export const webinarContent = pgTable('webinarContent', {
  id: serial('id').primaryKey().notNull(),
  contentId: integer('contentId').notNull().references(() => content.id, { onDelete: 'cascade' }),
  isActive: boolean('isActive').default(true),
  ...data
});

export const projectContent = pgTable('projectContent', {
  id: serial('id').primaryKey().notNull(),
  contentId: integer('contentId').notNull().references(() => content.id, { onDelete: 'cascade' }),
  isActive: boolean('isActive').default(true),
  ...data
});

export const chapters = pgTable(
  'Chapter',
  {
    id: serial('id').primaryKey().notNull(),
    title: text('title').notNull(),
    sectionId: integer('sectionId').references(() => sections.id, { onDelete: 'cascade' }).notNull(),
    description: text('description'),
    attachment: text('attachment').notNull(),
    sortOrder: integer('sortOrder').notNull(),
    mcqContent: integer('mcqContent').references(() => mcqContent.id),
    videoContent: integer('videoContent').references(() => videoContent.id),
    resourceContent: integer('resourceContent').references(() => resourceContent.id),
    webinarContent: integer('webinarContent').references(() => webinarContent.id),
    projectContent: integer('projectContent').references(() => projectContent.id),
    availableFrom: timestamp('availableFrom'),
    availableTill: timestamp('availableTill'),
    isPublished: boolean('isPublished').default(false),
    isActive: boolean('isActive').default(true),
   ...data
  },(table) => ({
  idxSectionSort: index('idx_chapters_section_sort').on(table.sectionId, table.sortOrder),
  idxPublished: index('idx_chapters_is_published').on(table.isPublished),
}));
 
 
export const chapterRelations = relations(chapters, ({ many, one }) => ({
section: one(sections, { fields: [chapters.sectionId], references: [sections.id] }),
  courseProgress: many(userCourseProgress),
  comments: many(chapterComments),
  activityLogs: many(userActivityLogs),}));
 
export const enquiry = pgTable("enquiry", {
  id: serial('id').primaryKey().notNull(),
  course: integer("course").notNull().references(() => courses.id, { onDelete: 'cascade' }),
  name: text("name").notNull(),
  email: text("email").notNull(),
  phone: text("phone").notNull(),
  address: text("address"),
  userType: enquiryEnum("userType").notNull().default("STUDENT"),
  message: text("message"),
  batch: text("batch"),
    ...data,
},
(enquiry) => ({
  emailIdx: index('emailIdx').on( enquiry.email),
  phoneIdx: index('phoneIdx').on( enquiry.phone),
  courseIdx: index('courseIdx').on( enquiry.course)
}));
 
export const enquiryRelations = relations(enquiry, ({ one }) => ({
  course: one(courses, { fields: [enquiry.course], references: [courses.id] }),
}));
 
export const enquiryEnrollmentStudent=pgTable("enquiryEnrollmentStudents", {
  id: serial('id').primaryKey().notNull(),
  education: text("education").notNull(),
  passingYear: text("passingYear").notNull(),
  interest: text("interest").notNull(),
  commitment: text("commitment").notNull(),
  dedication: text("dedication").notNull(),
  expectations: text("expectations").notNull(),
  laptop: boolean("laptop").notNull().default(true),
  courseFee: text("courseFee").notNull(),
  mentorSupport: boolean("mentorSupport").notNull().default(true),
  enquiryId: integer("enquiryId").notNull().unique().references(() => enquiry.id),
  ...data
    
});
 
export const enquiryEnrollmentStudentRelations = relations(enquiryEnrollmentStudent, ({ one }) => ({
  enquiry: one(enquiry, { fields: [enquiryEnrollmentStudent.enquiryId], references: [enquiry.id] }),
}));
 
export const enquiryEnrollmentProfessional = pgTable("enquiryEnrollmentProffessional", {
  id: serial('id').primaryKey().notNull(),
  designation: text("designation").notNull(),
  officeAddress: text("officeAddress").notNull(),
  experience: text("experience").notNull(),
  expectations: text("expectations").notNull(),
  enquiryId: integer("enquiryId").notNull().unique().references(() => enquiry.id),
  ...data
});

export const enquiryEnrollmentProfessionalRelations = relations(enquiryEnrollmentProfessional, ({ one }) => ({
  enquiry: one(enquiry, { fields: [enquiryEnrollmentProfessional.enquiryId], references: [enquiry.id] }),
  }));
 
export const notificationTemplate = pgTable("notificationTemplate", {
  id: serial("id").primaryKey().notNull(),
  courseId: integer("courseId").notNull().references(() => courses.id),
  title: text("title").notNull(),                
  subject: text("subject"),                    
  body: text("body").notNull(),                 
  whatsappTemplate: text("whatsappTemplate"),    
  msgType: text("msgType").notNull().default("text"), 
  mediaUrl: text("mediaUrl"),                  
  ...data
});

export const notificationSchedule = pgTable("notificationSchedule", {
  id: serial("id").primaryKey().notNull(),
  courseId: integer("courseId").notNull().references(() => courses.id),
  templateId: integer("templateId").notNull().references(() => notificationTemplate.id),
  scheduleDay: integer("triggerDay").notNull(),         
  timeOfDay: timestamp("timeOfDay").notNull(),             
  ...data
});

export const notificationLog = pgTable("notificationLog", {
  id: serial("id").primaryKey().notNull(),
  courseId: integer("courseId").notNull().references(() => courses.id),
  templateId: integer("templateId").notNull().references(() => notificationTemplate.id),
  email: text("email"),
  phone: text("phone"),
  countryCode: text("countryCode").default("91"),
  isSuccess: boolean("isSuccess").default(false),
  errorMessage: text("errorMessage"),
  sentAt: timestamp("sentAt").defaultNow(),
  ...data
});

export const notificationTemplateRelations = relations(notificationTemplate, ({ one }) => ({
  course: one(courses, { fields: [notificationTemplate.courseId], references: [courses.id] }),
}));


export const notificationScheduleRelations = relations(notificationSchedule, ({ one }) => ({
  course: one(courses, { fields: [notificationSchedule.courseId], references: [courses.id] }),
  template: one(notificationTemplate, { fields: [notificationSchedule.templateId], references: [notificationTemplate.id] }),
}));


export const notificationLogRelations = relations(notificationLog, ({ one }) => ({
  course: one(courses, { fields: [notificationLog.courseId], references: [courses.id] }),
  template: one(notificationTemplate, { fields: [notificationLog.templateId], references: [notificationTemplate.id] }),
}));

export const resetPassword = pgTable("resetPassword", {
  id: serial('id').primaryKey().notNull(),
  organizationUserId: integer("organizationUserId").references(() => organizationUsers.id, { onDelete: 'cascade' }),
  uuid: text("uuid").notNull().unique(),
  ...data});
 
export const whatsappOtp = pgTable("whatsappOtp", {
  id: serial('id').primaryKey().notNull(),
  phone: text("phone").notNull(),
  otp: text("otp").notNull(),
  ...data});
 
export const userOtp = pgTable('userOtp', {
  id: serial('id').primaryKey().notNull(),
  firstName: text('firstname').notNull(),
  email: text('email').notNull().unique(),
  phone: text('phone').notNull(),
  otp: text('otp'),
  status: boolean('status').default(true),
  createdAt: timestamp('createdat').defaultNow(),
  expiresAt: timestamp('expiresat').notNull()
});

export const userCourseAccess = pgTable("userCourseAccess", {
  id: serial('id').primaryKey().notNull(),
  organizationUserId: integer("organizationUserId").references(() => organizationUsers.id, { onDelete: 'cascade' }),
  courseId: integer("courseId").references(() => courses.id, { onDelete: 'cascade' }),
  type: userCourseAccessTypeEnum("type").notNull(),
  ...data,
  orderId: integer("orderId").references(() => orders.id, { onDelete: 'set null' }),
}
, (table) => ({
  idxUserCourse: index('idx_user_course_access_user_course').on(table.organizationUserId, table.courseId),
  idxOrder: index('idx_user_course_access_order').on(table.orderId),
}));
 
export const userCourseAccessRelations = relations(userCourseAccess, ({ one }) => ({
  user: one(organizationUsers, { fields: [userCourseAccess.organizationUserId], references: [organizationUsers.id] }),
  course: one(courses, { fields: [userCourseAccess.courseId], references: [courses.id] }),
}));
 
export const userCourseProgress = pgTable("userCourseProgress", {
  id: serial("id").primaryKey(),
  organizationUserId: integer("organizationUserId").references(() => organizationUsers.id, { onDelete: 'cascade' }),
  courseId: integer("courseId").references(() => courses.id, { onDelete: 'cascade' }),
  chapterId: integer("chapterId").references(() => chapters.id, { onDelete: 'cascade' }),
  isCurrent: boolean("isCurrent").default(true).notNull(),
  isCompleted: boolean("isCompleted").default(false).notNull(),
  videoDetailsId: integer("videoDetailsId").references(() => courseProgressVideo.id),
  mcqDetailsId: integer("mcqDetailsId").references(() => courseProgressMcq.id),
  ...data,
}, (table) => ({
  idxUserCourseChapter: index('idx_user_course_progress_user_course_chapter').on(table.organizationUserId, table.courseId, table.chapterId),
  idxIsCompleted: index('idx_user_course_progress_is_completed').on(table.isCompleted),
}));

export const userCourseProgressRelations = relations(userCourseProgress, ({ one }) => ({
  user: one(organizationUsers, { fields: [userCourseProgress.organizationUserId], references: [organizationUsers.id] }),
  course: one(courses, { fields: [userCourseProgress.courseId], references: [courses.id] }),
  chapter: one(chapters, { fields: [userCourseProgress.chapterId], references: [chapters.id] }),
  videoDetails: one(courseProgressVideo, { fields: [userCourseProgress.videoDetailsId], references: [courseProgressVideo.id] }),
  mcqDetails: one(courseProgressMcq, { fields: [userCourseProgress.mcqDetailsId], references: [courseProgressMcq.id] }),
}));
 
export const courseVersionHistory = pgTable("courseVersionHistory", {
  id: serial("id").primaryKey().notNull(),
  version: integer("version").default(1).notNull(),
  courseId: integer("courseId").references(() => courses.id),
  createdAt: timestamp("createdAt").defaultNow(),
});

export const courseVersionHistoryRelations = relations(courseVersionHistory, ({ one }) => ({
  course: one(courses, { fields: [courseVersionHistory.courseId], references: [courses.id] }),
}));
 
export const courseProgressVideo = pgTable("courseProgressVideo", {
  id: serial("id").primaryKey().notNull(),
  organizationUserId: integer("organizationUserId").notNull().references(() => organizationUsers.id, { onDelete: 'cascade' }),
  chapterId: integer("chapterId").notNull().references(() => chapters.id),
  hostingPlatform: text("hostingPlatform").notNull(), // e.g. tpstream, Vimeo, etc.
  activeDuration: integer("activeDurationInSec").default(0).notNull(),
  completed: boolean("completed").default(false),
...data,});

export const courseProgressVideoRelations = relations(courseProgressVideo, ({ one }) => ({
  user: one(organizationUsers, { fields: [courseProgressVideo.organizationUserId], references: [organizationUsers.id] }),
  chapter: one(chapters, { fields: [courseProgressVideo.chapterId], references: [chapters.id] }),
}));
 
export const courseProgressMcq = pgTable("courseProgressMcq", {
  id: serial("id").primaryKey().notNull(),
  organizationUserId: integer("organizationUserId").notNull().references(() => organizationUsers.id, { onDelete: 'cascade' }),
  chapterId: integer("chapterId").notNull().references(() => chapters.id),
  score: integer("score"),
  attempts: integer("attempts").default(0),  lastAttemptedAt: timestamp("lastAttemptedAt").defaultNow(),
  completed: boolean("completed").default(false),
  lastAttempted: timestamp("lastAttempted").defaultNow(),
...data,});

export const courseProgressMcqRelations = relations(courseProgressMcq, ({ one }) => ({
  user: one(organizationUsers, { fields: [courseProgressMcq.organizationUserId], references: [organizationUsers.id] }),
  chapter: one(chapters, { fields: [courseProgressMcq.chapterId], references: [chapters.id] }),
}));
export const courseProgressMcqAttempts = pgTable("courseProgressMcqAttempts", {
  id: serial('id').primaryKey().notNull(),
  courseProgressMcqId: integer("courseProgressMcqId").references(() => courseProgressMcq.id, { onDelete: 'cascade' }),
  attemptNo: integer("attemptNo").notNull().default(1),
  resultData: json("resultData"),
  result: mcqAttemptResultEnum("result"),
  startTime: timestamp("startTime", { withTimezone: true }),
  endTime: timestamp("endTime", { withTimezone: true }),
  attemptStatus: mcqAttemptStatusEnum("attemptStatus").notNull().default("STARTED"),
  ...data});
 
  export const courseProgressMcqAttemptsRelations = relations(courseProgressMcqAttempts, ({ one }) => ({
  courseProgressMcq: one(courseProgressMcq, {
    fields: [courseProgressMcqAttempts.courseProgressMcqId],
    references: [courseProgressMcq.id],
  }),
}));
 
export const orders = pgTable('orders', {
  id: serial('id').primaryKey().notNull(),
  organizationUserId: integer("organizationUserId").notNull().references(() => organizationUsers.id, { onDelete: 'cascade' }),
  courseId: integer('courseId').notNull().references(() => courses.id, { onDelete: 'cascade' }),
  amount: numeric('amount', { precision: 10, scale: 2 }).notNull(),
  Status: orderStatusEnum('status').default('CREATED'),
  razorpayOrderId: text('razorpayOrderId'),
  payUTxnid: text('payUTxnid'),
  coupon: integer('coupon').references(() => coupons.id),
  priceDetails: json('priceDetails'),
  transactionDate: timestamp('transactionDate'),
  paymentMethod: text('paymentMethod'),
  gatewayResponse: json('gatewayResponse'),
  invoiceUrl: text('invoiceUrl'),
  ...data,
},(table) => ({
  idxOrgUserCourse: index('idx_orders_org_user_course').on(table.organizationUserId, table.courseId),
  idxStatus: index('idx_orders_status').on(table.Status),
  idxDate: index('idx_orders_date').on(table.transactionDate),
}));

export const ordersRelations = relations(orders, ({ one , many }) => ({
  user: one(organizationUsers, { fields: [orders.organizationUserId], references: [organizationUsers.id] }),
  course: one(courses, { fields: [orders.courseId], references: [courses.id] }),
  coupon: one(coupons, { fields: [orders.coupon], references: [coupons.id] }),
  orderTransactions: many(orderTransactions),
  platformFees: many(platformFees),
  userCourseAccess: many(userCourseAccess),
}));

export const orderTransactions = pgTable('orderTransactions', {
  id: serial('id').primaryKey().notNull(),
  orderId: integer('orderId').notNull().references(() => orders.id, { onDelete: 'cascade' }),
  payUTxnid: text('payUTxnid'),
  event: text('event'),
  paymentDetails: json('paymentDetails'),
  ...data});

  export const orderTransactionsRelations = relations(orderTransactions, ({ one }) => ({
  order: one(orders, { fields: [orderTransactions.orderId], references: [orders.id] }),
}));

export const coupons = pgTable('coupons', {
  id: serial('id').primaryKey().notNull(),
  name: text('name').notNull(),
  code: text('code').notNull().unique(),
  discountType: couponDiscountType('discountType').default('PERCENTAGE'),
  discount: integer('discount').notNull(),
  availableFrom: timestamp('availableFrom'),
  availableTill: timestamp('availableTill'),
  isDeleted: boolean('isDeleted').default(false),
  courseIds: integer('courseIds').array(),
  ...data});

export const couponRedemptions = pgTable('couponRedemptions', {
  id: serial('id').primaryKey().notNull(),
  couponId: integer('couponId').notNull().references(() => coupons.id, { onDelete: 'cascade' }),
  organizationUserId: integer("organizationUserId").notNull().references(() => organizationUsers.id, { onDelete: 'cascade' }),
  orderId: integer('orderId').references(() => orders.id),
  redeemedAt: timestamp('redeemedAt').defaultNow(),
  ...data
}, (table) => ({
  idxUserCoupon: index('idx_coupon_redemptions_user_coupon').on(table.organizationUserId, table.couponId),
}));

export const couponRedemptionsRelations = relations(couponRedemptions, ({ one }) => ({
  coupon: one(coupons, { fields: [couponRedemptions.couponId], references: [coupons.id] }), 
  user: one(users, { fields: [couponRedemptions.organizationUserId], references: [users .id] }),
  order: one(orders, { fields: [couponRedemptions.orderId], references: [orders.id] }),
}));
  
export const platformFees = pgTable(
  'platformFees',
  {
    id: serial('id').primaryKey().notNull(),
    orderId: integer('orderId').notNull().references(() => orders.id, { onDelete: 'cascade' }),
    feeAmount: numeric('feeAmount', { precision: 10, scale: 2 }).notNull(), 
    status: statusType('status').notNull().default('PENDING'),
    billedAt: timestamp('billedAt'), 
    paidAt: timestamp('paidAt'), 
    ...data,
  }, (table) => ({
  idxOrder: index('idx_platform_fees_order').on(table.orderId),
  idxStatus: index('idx_platform_fees_status').on(table.Status),
}));

export const platformFeesRelations = relations(platformFees, ({ one }) => ({
  order: one(orders, { fields: [platformFees.orderId], references: [orders.id] }),
}));

export const courseChannel = pgTable('courseChannel', {
  id: serial('id').primaryKey().notNull(),
  courseId: integer('courseId').references(() => courses.id),
  lastMessageAt: timestamp('lastMessageAt'),
  ...data});

export const courseChannelRelations = relations(courseChannel, ({ one }) => ({
  course: one(courses, { fields: [courseChannel.courseId], references: [courses.id] }),
}));

export const courseChannelUsers = pgTable('courseChannelUsers', {
  id: serial('id').primaryKey().notNull(),
  channelId: integer('channelId').notNull().references(() => courseChannel.id),
  role: integer('role').references(() => role.id),
  isRestricted: boolean('isRestricted').default(false),
  ...data});

export const courseChannelUsersRelations = relations(courseChannelUsers, ({ one }) => ({
  channel: one(courseChannel, { fields: [courseChannelUsers.channelId], references: [courseChannel.id] }),
  role: one(role, { fields: [courseChannelUsers.role], references: [role.id]  }),
}));

export const channelChat = pgTable('channelChat', {
  id: serial('id').primaryKey().notNull(),
  channelId: integer('channelId').notNull().references(() => courseChannel.id),
  type: channelChatType('type').notNull(),
  textValue: text('textValue'),
  fileValue: json('fileValue'),
  replyToId: integer('replyToId').references(() => users.id),
  isPinned: boolean('isPinned').default(false),
  isEdited: boolean('isEdited').default(false),
  readBy: integer('readBy').array().default([]),
  ...data});

export const channelChatRelations = relations(channelChat, ({ one }) => ({
  channel: one(courseChannel, { fields: [channelChat.channelId], references: [courseChannel.id] }),
  replyTo: one(organizationUsers, { fields: [channelChat.replyToId], references: [organizationUsers.id] }),
}));

export const channelUserlog = pgTable('channelUserSession', {
  id: serial('id').primaryKey().notNull(),
  organizationUserId: integer("organizationUserId").notNull().references(() => organizationUsers.id, { onDelete: 'cascade' }),
  channelId: integer('channelId').notNull().references(() => courseChannel.id),
  deviceType: text('deviceType'),
  ipAddress: text('ipAddress'),
  ...data});

export const channelUserSessionRelations = relations(channelUserlog, ({ one }) => ({
  user: one(organizationUsers, { fields: [channelUserlog.organizationUserId], references: [organizationUsers.id] }),
  channel: one(courseChannel, { fields: [channelUserlog.channelId], references: [courseChannel.id] }),
}));

export const socketLog = pgTable('socketlog', {
  id: serial('id').primaryKey().notNull(),
  type: text('type').notNull(),
  log: json('log'),
  ...data});

export const channelChatEditLogs = pgTable('channelChatEditLogs', {
  id: serial('id').primaryKey().notNull(),
  chatId: integer('chatId').notNull().references(() => channelChat.id),
  previousContent: json('previousContent'),
  editedBy: integer('editedBy').references(() => users.id),
  editedAt: timestamp('editedAt').defaultNow(),
  createdAt: timestamp('createdAt').defaultNow(),
  updatedAt: timestamp('updatedAt').defaultNow()});

export const channelChatEditLogsRelations = relations(channelChatEditLogs, ({ one }) => ({
  chat: one(channelChat, { fields: [channelChatEditLogs.chatId], references: [channelChat.id] }),
  editedBy: one(users, { fields: [channelChatEditLogs.editedBy], references: [users.id] }),
}));

export const userFriendRequests = pgTable('userFriendRequests', {
  id: serial('id').primaryKey().notNull(),
  requestedByUserId: integer('requestedByUserId').notNull().references(() => organizationUsers.id),
  requestedToUserId: integer('requestedToUserId').notNull().references(() => organizationUsers.id),
  Status: userFriendRequestStatus('status').default('PENDING'),
  ...data});

export const userFriendRequestsRelations = relations(userFriendRequests, ({ one }) => ({
  requestedBy: one(organizationUsers, { fields: [userFriendRequests.requestedByUserId], references: [organizationUsers.id] }),
  requestedTo: one(organizationUsers, { fields: [userFriendRequests.requestedToUserId], references: [organizationUsers.id] }),
}));

export const chapterComments = pgTable('chapterComments', {
  id: serial('id').primaryKey().notNull(),
  chapterId: integer('chapterId').references(() => chapters.id).notNull(),
  comment: text('comment').notNull(),
  organizationUserId: integer("organizationUserId").notNull().references(() => organizationUsers.id, { onDelete: 'cascade' }),
  parentId: integer('parentId'),
  repliesCount: integer('repliesCount').default(0),
  ...data,
});

export const chapterCommentsRelations = relations(chapterComments, ({ many, one }) => ({
user: one(organizationUsers, { fields: [chapterComments.organizationUserId], references: [organizationUsers.id] }),
  parent: one(chapterComments, { fields: [chapterComments.parentId], references: [chapterComments.id] }),
  replies: many(chapterComments),
  feedbacks: many(commentFeedback),}));

export const commentFeedback = pgTable('commentFeedback', {
  id: serial('id').primaryKey().notNull(),
  commentId: integer('commentId').notNull().references(() => chapterComments.id),
  organizationUserId: integer("organizationUserId").notNull().references(() => organizationUsers.id, { onDelete: 'cascade' }),
  feedback: CommentFeedbackValue('feedback').notNull(),
  ...data,
});

export const commentFeedbackRelations = relations(commentFeedback, ({ one }) => ({
  user: one(organizationUsers, { fields: [commentFeedback.organizationUserId], references: [organizationUsers.id] }),
  comment: one(chapterComments, { fields: [commentFeedback.commentId], references: [chapterComments.id] }),
}));

export const webHookDetails = {
  id: serial('id').primaryKey().notNull(),
  event: text('event').notNull(),
  data: json('data').notNull(),
  platformUrlId: text('platformUrlId'),
  message: text('message'),
  timestamp: timestamp('timestamp').defaultNow(),
}

export const zoomWebhookHistory = pgTable('zoomWebhookHistory', {
  ...webHookDetails,
   ...data,
});

export const meetWebhookHistory = pgTable('meetWebhookHistory', {
  ...webHookDetails,
   ...data,
});

export const tpstreamWebhookHistory = pgTable('tpstreamWebhookHistory', {
  ...webHookDetails,
    ...data,
});
 
export const webinarPlatform = pgTable('webinar_platform', {
  id: serial('id').primaryKey().notNull(),
  platformType: platformType('platformType').notNull(), 
  hostId: integer('host_id').references(() => organizationUsers.id, { onDelete: 'set null' }),
  password: text('password').notNull(),
  title: text('title').notNull(),
  description: text('description'),
  url: text('url').notNull(),
...data});
 
export const liveWebinars = pgTable('live_webinars', {
  id: serial('id').primaryKey().notNull(),
  platformId: integer('platform_id').notNull().references(() => webinarPlatform.id, { onDelete: 'cascade' }),
  courseId: integer('course_id').references(() => courses.id, { onDelete:'cascade' }),
  startsOn: timestamp('starts_on').notNull(),
  attachment: json('attachment').array().default([]),
  thumbnail: text('thumbnail'),
  availableFrom: timestamp('available_from').defaultNow(),
  availableTill: timestamp('available_till').defaultNow(),
  isActive: boolean('is_active').default(true),
  isPublished: boolean('is_published').default(false),
  webinarContent: json('webinar_content'),
  ...data,
});
 
export const liveWebinarsRelations = relations(liveWebinars, ({ one, many }) => ({
   attendees: many(webinarAttendees),
  instructors: many(liveWebinarInstructors),
  registrants: many(liveWebinarRegistrants),
  feedback: many(webinarFeedback),
  recordings: many(webinarRecordings),
  courses: one(courses, { fields: [liveWebinars.courseId], references: [courses.id]  }),
}));

export const liveWebinarInstructors = pgTable('liveWebinarInstructors', {
  id: serial('id').primaryKey().notNull(),
  instructorId: integer('instructorId').references(() => organizationUsers.id),
  webinarId: integer('webinarId').references(() => liveWebinars.id),
  isActive: boolean('isactive').default(true),
  ...data});

  export const liveWebinarInstructorsRelations = relations(liveWebinarInstructors, ({ one }) => ({
  instructor: one(organizationUsers, { fields: [liveWebinarInstructors.instructorId], references: [organizationUsers.id] }),
  webinar: one(liveWebinars, { fields: [liveWebinarInstructors.webinarId], references: [liveWebinars.id] }),
}));

export const liveWebinarRegistrants = pgTable('liveWebinarRegistrants', {
  id: serial('id').primaryKey().notNull(),
  organizationUserId: integer('userId').references(() => organizationUsers.id),
  webinarId: integer('webinarId').references(() => liveWebinars.id),
  isActive: boolean('isactive').default(true),
  ...data});

  export const liveWebinarRegistrantsRelations = relations(liveWebinarRegistrants, ({ one }) => ({
  user: one(organizationUsers, { fields: [liveWebinarRegistrants.organizationUserId], references: [organizationUsers.id] }),
  webinar: one(liveWebinars, { fields: [liveWebinarRegistrants.webinarId], references: [liveWebinars.id] }),
}));

export const webinarRecordings = pgTable('webinarRecordings', {
  id: serial('id').primaryKey().notNull(),
  webinarId: integer('webinarId').notNull().references(() => liveWebinars.id),
  playUrl: text('playurl').notNull(),
  title: text('title').notNull(),
  show: boolean('show').default(true),
  ...data,
});

export const webinarRecordingsRelations = relations(webinarRecordings, ({ one }) => ({
  webinar: one(liveWebinars, { fields: [webinarRecordings.webinarId], references: [liveWebinars.id] }),
}));

export const webinarAttendees = pgTable('webinarAttendees', {
  id: serial('id').primaryKey().notNull(),
  webinarId: integer('webinarId').notNull().references(() => liveWebinars.id),
  organizationUserId: integer("organizationUserId").notNull().references(() => organizationUsers.id, { onDelete: 'cascade' }),
  joinedAt: timestamp('joinedat').defaultNow(),
  leftAt: timestamp('leftat').defaultNow(),
  duration: integer('duration'),
   ...data
});

export const webinarAttendeesRelations = relations(webinarAttendees, ({ one }) => ({
  user: one(organizationUsers, { fields: [webinarAttendees.organizationUserId], references: [organizationUsers.id] }),
  webinar: one(liveWebinars, { fields: [webinarAttendees.webinarId], references: [liveWebinars.id] }),
})); 

export const webinarFeedback = pgTable('webinarFeedback', {
  id: serial('id').primaryKey().notNull(),
  organizationUserId: integer("organizationUserId").notNull().references(() => organizationUsers.id, { onDelete: 'cascade' }),
  webinarId: integer('webinarId').references(() => liveWebinars.id),
  rating: integer('rating'), 
  comment: text('comment'),
  submittedAt: timestamp('submittedAt').defaultNow(),
   ...data
});

export const webinarFeedbackRelations = relations(webinarFeedback, ({ one }) => ({
  user: one(organizationUsers, { fields: [webinarFeedback.organizationUserId], references: [organizationUsers.id] }),
  webinar: one(liveWebinars, { fields: [webinarFeedback.webinarId], references: [liveWebinars.id] }),
}));

export const projectSubmissions = pgTable('projectSubmissions', {
  id: serial('id').primaryKey().notNull(),
  chapterId: integer('chapterId').notNull(),
  organizationUserId: integer("organizationUserId").notNull().references(() => organizationUsers.id, { onDelete: 'cascade' }),
  content: text('content'),
  attachment: json('attachment').array().default([]),
  projectStatus: ProjectStatus('projectStatus').default('SUBMITTED'),
  score: integer('score'),
  feedback: text('feedback'),
  submittedOn: timestamp('submittedOn').defaultNow(),
  ...data});

export const projectSubmissionsRelations = relations(projectSubmissions, ({ one }) => ({
  user: one(organizationUsers, { fields: [projectSubmissions.organizationUserId], references: [organizationUsers.id] }),
  chapter: one(chapters, { fields: [projectSubmissions.chapterId], references: [chapters.id] }),
}));

export const courseRegistrants = pgTable('courseRegistrants', {
  id: serial('id').primaryKey().notNull(),
  courseId: integer('courseId').notNull(),
  organizationUserId: integer("organizationUserId").notNull().references(() => organizationUsers.id, { onDelete: 'cascade' }),
  registrationDate: timestamp('registrationDate').defaultNow(),
  registrationStatus: CourseRegistrationStatus('registrationstatus').default('CREATED'),
  ...data});

  export const courseRegistrantsRelations = relations(courseRegistrants, ({ one }) => ({
  user: one(organizationUsers, { fields: [courseRegistrants.organizationUserId], references: [organizationUsers.id] }),
}));

export const courseCertificates = pgTable('courseCertificates', {
  id: serial('id').primaryKey().notNull(),
courseId: integer('courseId').notNull().references(() => courses.id, { onDelete: 'cascade' }),
  certificateUrl: text('certificateUrl').notNull(),
  ...data});

export const courseCertificatesRelations = relations(courseCertificates, ({ one }) => ({
  course: one(courses, { fields: [courseCertificates.courseId], references: [courses.id] }),
}));


export const courseCertificateDownloadUsers = pgTable('courseCertificateDownloadUsers', {
  id: serial('id').primaryKey().notNull(),
  organizationUserId: integer("organizationUserId").notNull().references(() => organizationUsers.id, { onDelete: 'cascade' }),
courseId: integer('courseId').notNull().references(() => courses.id, { onDelete: 'cascade' }),
  certificateDownloadUrl: text('certificateDownloadUrl').notNull(),
  ...data});

export const courseCertificateDownloadUsersRelations = relations(courseCertificateDownloadUsers, ({ one }) => ({
  user: one(users, { fields: [courseCertificateDownloadUsers.organizationUserId], references: [users.id] }),
}));

export const coursePrebook = pgTable('coursePrebook', {
  id: serial('id').primaryKey().notNull(),
courseId: integer('courseId').notNull().references(() => courses.id, { onDelete: 'cascade' }),
  totalPrice: integer('totalPrice').notNull(),
  discountAmount: integer('discountAmount').notNull(),
  includes: json('includes'),
  isEnabled: boolean('isEnabled').default(true),
  ...data});

export const coursePrebookRelations = relations(coursePrebook, ({ one }) => ({
  course: one(courses, { fields: [coursePrebook.courseId], references: [courses.id] }),
}));  

export const courseSplitAmounts = pgTable('courseSplitAmounts', {
  id: serial('id').primaryKey().notNull(),
courseId:integer('courseId').notNull().references(() => courses.id, { onDelete: 'cascade' }),
  splitCounts: integer('splitCounts').notNull(),
  totalAmount: integer('totalAmount').notNull(),
  splitAmounts: json('splitAmounts').notNull(),
  isEnabled: boolean('isEnabled').default(true),
  ...data});

export const courseSplitAmountsRelations = relations(courseSplitAmounts, ({ one }) => ({
  course: one(courses, { fields: [courseSplitAmounts.courseId], references: [courses.id] }),
}));  

  export const organizationBilling = pgTable('organizationbilling', {
  id: serial('id').primaryKey().notNull(),
  platformFeesId: integer('platformFeesId').references(() => platformFees.id, { onDelete: 'cascade' }),
  organizationId: integer('organizationId').notNull().references(() => organizations.id, { onDelete: 'cascade' }),
  billingPeriod: text('billingPeriod').notNull(),
  totalUsers: integer('totalUsers').default(0),
  totalCourses: integer('totalCourses').default(0),
  invoiceUrl: text('invoiceUrl'),
  paid: boolean('paid').default(false),
 ...data},

);

export const organizationBillingRelations = relations(organizationBilling, ({ one }) => ({
  platformFee: one(platformFees, { fields: [organizationBilling.platformFeesId], references: [platformFees.id] }),
  organization: one(organizations, { fields: [organizationBilling.organizationId], references: [organizations.id] }),
}));

export const userActivityLogs = pgTable("useractivitylogs", {
  id: serial("id").primaryKey().notNull(),
  organizationUserId: integer("organizationUserId").notNull().references(() => organizationUsers.id, { onDelete: 'cascade' }),
  courseId: integer("courseId").references(() => courses.id),
  chapterId: integer("chapterId").references(() => chapters.id),
  activityType: userActivityTypeEnum("activityType").notNull(), 
  activityData: json("activityData"),           
  ...data,
}, (table) => ({
  idxUserCourse: index('idx_user_activity_logs_user_course').on(table.organizationUserId, table.courseId),
}));

export const userActivityLogsRelations = relations(userActivityLogs, ({ one }) => ({
  user: one(organizationUsers, { fields: [userActivityLogs.organizationUserId], references: [organizationUsers.id] }),
  course: one(courses, { fields: [userActivityLogs.courseId], references: [courses.id] }),
  chapter: one(chapters, { fields: [userActivityLogs.chapterId], references: [chapters.id] }),
}));

export const userAnalytics = pgTable("useranalytics", {
  id: serial("id").primaryKey().notNull(),
  organizationUserId: integer("organizationUserId").notNull().references(() => organizationUsers.id, { onDelete: 'cascade' }),
  totalCoursesEnrolled: integer("totalCoursesEnrolled").default(0),
  totalCoursesCompleted: integer("totalCoursesCompleted").default(0),
  totalCertificatesEarned: integer("totalCertificatesEarned").default(0),
  totalVideoHoursWatched: numeric("totalVideoHoursWatched"),
  totalMcqAttempted: integer("totalMcqAttempted").default(0),
  totalComments: integer("totalComments").default(0),
  lastLoginAt: timestamp("lastLoginAt"),
  lastCourseAccessedId: integer("lastCourseAccessedId").references(() => courses.id),
  isActive: boolean("isActive").default(true),
  ...data
});

export const userAnalyticsRelations = relations(userAnalytics, ({one }) => ({
  user: one(organizationUsers, { fields: [userAnalytics.organizationUserId], references: [organizationUsers.id] }),
  lastCourseAccessed: one(courses, { fields: [userAnalytics.lastCourseAccessedId], references: [courses.id] }),
}));

export const organizationAnalytics = pgTable("organizationanalytics", {
  id: serial("id").primaryKey().notNull(),
  organizationId: integer("organizationId").notNull().references(() => organizations.id),
  totalUsers: integer("totalUsers").default(0),
  totalCourses: integer("totalCourses").default(0),
  activeUsersLast30Days: integer("activeUsersLast30Days").default(0),
  enrollmentsThisMonth: integer("enrollmentsThisMonth").default(0),
  avgCourseCompletionRate: numeric("avgCourseCompletionRate"),
  avgRevenuePerUser: numeric("avgRevenuePerUser", { precision: 10, scale: 2 }),
  lastUpdatedAt: timestamp("lastUpdatedAt").defaultNow(),
  ...data
});

export const organizationAnalyticsRelations = relations(organizationAnalytics, ({ one }) => ({
  organization: one(organizations, { fields: [organizationAnalytics.organizationId], references: [organizations.id] }),
}));


export const courseAnalytics = pgTable("courseanalytics", {
  id: serial("id").primaryKey().notNull(),
  courseId: integer("courseId").notNull().unique().references(() => courses.id),
  totalEnrollments: integer("totalEnrollments").default(0),            
  paidEnrollments: integer("paidEnrollments").default(0),              
  freeEnrollments: integer("freeEnrollments").default(0),              
  activeLearnersLast30Days: integer("activeLearnersLast30Days").default(0), 
  totalCertificatesIssued: integer("totalCertificatesIssued").default(0),   
  completionRate: numeric("completionRate"),
  averageWatchTimeMins: integer("averageWatchTimeMins").default(0),    
  totalVideoWatchHours: numeric("totalVideoWatchHours"),
  averageQuizScore: numeric("averageQuizScore"),  
  quizCompletionRate: numeric("quizCompletionRate"),
  averageRating: numeric("averageRating"),     
  reviewCount: integer("reviewCount").default(0),
  totalRevenue: numeric("totalRevenue"),      
  conversionRate: numeric("conversionRate"),   
  discussionMessages: integer("discussionMessages").default(0),       
  commentsPosted: integer("commentsPosted").default(0),              
  projectsSubmitted: integer("projectsSubmitted").default(0),         
  ...data                                                             
});
 
export const organizationUsageMetrics = pgTable('organizationusagemetrics', {
  id: serial('id').primaryKey().notNull(),
  organizationId: integer('organizationId').notNull().references(() => organizations.id, { onDelete: 'cascade' }),
  metricName: orgMetricEnum('metric').notNull(),           
  metricsAt: timestamp('metricsAt').defaultNow(),
  ...data});

export const organizationUsageMetricRelations = relations(organizationUsageMetrics, ({ one }) => ({
  organization: one(organizations, { fields: [organizationUsageMetrics.organizationId], references: [organizations.id] }),
}));
 
 
export const courseMetrics = pgTable('coursemetrics', {
  id: serial('id').primaryKey().notNull(),
  orgUsageMetric: integer('orgusagemetricId').notNull().references(() => organizationUsageMetrics.id, { onDelete: 'cascade' }),
  courseId: integer('courseId').notNull().references(() => courses.id, { onDelete: 'cascade' }),
  subMetricName: text('metricname').notNull(), 
  value: numeric('value').notNull(),
  recordedAt: timestamp('recordedat').defaultNow(),
  ...data,
});
 
export const courseMetricRelations = relations(courseMetrics, ({ one }) => ({
  course: one(courses, { fields: [courseMetrics.courseId], references: [courses.id] }),
}));
 
export const userActivityMetrics = pgTable('useractivitymetrics', {
  id: serial('id').primaryKey().notNull(),
  organizationUserId: integer("organizationUserId").notNull().references(() => organizationUsers.id, { onDelete: 'cascade' }),
  orgUsageMetric: integer('orgusagemetricId').notNull().references(() => organizationUsageMetrics.id, { onDelete: 'cascade' }),
  metricName: text('metricname').notNull(),
  value: integer('value').notNull(),
  recordedAt: timestamp('recordedat').defaultNow(),
  ...data,
});
 
export const userActivityMetricRelations = relations(userActivityMetrics, ({ one }) => ({
  user: one(organizationUsers, { fields: [userActivityMetrics.organizationUserId], references: [organizationUsers.id] }),  
}));
 
 
export const billingMetrics = pgTable("billingmetrics", {
  id: serial("id").primaryKey(),
  organizationId: integer("organizationId").notNull().references(() => organizations.id, { onDelete: 'cascade' }),
  orgUsageMetric: integer('orgusagemetricId').notNull().references(() => organizationUsageMetrics.id, { onDelete: 'cascade' }),
  subMetricName: text("metricname").notNull(),       
  value: integer("value").notNull(),                 
  recordedAt: timestamp("recordedat").defaultNow(),
  ...data
  
});
export const billingMetricRelations = relations(billingMetrics, ({ one }) => ({
  organization: one(organizations, { fields: [billingMetrics.organizationId], references: [organizations.id] }),
}));
 