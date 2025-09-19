CREATE TYPE "public"."adminOrganizationRole" AS ENUM('OWNER', 'ORGADMIN', 'MANAGER');--> statement-breakpoint
CREATE TYPE "public"."AdminRole" AS ENUM('OWNER', 'ORGADMIN', 'MANAGER');--> statement-breakpoint
CREATE TYPE "public"."CommentFeedbackValue" AS ENUM('LIKE', 'DISLIKE');--> statement-breakpoint
CREATE TYPE "public"."courseRegistrationStatus" AS ENUM('CREATED', 'REGISTERED');--> statement-breakpoint
CREATE TYPE "public"."projectStatus" AS ENUM('SUBMITTED', 'REVIEWED');--> statement-breakpoint
CREATE TYPE "public"."additionalPriceType" AS ENUM('PERCENT', 'AMOUNT');--> statement-breakpoint
CREATE TYPE "public"."channelChatType" AS ENUM('TEXT', 'FILE');--> statement-breakpoint
CREATE TYPE "public"."CHAPTERTYPE" AS ENUM('VIDEO', 'MCQ', 'RESOURCE', 'WEBINAR', 'VIDEOVDOCIPHER', 'VIDEOTPSTREAMS', 'COMMON', 'PROJECT');--> statement-breakpoint
CREATE TYPE "public"."contentType" AS ENUM('MCQ', 'VIDEO', 'RESOURCE', 'WEBINAR', 'PROJECT');--> statement-breakpoint
CREATE TYPE "public"."couponDiscountType" AS ENUM('PERCENTAGE', 'AMOUNT');--> statement-breakpoint
CREATE TYPE "public"."courseavailability" AS ENUM('TIMEBASED', 'LIFETIME');--> statement-breakpoint
CREATE TYPE "public"."courseLevel" AS ENUM('BEGINNER', 'INTERMEDIATE', 'ADVANCED');--> statement-breakpoint
CREATE TYPE "public"."courseType" AS ENUM(' WEBINAR', 'LIVE', 'COURSE', 'BOOTCAMP');--> statement-breakpoint
CREATE TYPE "public"."enquiryEnum" AS ENUM('STUDENT', 'PROFESSIONAL');--> statement-breakpoint
CREATE TYPE "public"."installmentType" AS ENUM('MONTHLY', 'WEEKLY');--> statement-breakpoint
CREATE TYPE "public"."limitedType" AS ENUM('DATE', 'DAY');--> statement-breakpoint
CREATE TYPE "public"."MCQATTEMPTRESULT" AS ENUM('PASS', 'FAIL');--> statement-breakpoint
CREATE TYPE "public"."MCQATTEMPTSTATUS" AS ENUM('STARTED', 'CLOSED', 'COMPLETED');--> statement-breakpoint
CREATE TYPE "public"."orderStatus" AS ENUM('CREATED', 'SUCCESS');--> statement-breakpoint
CREATE TYPE "public"."ORDERSTATUS" AS ENUM('CREATED', 'SUCCESS');--> statement-breakpoint
CREATE TYPE "public"."orgMetricEnum" AS ENUM('COURSE', 'USER', 'BILLING');--> statement-breakpoint
CREATE TYPE "public"."platformType" AS ENUM('VIMEO', 'VDOCIPHER', 'TPSTREAMS');--> statement-breakpoint
CREATE TYPE "public"."platformFeeStatus" AS ENUM('PENDING', 'BILLED', 'PAID', 'REFUNDED');--> statement-breakpoint
CREATE TYPE "public"."userActivityTypeEnum" AS ENUM('LOGIN', 'LOGOUT', 'WATCHVIDEO', 'COMPLETECHAPTER', 'ATTEMPTMCQ', 'SUBMITPROJECT', 'COMMENT', 'JOINWEBINAR', 'DOWNLOADCERTIFICATE', 'ENROLLCOURSE', 'COMPLETECOURSE', 'REQUESTSUPPORT');--> statement-breakpoint
CREATE TYPE "public"."USERCOURSEACCESSTYPE" AS ENUM('PAID', 'FREE');--> statement-breakpoint
CREATE TYPE "public"."userFriendRequestStatus" AS ENUM('PENDING', 'ACCEPTED', 'REJECTED');--> statement-breakpoint
CREATE TABLE "billingmetrics" (
	"id" serial PRIMARY KEY NOT NULL,
	"organizationId" integer NOT NULL,
	"orgusagemetricId" integer NOT NULL,
	"metricname" text NOT NULL,
	"value" integer NOT NULL,
	"recordedat" timestamp DEFAULT now(),
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "channelChat" (
	"id" serial PRIMARY KEY NOT NULL,
	"channelId" integer NOT NULL,
	"type" "channelChatType" NOT NULL,
	"textValue" text,
	"fileValue" json,
	"replyToId" integer,
	"isPinned" boolean DEFAULT false,
	"isEdited" boolean DEFAULT false,
	"readBy" integer[] DEFAULT '{}',
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "channelChatEditLogs" (
	"id" serial PRIMARY KEY NOT NULL,
	"chatId" integer NOT NULL,
	"previousContent" json,
	"editedBy" integer,
	"editedAt" timestamp DEFAULT now(),
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "channelUserSession" (
	"id" serial PRIMARY KEY NOT NULL,
	"organizationUserId" integer NOT NULL,
	"channelId" integer NOT NULL,
	"deviceType" text,
	"ipAddress" text,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "chapterComments" (
	"id" serial PRIMARY KEY NOT NULL,
	"chapterId" integer NOT NULL,
	"comment" text NOT NULL,
	"organizationUserId" integer NOT NULL,
	"parentId" integer,
	"repliesCount" integer DEFAULT 0,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "Chapter" (
	"id" serial PRIMARY KEY NOT NULL,
	"title" text NOT NULL,
	"sectionId" integer NOT NULL,
	"type" "CHAPTERTYPE" NOT NULL,
	"description" text,
	"attachment" jsonb NOT NULL,
	"sortOrder" integer NOT NULL,
	"mcqContent" integer,
	"videoContent" integer,
	"resourceContent" integer,
	"webinarContent" integer,
	"projectContent" integer,
	"availableFrom" timestamp,
	"availableTill" timestamp,
	"isPublished" boolean DEFAULT false,
	"isActive" boolean DEFAULT true,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true,
	CONSTRAINT "uniqueChapter" UNIQUE("sectionId")
);
--> statement-breakpoint
CREATE TABLE "cities" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"stateId" integer,
	"code" text NOT NULL,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true,
	CONSTRAINT "cities_name_unique" UNIQUE("name"),
	CONSTRAINT "cities_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "commentFeedback" (
	"id" serial PRIMARY KEY NOT NULL,
	"commentId" integer NOT NULL,
	"organizationUserId" integer NOT NULL,
	"feedback" "CommentFeedbackValue" NOT NULL,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "content" (
	"id" serial PRIMARY KEY NOT NULL,
	"type" "contentType" NOT NULL,
	"contentId" integer NOT NULL,
	"isActive" boolean DEFAULT true,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "countries" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"countryCode" text NOT NULL,
	"symbol" text NOT NULL,
	"isDefault" boolean DEFAULT false,
	"region" text,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true,
	CONSTRAINT "countries_name_unique" UNIQUE("name"),
	CONSTRAINT "countries_countryCode_unique" UNIQUE("countryCode"),
	CONSTRAINT "countries_symbol_unique" UNIQUE("symbol")
);
--> statement-breakpoint
CREATE TABLE "couponRedemptions" (
	"id" serial PRIMARY KEY NOT NULL,
	"couponId" integer NOT NULL,
	"organizationUserId" integer NOT NULL,
	"orderId" integer,
	"redeemedAt" timestamp DEFAULT now(),
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "coupons" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"code" text NOT NULL,
	"discountType" "couponDiscountType" DEFAULT 'PERCENTAGE',
	"discount" integer NOT NULL,
	"availableFrom" timestamp,
	"availableTill" timestamp,
	"isDeleted" boolean DEFAULT false,
	"courseIds" integer[],
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true,
	CONSTRAINT "coupons_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "courseAdditionalPricing" (
	"id" serial PRIMARY KEY NOT NULL,
	"pricingId" integer NOT NULL,
	"type" "additionalPriceType" DEFAULT 'PERCENT',
	"label" text NOT NULL,
	"value" integer NOT NULL,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "courseanalytics" (
	"id" serial PRIMARY KEY NOT NULL,
	"courseId" integer NOT NULL,
	"totalEnrollments" integer DEFAULT 0,
	"paidEnrollments" integer DEFAULT 0,
	"freeEnrollments" integer DEFAULT 0,
	"activeLearnersLast30Days" integer DEFAULT 0,
	"totalCertificatesIssued" integer DEFAULT 0,
	"completionRate" numeric,
	"averageWatchTimeMins" integer DEFAULT 0,
	"totalVideoWatchHours" numeric,
	"averageQuizScore" numeric,
	"quizCompletionRate" numeric,
	"averageRating" numeric,
	"reviewCount" integer DEFAULT 0,
	"totalRevenue" numeric,
	"conversionRate" numeric,
	"discussionMessages" integer DEFAULT 0,
	"commentsPosted" integer DEFAULT 0,
	"projectsSubmitted" integer DEFAULT 0,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true,
	CONSTRAINT "courseanalytics_courseId_unique" UNIQUE("courseId")
);
--> statement-breakpoint
CREATE TABLE "courseCategory" (
	"id" serial PRIMARY KEY NOT NULL,
	"organizationId" integer,
	"name" text NOT NULL,
	"description" text,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true,
	CONSTRAINT "courseCategory_name_unique" UNIQUE("name")
);
--> statement-breakpoint
CREATE TABLE "courseCertificateDownloadUsers" (
	"id" serial PRIMARY KEY NOT NULL,
	"organizationUserId" integer NOT NULL,
	"courseId" integer NOT NULL,
	"certificateDownloadUrl" text NOT NULL,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "courseCertificates" (
	"id" serial PRIMARY KEY NOT NULL,
	"courseId" integer NOT NULL,
	"certificateUrl" text NOT NULL,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "courseChannel" (
	"id" serial PRIMARY KEY NOT NULL,
	"courseId" integer,
	"lastMessageAt" timestamp,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "courseChannelUsers" (
	"id" serial PRIMARY KEY NOT NULL,
	"channelId" integer NOT NULL,
	"role" integer,
	"isRestricted" boolean DEFAULT false,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "courseDetails" (
	"id" serial PRIMARY KEY NOT NULL,
	"courseId" integer,
	"courseDuration" text,
	"courseLanguage" text,
	"courseLevel" "courseLevel"[] DEFAULT '{}',
	"courseSubtitleLanguage" text[] DEFAULT '{}',
	"overview" text,
	"includes" json,
	"learningOutcomes" json,
	"curriculum" json,
	"requirements" json,
	"targetAudience" json,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "courseInstructors" (
	"id" serial PRIMARY KEY NOT NULL,
	"courseId" integer,
	"thumbnail" text,
	"name" text,
	"role" text,
	"ratings" text,
	"experience" text,
	"studentCounts" text,
	"description" text,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "coursemetrics" (
	"id" serial PRIMARY KEY NOT NULL,
	"orgusagemetricId" integer NOT NULL,
	"courseId" integer NOT NULL,
	"metricname" text NOT NULL,
	"value" numeric NOT NULL,
	"recordedat" timestamp DEFAULT now(),
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "coursePrebook" (
	"id" serial PRIMARY KEY NOT NULL,
	"courseId" integer NOT NULL,
	"totalPrice" integer NOT NULL,
	"discountAmount" integer NOT NULL,
	"includes" json,
	"isEnabled" boolean DEFAULT true,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "coursePricing" (
	"id" serial PRIMARY KEY NOT NULL,
	"countryId" integer NOT NULL,
	"courseId" integer NOT NULL,
	"totalPrice" integer NOT NULL,
	"taxPercentage" integer,
	"taxDescription" text,
	"discountAmount" integer NOT NULL,
	"includeTaxOnDisplay" boolean DEFAULT true,
	"isInstallment" boolean DEFAULT false,
	"monthlyInstallments" integer,
	"weeklyInstallments" integer,
	"isLimited" boolean DEFAULT false,
	"tillDate" text,
	"tillDays" integer,
	"limitedType" "limitedType",
	"installmentType" "installmentType",
	"isEnabled" boolean DEFAULT true,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "courseProgressMcq" (
	"id" serial PRIMARY KEY NOT NULL,
	"organizationUserId" integer NOT NULL,
	"chapterId" integer NOT NULL,
	"score" integer,
	"attempts" integer DEFAULT 0,
	"lastAttemptedAt" timestamp DEFAULT now(),
	"completed" boolean DEFAULT false,
	"lastAttempted" timestamp DEFAULT now(),
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "courseProgressMcqAttempts" (
	"id" serial PRIMARY KEY NOT NULL,
	"courseProgressMcqId" integer,
	"attemptNo" integer DEFAULT 1 NOT NULL,
	"resultData" json,
	"result" "MCQATTEMPTRESULT",
	"startTime" timestamp with time zone,
	"endTime" timestamp with time zone,
	"attemptStatus" "MCQATTEMPTSTATUS" DEFAULT 'STARTED' NOT NULL,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "courseProgressVideo" (
	"id" serial PRIMARY KEY NOT NULL,
	"organizationUserId" integer NOT NULL,
	"chapterId" integer NOT NULL,
	"hostingPlatform" text NOT NULL,
	"activeDurationInSec" integer DEFAULT 0 NOT NULL,
	"completed" boolean DEFAULT false,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "courseRegistrants" (
	"id" serial PRIMARY KEY NOT NULL,
	"courseId" integer NOT NULL,
	"organizationUserId" integer NOT NULL,
	"registrationDate" timestamp DEFAULT now(),
	"registrationstatus" "courseRegistrationStatus" DEFAULT 'CREATED',
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "courseReviews" (
	"id" serial PRIMARY KEY NOT NULL,
	"courseId" integer,
	"reviewerById" integer,
	"ratings" integer,
	"comments" text,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "courseSplitAmounts" (
	"id" serial PRIMARY KEY NOT NULL,
	"courseId" integer NOT NULL,
	"splitCounts" integer NOT NULL,
	"totalAmount" integer NOT NULL,
	"splitAmounts" json NOT NULL,
	"isEnabled" boolean DEFAULT true,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "courseVersionHistory" (
	"id" serial PRIMARY KEY NOT NULL,
	"version" integer DEFAULT 1 NOT NULL,
	"courseId" integer,
	"createdAt" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "courses" (
	"id" serial PRIMARY KEY NOT NULL,
	"title" text NOT NULL,
	"slug" text,
	"tags" text[] DEFAULT '{}',
	"tagLine" text,
	"languageId" integer,
	"categoryId" integer NOT NULL,
	"description" text NOT NULL,
	"isPaid" boolean DEFAULT true,
	"seoTitle" text,
	"seoDescription" text,
	"seoKeywords" text,
	"courseType" "courseType" DEFAULT 'COURSE',
	"startsOn" timestamp,
	"availability" "courseavailability" DEFAULT 'TIMEBASED',
	"thumbnail" text,
	"vimeoFolderUrl" text,
	"vdocipherFolderId" text,
	"tpstreamsFolderId" text,
	"maxEnrollments" integer,
	"enrollmentCount" integer DEFAULT 0,
	"isPublished" boolean,
	"visibility" text DEFAULT 'PUBLIC',
	"duration" text,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true,
	CONSTRAINT "courses_slug_unique" UNIQUE("slug")
);
--> statement-breakpoint
CREATE TABLE "enquiry" (
	"id" serial PRIMARY KEY NOT NULL,
	"course" integer NOT NULL,
	"name" text NOT NULL,
	"email" text NOT NULL,
	"phone" text NOT NULL,
	"address" text,
	"userType" "enquiryEnum" DEFAULT 'STUDENT' NOT NULL,
	"message" text,
	"batch" text,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "enquiryEnrollmentProffessional" (
	"id" serial PRIMARY KEY NOT NULL,
	"designation" text NOT NULL,
	"officeAddress" text NOT NULL,
	"experience" text NOT NULL,
	"expectations" text NOT NULL,
	"enquiryId" integer NOT NULL,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true,
	CONSTRAINT "enquiryEnrollmentProffessional_enquiryId_unique" UNIQUE("enquiryId")
);
--> statement-breakpoint
CREATE TABLE "enquiryEnrollmentStudents" (
	"id" serial PRIMARY KEY NOT NULL,
	"education" text NOT NULL,
	"passingYear" text NOT NULL,
	"interest" text NOT NULL,
	"commitment" text NOT NULL,
	"dedication" text NOT NULL,
	"expectations" text NOT NULL,
	"laptop" boolean DEFAULT true NOT NULL,
	"courseFee" text NOT NULL,
	"mentorSupport" boolean DEFAULT true NOT NULL,
	"enquiryId" integer NOT NULL,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true,
	CONSTRAINT "enquiryEnrollmentStudents_enquiryId_unique" UNIQUE("enquiryId")
);
--> statement-breakpoint
CREATE TABLE "languages" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"code" text NOT NULL,
	"countryId" integer NOT NULL,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true,
	CONSTRAINT "languages_name_unique" UNIQUE("name"),
	CONSTRAINT "languages_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "liveWebinarInstructors" (
	"id" serial PRIMARY KEY NOT NULL,
	"instructorId" integer,
	"webinarId" integer,
	"isactive" boolean DEFAULT true,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "liveWebinarRegistrants" (
	"id" serial PRIMARY KEY NOT NULL,
	"userId" integer,
	"webinarId" integer,
	"isactive" boolean DEFAULT true,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "live_webinars" (
	"id" serial PRIMARY KEY NOT NULL,
	"platform_id" integer NOT NULL,
	"course_id" integer,
	"starts_on" timestamp NOT NULL,
	"attachment" json[] DEFAULT '{}',
	"thumbnail" text,
	"available_from" timestamp DEFAULT now(),
	"available_till" timestamp DEFAULT now(),
	"is_active" boolean DEFAULT true,
	"is_published" boolean DEFAULT false,
	"webinar_content" json,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "mcqContent" (
	"id" serial PRIMARY KEY NOT NULL,
	"content" jsonb NOT NULL,
	"isActive" boolean DEFAULT true,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "meetWebhookHistory" (
	"id" serial PRIMARY KEY NOT NULL,
	"event" text NOT NULL,
	"data" json NOT NULL,
	"platformUrlId" text,
	"message" text,
	"timestamp" timestamp DEFAULT now(),
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "notificationLog" (
	"id" serial PRIMARY KEY NOT NULL,
	"courseId" integer NOT NULL,
	"templateId" integer NOT NULL,
	"email" text,
	"phone" text,
	"countryCode" text DEFAULT '91',
	"isSuccess" boolean DEFAULT false,
	"errorMessage" text,
	"sentAt" timestamp DEFAULT now(),
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "notificationSchedule" (
	"id" serial PRIMARY KEY NOT NULL,
	"courseId" integer NOT NULL,
	"templateId" integer NOT NULL,
	"triggerDay" integer NOT NULL,
	"timeOfDay" timestamp NOT NULL,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "notificationTemplate" (
	"id" serial PRIMARY KEY NOT NULL,
	"courseId" integer NOT NULL,
	"title" text NOT NULL,
	"subject" text,
	"body" text NOT NULL,
	"whatsappTemplate" text,
	"msgType" text DEFAULT 'text' NOT NULL,
	"mediaUrl" text,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "orderTransactions" (
	"id" serial PRIMARY KEY NOT NULL,
	"orderId" integer NOT NULL,
	"payUTxnid" text,
	"event" text,
	"paymentDetails" json,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "orders" (
	"id" serial PRIMARY KEY NOT NULL,
	"organizationUserId" integer NOT NULL,
	"courseId" integer NOT NULL,
	"amount" numeric(10, 2) NOT NULL,
	"status" boolean DEFAULT true,
	"razorpayOrderId" text,
	"payUTxnid" text,
	"coupon" integer,
	"priceDetails" json,
	"transactionDate" timestamp,
	"paymentMethod" text,
	"gatewayResponse" json,
	"invoiceUrl" text,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer
);
--> statement-breakpoint
CREATE TABLE "organizationanalytics" (
	"id" serial PRIMARY KEY NOT NULL,
	"organizationId" integer NOT NULL,
	"totalUsers" integer DEFAULT 0,
	"totalCourses" integer DEFAULT 0,
	"activeUsersLast30Days" integer DEFAULT 0,
	"enrollmentsThisMonth" integer DEFAULT 0,
	"avgCourseCompletionRate" numeric,
	"avgRevenuePerUser" numeric(10, 2),
	"lastUpdatedAt" timestamp DEFAULT now(),
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "organizationbilling" (
	"id" serial PRIMARY KEY NOT NULL,
	"platformFeesId" integer,
	"organizationId" integer NOT NULL,
	"billingPeriod" text NOT NULL,
	"totalUsers" integer DEFAULT 0,
	"totalCourses" integer DEFAULT 0,
	"invoiceUrl" text,
	"paid" boolean DEFAULT false,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "organizationusagemetrics" (
	"id" serial PRIMARY KEY NOT NULL,
	"organizationId" integer NOT NULL,
	"metric" "orgMetricEnum" NOT NULL,
	"metricsAt" timestamp DEFAULT now(),
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "organizationUsers" (
	"id" serial PRIMARY KEY NOT NULL,
	"userId" integer NOT NULL,
	"roleId" integer NOT NULL,
	"organizationId" integer NOT NULL,
	"isActive" boolean DEFAULT true,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "organizations" (
	"id" serial PRIMARY KEY NOT NULL,
	"parentorganizationId" integer,
	"name" text NOT NULL,
	"domain" text,
	"address_line1" text,
	"address_line2" text,
	"contactDetails" text,
	"address" text,
	"countryId" integer NOT NULL,
	"stateId" integer NOT NULL,
	"cityId" integer NOT NULL,
	"zipCode" text,
	"billingemail" text,
	"supportemail" text,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true,
	CONSTRAINT "organizations_domain_unique" UNIQUE("domain")
);
--> statement-breakpoint
CREATE TABLE "permissions" (
	"id" serial PRIMARY KEY NOT NULL,
	"code" text NOT NULL,
	"description" text,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true,
	CONSTRAINT "permissions_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "platformFees" (
	"id" serial PRIMARY KEY NOT NULL,
	"orderId" integer NOT NULL,
	"feeAmount" numeric(10, 2) NOT NULL,
	"status" boolean DEFAULT true,
	"billedAt" timestamp,
	"paidAt" timestamp,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer
);
--> statement-breakpoint
CREATE TABLE "projectContent" (
	"id" serial PRIMARY KEY NOT NULL,
	"content" jsonb NOT NULL,
	"isActive" boolean DEFAULT true,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "projectSubmissions" (
	"id" serial PRIMARY KEY NOT NULL,
	"chapterId" integer NOT NULL,
	"organizationUserId" integer NOT NULL,
	"content" text,
	"attachment" json[] DEFAULT '{}',
	"projectStatus" "projectStatus" DEFAULT 'SUBMITTED',
	"score" integer,
	"feedback" text,
	"submittedOn" timestamp DEFAULT now(),
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "resetPassword" (
	"id" serial PRIMARY KEY NOT NULL,
	"organizationUserId" integer,
	"uuid" text NOT NULL,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true,
	CONSTRAINT "resetPassword_uuid_unique" UNIQUE("uuid")
);
--> statement-breakpoint
CREATE TABLE "resourceContent" (
	"id" serial PRIMARY KEY NOT NULL,
	"content" jsonb NOT NULL,
	"isActive" boolean DEFAULT true,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "role" (
	"id" serial PRIMARY KEY NOT NULL,
	"code" integer,
	"name" text NOT NULL,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true,
	CONSTRAINT "role_code_unique" UNIQUE("code"),
	CONSTRAINT "role_name_unique" UNIQUE("name")
);
--> statement-breakpoint
CREATE TABLE "rolePermissions" (
	"id" serial PRIMARY KEY NOT NULL,
	"roleId" integer NOT NULL,
	"permissionId" integer NOT NULL,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "scheduleSection" (
	"id" serial PRIMARY KEY NOT NULL,
	"sectionId" integer NOT NULL,
	"scheduleDate" timestamp NOT NULL,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "section" (
	"id" serial PRIMARY KEY NOT NULL,
	"title" text NOT NULL,
	"courseId" integer NOT NULL,
	"sortOrder" integer NOT NULL,
	"allowedChapters" "CHAPTERTYPE" DEFAULT 'COMMON',
	"isPublished" boolean DEFAULT false,
	"isActive" boolean DEFAULT true,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "socketlog" (
	"id" serial PRIMARY KEY NOT NULL,
	"type" text NOT NULL,
	"log" json,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "states" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"countryId" integer,
	"code" text NOT NULL,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true,
	CONSTRAINT "states_name_unique" UNIQUE("name"),
	CONSTRAINT "states_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "tpstreamWebhookHistory" (
	"id" serial PRIMARY KEY NOT NULL,
	"event" text NOT NULL,
	"data" json NOT NULL,
	"platformUrlId" text,
	"message" text,
	"timestamp" timestamp DEFAULT now(),
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "useractivitylogs" (
	"id" serial PRIMARY KEY NOT NULL,
	"organizationUserId" integer NOT NULL,
	"courseId" integer,
	"chapterId" integer,
	"activityType" "userActivityTypeEnum" NOT NULL,
	"activityData" json,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "useractivitymetrics" (
	"id" serial PRIMARY KEY NOT NULL,
	"organizationUserId" integer NOT NULL,
	"orgusagemetricId" integer NOT NULL,
	"metricname" text NOT NULL,
	"value" integer NOT NULL,
	"recordedat" timestamp DEFAULT now(),
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "useranalytics" (
	"id" serial PRIMARY KEY NOT NULL,
	"organizationUserId" integer NOT NULL,
	"totalCoursesEnrolled" integer DEFAULT 0,
	"totalCoursesCompleted" integer DEFAULT 0,
	"totalCertificatesEarned" integer DEFAULT 0,
	"totalVideoHoursWatched" numeric,
	"totalMcqAttempted" integer DEFAULT 0,
	"totalComments" integer DEFAULT 0,
	"lastLoginAt" timestamp,
	"lastCourseAccessedId" integer,
	"isActive" boolean DEFAULT true,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "userCourseAccess" (
	"id" serial PRIMARY KEY NOT NULL,
	"organizationUserId" integer,
	"courseId" integer,
	"type" "USERCOURSEACCESSTYPE" NOT NULL,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true,
	"orderId" integer
);
--> statement-breakpoint
CREATE TABLE "userCourseProgress" (
	"id" serial PRIMARY KEY NOT NULL,
	"organizationUserId" integer,
	"courseId" integer,
	"chapterId" integer,
	"isCurrent" boolean DEFAULT true NOT NULL,
	"isCompleted" boolean DEFAULT false NOT NULL,
	"videoDetailsId" integer,
	"mcqDetailsId" integer,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "userFriendRequests" (
	"id" serial PRIMARY KEY NOT NULL,
	"requestedByUserId" integer NOT NULL,
	"requestedToUserId" integer NOT NULL,
	"status" boolean DEFAULT true,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer
);
--> statement-breakpoint
CREATE TABLE "userOtp" (
	"id" serial PRIMARY KEY NOT NULL,
	"firstname" text NOT NULL,
	"email" text NOT NULL,
	"phone" text NOT NULL,
	"otp" text,
	"status" boolean DEFAULT true,
	"createdat" timestamp DEFAULT now(),
	"expiresat" timestamp NOT NULL,
	CONSTRAINT "userOtp_email_unique" UNIQUE("email")
);
--> statement-breakpoint
CREATE TABLE "user" (
	"id" serial PRIMARY KEY NOT NULL,
	"roleId" integer NOT NULL,
	"firstName" text NOT NULL,
	"lastName" text,
	"email" text NOT NULL,
	"phone" text,
	"password" text,
	"image" text,
	"googleUserId" text,
	"isVerified" boolean DEFAULT false,
	"requestPasswordUpdate" boolean DEFAULT true,
	"languageId" integer,
	"address" text,
	"countryId" integer NOT NULL,
	"stateId" integer,
	"cityId" integer,
	"zipCode" text,
	"isActive" boolean DEFAULT true,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true,
	CONSTRAINT "user_email_unique" UNIQUE("email"),
	CONSTRAINT "user_googleUserId_unique" UNIQUE("googleUserId")
);
--> statement-breakpoint
CREATE TABLE "videoContent" (
	"id" serial PRIMARY KEY NOT NULL,
	"content" jsonb NOT NULL,
	"isActive" boolean DEFAULT true,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "webinarAttendees" (
	"id" serial PRIMARY KEY NOT NULL,
	"webinarId" integer NOT NULL,
	"organizationUserId" integer NOT NULL,
	"joinedat" timestamp DEFAULT now(),
	"leftat" timestamp DEFAULT now(),
	"duration" integer,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "webinarContent" (
	"id" serial PRIMARY KEY NOT NULL,
	"content" jsonb NOT NULL,
	"isActive" boolean DEFAULT true,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "webinarFeedback" (
	"id" serial PRIMARY KEY NOT NULL,
	"organizationUserId" integer NOT NULL,
	"webinarId" integer,
	"rating" integer,
	"comment" text,
	"submittedAt" timestamp DEFAULT now(),
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "webinar_platform" (
	"id" serial PRIMARY KEY NOT NULL,
	"platformType" "platformType" NOT NULL,
	"host_id" integer,
	"password" text NOT NULL,
	"title" text NOT NULL,
	"description" text,
	"url" text NOT NULL,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "webinarRecordings" (
	"id" serial PRIMARY KEY NOT NULL,
	"webinarId" integer NOT NULL,
	"playurl" text NOT NULL,
	"title" text NOT NULL,
	"show" boolean DEFAULT true,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "whatsappOtp" (
	"id" serial PRIMARY KEY NOT NULL,
	"phone" text NOT NULL,
	"otp" text NOT NULL,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE "zoomWebhookHistory" (
	"id" serial PRIMARY KEY NOT NULL,
	"event" text NOT NULL,
	"data" json NOT NULL,
	"platformUrlId" text,
	"message" text,
	"timestamp" timestamp DEFAULT now(),
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now(),
	"createdById" integer,
	"updatedById" integer,
	"status" boolean DEFAULT true
);
--> statement-breakpoint
ALTER TABLE "billingmetrics" ADD CONSTRAINT "billingmetrics_organizationId_organizations_id_fk" FOREIGN KEY ("organizationId") REFERENCES "public"."organizations"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "billingmetrics" ADD CONSTRAINT "billingmetrics_orgusagemetricId_organizationusagemetrics_id_fk" FOREIGN KEY ("orgusagemetricId") REFERENCES "public"."organizationusagemetrics"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "billingmetrics" ADD CONSTRAINT "billingmetrics_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "billingmetrics" ADD CONSTRAINT "billingmetrics_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "channelChat" ADD CONSTRAINT "channelChat_channelId_courseChannel_id_fk" FOREIGN KEY ("channelId") REFERENCES "public"."courseChannel"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "channelChat" ADD CONSTRAINT "channelChat_replyToId_user_id_fk" FOREIGN KEY ("replyToId") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "channelChat" ADD CONSTRAINT "channelChat_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "channelChat" ADD CONSTRAINT "channelChat_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "channelChatEditLogs" ADD CONSTRAINT "channelChatEditLogs_chatId_channelChat_id_fk" FOREIGN KEY ("chatId") REFERENCES "public"."channelChat"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "channelChatEditLogs" ADD CONSTRAINT "channelChatEditLogs_editedBy_user_id_fk" FOREIGN KEY ("editedBy") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "channelUserSession" ADD CONSTRAINT "channelUserSession_organizationUserId_organizationUsers_id_fk" FOREIGN KEY ("organizationUserId") REFERENCES "public"."organizationUsers"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "channelUserSession" ADD CONSTRAINT "channelUserSession_channelId_courseChannel_id_fk" FOREIGN KEY ("channelId") REFERENCES "public"."courseChannel"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "channelUserSession" ADD CONSTRAINT "channelUserSession_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "channelUserSession" ADD CONSTRAINT "channelUserSession_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "chapterComments" ADD CONSTRAINT "chapterComments_chapterId_Chapter_id_fk" FOREIGN KEY ("chapterId") REFERENCES "public"."Chapter"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "chapterComments" ADD CONSTRAINT "chapterComments_organizationUserId_organizationUsers_id_fk" FOREIGN KEY ("organizationUserId") REFERENCES "public"."organizationUsers"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "chapterComments" ADD CONSTRAINT "chapterComments_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "chapterComments" ADD CONSTRAINT "chapterComments_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "Chapter" ADD CONSTRAINT "Chapter_sectionId_section_id_fk" FOREIGN KEY ("sectionId") REFERENCES "public"."section"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "Chapter" ADD CONSTRAINT "Chapter_mcqContent_mcqContent_id_fk" FOREIGN KEY ("mcqContent") REFERENCES "public"."mcqContent"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "Chapter" ADD CONSTRAINT "Chapter_videoContent_videoContent_id_fk" FOREIGN KEY ("videoContent") REFERENCES "public"."videoContent"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "Chapter" ADD CONSTRAINT "Chapter_resourceContent_resourceContent_id_fk" FOREIGN KEY ("resourceContent") REFERENCES "public"."resourceContent"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "Chapter" ADD CONSTRAINT "Chapter_webinarContent_webinarContent_id_fk" FOREIGN KEY ("webinarContent") REFERENCES "public"."webinarContent"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "Chapter" ADD CONSTRAINT "Chapter_projectContent_projectContent_id_fk" FOREIGN KEY ("projectContent") REFERENCES "public"."projectContent"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "Chapter" ADD CONSTRAINT "Chapter_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "Chapter" ADD CONSTRAINT "Chapter_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "cities" ADD CONSTRAINT "cities_stateId_states_id_fk" FOREIGN KEY ("stateId") REFERENCES "public"."states"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "cities" ADD CONSTRAINT "cities_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "cities" ADD CONSTRAINT "cities_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "commentFeedback" ADD CONSTRAINT "commentFeedback_commentId_chapterComments_id_fk" FOREIGN KEY ("commentId") REFERENCES "public"."chapterComments"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "commentFeedback" ADD CONSTRAINT "commentFeedback_organizationUserId_organizationUsers_id_fk" FOREIGN KEY ("organizationUserId") REFERENCES "public"."organizationUsers"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "commentFeedback" ADD CONSTRAINT "commentFeedback_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "commentFeedback" ADD CONSTRAINT "commentFeedback_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "content" ADD CONSTRAINT "content_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "content" ADD CONSTRAINT "content_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "countries" ADD CONSTRAINT "countries_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "countries" ADD CONSTRAINT "countries_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "couponRedemptions" ADD CONSTRAINT "couponRedemptions_couponId_coupons_id_fk" FOREIGN KEY ("couponId") REFERENCES "public"."coupons"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "couponRedemptions" ADD CONSTRAINT "couponRedemptions_organizationUserId_organizationUsers_id_fk" FOREIGN KEY ("organizationUserId") REFERENCES "public"."organizationUsers"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "couponRedemptions" ADD CONSTRAINT "couponRedemptions_orderId_orders_id_fk" FOREIGN KEY ("orderId") REFERENCES "public"."orders"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "couponRedemptions" ADD CONSTRAINT "couponRedemptions_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "couponRedemptions" ADD CONSTRAINT "couponRedemptions_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "coupons" ADD CONSTRAINT "coupons_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "coupons" ADD CONSTRAINT "coupons_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseAdditionalPricing" ADD CONSTRAINT "courseAdditionalPricing_pricingId_coursePricing_id_fk" FOREIGN KEY ("pricingId") REFERENCES "public"."coursePricing"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseAdditionalPricing" ADD CONSTRAINT "courseAdditionalPricing_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseAdditionalPricing" ADD CONSTRAINT "courseAdditionalPricing_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseanalytics" ADD CONSTRAINT "courseanalytics_courseId_courses_id_fk" FOREIGN KEY ("courseId") REFERENCES "public"."courses"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseanalytics" ADD CONSTRAINT "courseanalytics_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseanalytics" ADD CONSTRAINT "courseanalytics_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseCategory" ADD CONSTRAINT "courseCategory_organizationId_organizations_id_fk" FOREIGN KEY ("organizationId") REFERENCES "public"."organizations"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseCategory" ADD CONSTRAINT "courseCategory_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseCategory" ADD CONSTRAINT "courseCategory_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseCertificateDownloadUsers" ADD CONSTRAINT "courseCertificateDownloadUsers_organizationUserId_organizationUsers_id_fk" FOREIGN KEY ("organizationUserId") REFERENCES "public"."organizationUsers"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseCertificateDownloadUsers" ADD CONSTRAINT "courseCertificateDownloadUsers_courseId_courses_id_fk" FOREIGN KEY ("courseId") REFERENCES "public"."courses"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseCertificateDownloadUsers" ADD CONSTRAINT "courseCertificateDownloadUsers_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseCertificateDownloadUsers" ADD CONSTRAINT "courseCertificateDownloadUsers_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseCertificates" ADD CONSTRAINT "courseCertificates_courseId_courses_id_fk" FOREIGN KEY ("courseId") REFERENCES "public"."courses"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseCertificates" ADD CONSTRAINT "courseCertificates_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseCertificates" ADD CONSTRAINT "courseCertificates_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseChannel" ADD CONSTRAINT "courseChannel_courseId_courses_id_fk" FOREIGN KEY ("courseId") REFERENCES "public"."courses"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseChannel" ADD CONSTRAINT "courseChannel_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseChannel" ADD CONSTRAINT "courseChannel_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseChannelUsers" ADD CONSTRAINT "courseChannelUsers_channelId_courseChannel_id_fk" FOREIGN KEY ("channelId") REFERENCES "public"."courseChannel"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseChannelUsers" ADD CONSTRAINT "courseChannelUsers_role_role_id_fk" FOREIGN KEY ("role") REFERENCES "public"."role"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseChannelUsers" ADD CONSTRAINT "courseChannelUsers_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseChannelUsers" ADD CONSTRAINT "courseChannelUsers_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseDetails" ADD CONSTRAINT "courseDetails_courseId_courses_id_fk" FOREIGN KEY ("courseId") REFERENCES "public"."courses"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseDetails" ADD CONSTRAINT "courseDetails_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseDetails" ADD CONSTRAINT "courseDetails_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseInstructors" ADD CONSTRAINT "courseInstructors_courseId_courses_id_fk" FOREIGN KEY ("courseId") REFERENCES "public"."courses"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseInstructors" ADD CONSTRAINT "courseInstructors_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseInstructors" ADD CONSTRAINT "courseInstructors_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "coursemetrics" ADD CONSTRAINT "coursemetrics_orgusagemetricId_organizationusagemetrics_id_fk" FOREIGN KEY ("orgusagemetricId") REFERENCES "public"."organizationusagemetrics"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "coursemetrics" ADD CONSTRAINT "coursemetrics_courseId_courses_id_fk" FOREIGN KEY ("courseId") REFERENCES "public"."courses"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "coursemetrics" ADD CONSTRAINT "coursemetrics_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "coursemetrics" ADD CONSTRAINT "coursemetrics_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "coursePrebook" ADD CONSTRAINT "coursePrebook_courseId_courses_id_fk" FOREIGN KEY ("courseId") REFERENCES "public"."courses"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "coursePrebook" ADD CONSTRAINT "coursePrebook_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "coursePrebook" ADD CONSTRAINT "coursePrebook_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "coursePricing" ADD CONSTRAINT "coursePricing_countryId_countries_id_fk" FOREIGN KEY ("countryId") REFERENCES "public"."countries"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "coursePricing" ADD CONSTRAINT "coursePricing_courseId_courses_id_fk" FOREIGN KEY ("courseId") REFERENCES "public"."courses"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "coursePricing" ADD CONSTRAINT "coursePricing_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "coursePricing" ADD CONSTRAINT "coursePricing_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseProgressMcq" ADD CONSTRAINT "courseProgressMcq_organizationUserId_organizationUsers_id_fk" FOREIGN KEY ("organizationUserId") REFERENCES "public"."organizationUsers"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseProgressMcq" ADD CONSTRAINT "courseProgressMcq_chapterId_Chapter_id_fk" FOREIGN KEY ("chapterId") REFERENCES "public"."Chapter"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseProgressMcq" ADD CONSTRAINT "courseProgressMcq_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseProgressMcq" ADD CONSTRAINT "courseProgressMcq_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseProgressMcqAttempts" ADD CONSTRAINT "courseProgressMcqAttempts_courseProgressMcqId_courseProgressMcq_id_fk" FOREIGN KEY ("courseProgressMcqId") REFERENCES "public"."courseProgressMcq"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseProgressMcqAttempts" ADD CONSTRAINT "courseProgressMcqAttempts_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseProgressMcqAttempts" ADD CONSTRAINT "courseProgressMcqAttempts_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseProgressVideo" ADD CONSTRAINT "courseProgressVideo_organizationUserId_organizationUsers_id_fk" FOREIGN KEY ("organizationUserId") REFERENCES "public"."organizationUsers"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseProgressVideo" ADD CONSTRAINT "courseProgressVideo_chapterId_Chapter_id_fk" FOREIGN KEY ("chapterId") REFERENCES "public"."Chapter"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseProgressVideo" ADD CONSTRAINT "courseProgressVideo_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseProgressVideo" ADD CONSTRAINT "courseProgressVideo_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseRegistrants" ADD CONSTRAINT "courseRegistrants_organizationUserId_organizationUsers_id_fk" FOREIGN KEY ("organizationUserId") REFERENCES "public"."organizationUsers"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseRegistrants" ADD CONSTRAINT "courseRegistrants_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseRegistrants" ADD CONSTRAINT "courseRegistrants_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseReviews" ADD CONSTRAINT "courseReviews_courseId_courses_id_fk" FOREIGN KEY ("courseId") REFERENCES "public"."courses"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseReviews" ADD CONSTRAINT "courseReviews_reviewerById_user_id_fk" FOREIGN KEY ("reviewerById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseReviews" ADD CONSTRAINT "courseReviews_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseReviews" ADD CONSTRAINT "courseReviews_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseSplitAmounts" ADD CONSTRAINT "courseSplitAmounts_courseId_courses_id_fk" FOREIGN KEY ("courseId") REFERENCES "public"."courses"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseSplitAmounts" ADD CONSTRAINT "courseSplitAmounts_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseSplitAmounts" ADD CONSTRAINT "courseSplitAmounts_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courseVersionHistory" ADD CONSTRAINT "courseVersionHistory_courseId_courses_id_fk" FOREIGN KEY ("courseId") REFERENCES "public"."courses"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courses" ADD CONSTRAINT "courses_languageId_languages_id_fk" FOREIGN KEY ("languageId") REFERENCES "public"."languages"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courses" ADD CONSTRAINT "courses_categoryId_courseCategory_id_fk" FOREIGN KEY ("categoryId") REFERENCES "public"."courseCategory"("id") ON DELETE restrict ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courses" ADD CONSTRAINT "courses_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courses" ADD CONSTRAINT "courses_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "enquiry" ADD CONSTRAINT "enquiry_course_courses_id_fk" FOREIGN KEY ("course") REFERENCES "public"."courses"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "enquiry" ADD CONSTRAINT "enquiry_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "enquiry" ADD CONSTRAINT "enquiry_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "enquiryEnrollmentProffessional" ADD CONSTRAINT "enquiryEnrollmentProffessional_enquiryId_enquiry_id_fk" FOREIGN KEY ("enquiryId") REFERENCES "public"."enquiry"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "enquiryEnrollmentProffessional" ADD CONSTRAINT "enquiryEnrollmentProffessional_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "enquiryEnrollmentProffessional" ADD CONSTRAINT "enquiryEnrollmentProffessional_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "enquiryEnrollmentStudents" ADD CONSTRAINT "enquiryEnrollmentStudents_enquiryId_enquiry_id_fk" FOREIGN KEY ("enquiryId") REFERENCES "public"."enquiry"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "enquiryEnrollmentStudents" ADD CONSTRAINT "enquiryEnrollmentStudents_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "enquiryEnrollmentStudents" ADD CONSTRAINT "enquiryEnrollmentStudents_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "languages" ADD CONSTRAINT "languages_countryId_countries_id_fk" FOREIGN KEY ("countryId") REFERENCES "public"."countries"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "languages" ADD CONSTRAINT "languages_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "languages" ADD CONSTRAINT "languages_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "liveWebinarInstructors" ADD CONSTRAINT "liveWebinarInstructors_instructorId_organizationUsers_id_fk" FOREIGN KEY ("instructorId") REFERENCES "public"."organizationUsers"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "liveWebinarInstructors" ADD CONSTRAINT "liveWebinarInstructors_webinarId_live_webinars_id_fk" FOREIGN KEY ("webinarId") REFERENCES "public"."live_webinars"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "liveWebinarInstructors" ADD CONSTRAINT "liveWebinarInstructors_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "liveWebinarInstructors" ADD CONSTRAINT "liveWebinarInstructors_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "liveWebinarRegistrants" ADD CONSTRAINT "liveWebinarRegistrants_userId_organizationUsers_id_fk" FOREIGN KEY ("userId") REFERENCES "public"."organizationUsers"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "liveWebinarRegistrants" ADD CONSTRAINT "liveWebinarRegistrants_webinarId_live_webinars_id_fk" FOREIGN KEY ("webinarId") REFERENCES "public"."live_webinars"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "liveWebinarRegistrants" ADD CONSTRAINT "liveWebinarRegistrants_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "liveWebinarRegistrants" ADD CONSTRAINT "liveWebinarRegistrants_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "live_webinars" ADD CONSTRAINT "live_webinars_platform_id_webinar_platform_id_fk" FOREIGN KEY ("platform_id") REFERENCES "public"."webinar_platform"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "live_webinars" ADD CONSTRAINT "live_webinars_course_id_courses_id_fk" FOREIGN KEY ("course_id") REFERENCES "public"."courses"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "live_webinars" ADD CONSTRAINT "live_webinars_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "live_webinars" ADD CONSTRAINT "live_webinars_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "mcqContent" ADD CONSTRAINT "mcqContent_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "mcqContent" ADD CONSTRAINT "mcqContent_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "meetWebhookHistory" ADD CONSTRAINT "meetWebhookHistory_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "meetWebhookHistory" ADD CONSTRAINT "meetWebhookHistory_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notificationLog" ADD CONSTRAINT "notificationLog_courseId_courses_id_fk" FOREIGN KEY ("courseId") REFERENCES "public"."courses"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notificationLog" ADD CONSTRAINT "notificationLog_templateId_notificationTemplate_id_fk" FOREIGN KEY ("templateId") REFERENCES "public"."notificationTemplate"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notificationLog" ADD CONSTRAINT "notificationLog_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notificationLog" ADD CONSTRAINT "notificationLog_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notificationSchedule" ADD CONSTRAINT "notificationSchedule_courseId_courses_id_fk" FOREIGN KEY ("courseId") REFERENCES "public"."courses"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notificationSchedule" ADD CONSTRAINT "notificationSchedule_templateId_notificationTemplate_id_fk" FOREIGN KEY ("templateId") REFERENCES "public"."notificationTemplate"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notificationSchedule" ADD CONSTRAINT "notificationSchedule_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notificationSchedule" ADD CONSTRAINT "notificationSchedule_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notificationTemplate" ADD CONSTRAINT "notificationTemplate_courseId_courses_id_fk" FOREIGN KEY ("courseId") REFERENCES "public"."courses"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notificationTemplate" ADD CONSTRAINT "notificationTemplate_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notificationTemplate" ADD CONSTRAINT "notificationTemplate_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "orderTransactions" ADD CONSTRAINT "orderTransactions_orderId_orders_id_fk" FOREIGN KEY ("orderId") REFERENCES "public"."orders"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "orderTransactions" ADD CONSTRAINT "orderTransactions_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "orderTransactions" ADD CONSTRAINT "orderTransactions_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "orders" ADD CONSTRAINT "orders_organizationUserId_organizationUsers_id_fk" FOREIGN KEY ("organizationUserId") REFERENCES "public"."organizationUsers"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "orders" ADD CONSTRAINT "orders_courseId_courses_id_fk" FOREIGN KEY ("courseId") REFERENCES "public"."courses"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "orders" ADD CONSTRAINT "orders_coupon_coupons_id_fk" FOREIGN KEY ("coupon") REFERENCES "public"."coupons"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "orders" ADD CONSTRAINT "orders_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "orders" ADD CONSTRAINT "orders_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "organizationanalytics" ADD CONSTRAINT "organizationanalytics_organizationId_organizations_id_fk" FOREIGN KEY ("organizationId") REFERENCES "public"."organizations"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "organizationanalytics" ADD CONSTRAINT "organizationanalytics_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "organizationanalytics" ADD CONSTRAINT "organizationanalytics_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "organizationbilling" ADD CONSTRAINT "organizationbilling_platformFeesId_platformFees_id_fk" FOREIGN KEY ("platformFeesId") REFERENCES "public"."platformFees"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "organizationbilling" ADD CONSTRAINT "organizationbilling_organizationId_organizations_id_fk" FOREIGN KEY ("organizationId") REFERENCES "public"."organizations"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "organizationbilling" ADD CONSTRAINT "organizationbilling_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "organizationbilling" ADD CONSTRAINT "organizationbilling_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "organizationusagemetrics" ADD CONSTRAINT "organizationusagemetrics_organizationId_organizations_id_fk" FOREIGN KEY ("organizationId") REFERENCES "public"."organizations"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "organizationusagemetrics" ADD CONSTRAINT "organizationusagemetrics_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "organizationusagemetrics" ADD CONSTRAINT "organizationusagemetrics_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "organizationUsers" ADD CONSTRAINT "organizationUsers_userId_user_id_fk" FOREIGN KEY ("userId") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "organizationUsers" ADD CONSTRAINT "organizationUsers_roleId_role_id_fk" FOREIGN KEY ("roleId") REFERENCES "public"."role"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "organizationUsers" ADD CONSTRAINT "organizationUsers_organizationId_organizations_id_fk" FOREIGN KEY ("organizationId") REFERENCES "public"."organizations"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "organizationUsers" ADD CONSTRAINT "organizationUsers_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "organizationUsers" ADD CONSTRAINT "organizationUsers_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "organizations" ADD CONSTRAINT "organizations_parentorganizationId_organizations_id_fk" FOREIGN KEY ("parentorganizationId") REFERENCES "public"."organizations"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "organizations" ADD CONSTRAINT "organizations_countryId_countries_id_fk" FOREIGN KEY ("countryId") REFERENCES "public"."countries"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "organizations" ADD CONSTRAINT "organizations_stateId_states_id_fk" FOREIGN KEY ("stateId") REFERENCES "public"."states"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "organizations" ADD CONSTRAINT "organizations_cityId_cities_id_fk" FOREIGN KEY ("cityId") REFERENCES "public"."cities"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "organizations" ADD CONSTRAINT "organizations_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "organizations" ADD CONSTRAINT "organizations_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "permissions" ADD CONSTRAINT "permissions_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "permissions" ADD CONSTRAINT "permissions_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "platformFees" ADD CONSTRAINT "platformFees_orderId_orders_id_fk" FOREIGN KEY ("orderId") REFERENCES "public"."orders"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "platformFees" ADD CONSTRAINT "platformFees_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "platformFees" ADD CONSTRAINT "platformFees_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "projectContent" ADD CONSTRAINT "projectContent_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "projectContent" ADD CONSTRAINT "projectContent_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "projectSubmissions" ADD CONSTRAINT "projectSubmissions_organizationUserId_organizationUsers_id_fk" FOREIGN KEY ("organizationUserId") REFERENCES "public"."organizationUsers"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "projectSubmissions" ADD CONSTRAINT "projectSubmissions_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "projectSubmissions" ADD CONSTRAINT "projectSubmissions_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "resetPassword" ADD CONSTRAINT "resetPassword_organizationUserId_organizationUsers_id_fk" FOREIGN KEY ("organizationUserId") REFERENCES "public"."organizationUsers"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "resetPassword" ADD CONSTRAINT "resetPassword_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "resetPassword" ADD CONSTRAINT "resetPassword_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "resourceContent" ADD CONSTRAINT "resourceContent_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "resourceContent" ADD CONSTRAINT "resourceContent_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "role" ADD CONSTRAINT "role_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "role" ADD CONSTRAINT "role_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "rolePermissions" ADD CONSTRAINT "rolePermissions_roleId_role_id_fk" FOREIGN KEY ("roleId") REFERENCES "public"."role"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "rolePermissions" ADD CONSTRAINT "rolePermissions_permissionId_permissions_id_fk" FOREIGN KEY ("permissionId") REFERENCES "public"."permissions"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "rolePermissions" ADD CONSTRAINT "rolePermissions_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "rolePermissions" ADD CONSTRAINT "rolePermissions_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "scheduleSection" ADD CONSTRAINT "scheduleSection_sectionId_section_id_fk" FOREIGN KEY ("sectionId") REFERENCES "public"."section"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "scheduleSection" ADD CONSTRAINT "scheduleSection_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "scheduleSection" ADD CONSTRAINT "scheduleSection_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "section" ADD CONSTRAINT "section_courseId_courses_id_fk" FOREIGN KEY ("courseId") REFERENCES "public"."courses"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "section" ADD CONSTRAINT "section_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "section" ADD CONSTRAINT "section_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "socketlog" ADD CONSTRAINT "socketlog_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "socketlog" ADD CONSTRAINT "socketlog_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "states" ADD CONSTRAINT "states_countryId_countries_id_fk" FOREIGN KEY ("countryId") REFERENCES "public"."countries"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "states" ADD CONSTRAINT "states_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "states" ADD CONSTRAINT "states_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tpstreamWebhookHistory" ADD CONSTRAINT "tpstreamWebhookHistory_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "tpstreamWebhookHistory" ADD CONSTRAINT "tpstreamWebhookHistory_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "useractivitylogs" ADD CONSTRAINT "useractivitylogs_organizationUserId_organizationUsers_id_fk" FOREIGN KEY ("organizationUserId") REFERENCES "public"."organizationUsers"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "useractivitylogs" ADD CONSTRAINT "useractivitylogs_courseId_courses_id_fk" FOREIGN KEY ("courseId") REFERENCES "public"."courses"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "useractivitylogs" ADD CONSTRAINT "useractivitylogs_chapterId_Chapter_id_fk" FOREIGN KEY ("chapterId") REFERENCES "public"."Chapter"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "useractivitylogs" ADD CONSTRAINT "useractivitylogs_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "useractivitylogs" ADD CONSTRAINT "useractivitylogs_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "useractivitymetrics" ADD CONSTRAINT "useractivitymetrics_organizationUserId_organizationUsers_id_fk" FOREIGN KEY ("organizationUserId") REFERENCES "public"."organizationUsers"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "useractivitymetrics" ADD CONSTRAINT "useractivitymetrics_orgusagemetricId_organizationusagemetrics_id_fk" FOREIGN KEY ("orgusagemetricId") REFERENCES "public"."organizationusagemetrics"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "useractivitymetrics" ADD CONSTRAINT "useractivitymetrics_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "useractivitymetrics" ADD CONSTRAINT "useractivitymetrics_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "useranalytics" ADD CONSTRAINT "useranalytics_organizationUserId_organizationUsers_id_fk" FOREIGN KEY ("organizationUserId") REFERENCES "public"."organizationUsers"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "useranalytics" ADD CONSTRAINT "useranalytics_lastCourseAccessedId_courses_id_fk" FOREIGN KEY ("lastCourseAccessedId") REFERENCES "public"."courses"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "useranalytics" ADD CONSTRAINT "useranalytics_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "useranalytics" ADD CONSTRAINT "useranalytics_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "userCourseAccess" ADD CONSTRAINT "userCourseAccess_organizationUserId_organizationUsers_id_fk" FOREIGN KEY ("organizationUserId") REFERENCES "public"."organizationUsers"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "userCourseAccess" ADD CONSTRAINT "userCourseAccess_courseId_courses_id_fk" FOREIGN KEY ("courseId") REFERENCES "public"."courses"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "userCourseAccess" ADD CONSTRAINT "userCourseAccess_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "userCourseAccess" ADD CONSTRAINT "userCourseAccess_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "userCourseAccess" ADD CONSTRAINT "userCourseAccess_orderId_orders_id_fk" FOREIGN KEY ("orderId") REFERENCES "public"."orders"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "userCourseProgress" ADD CONSTRAINT "userCourseProgress_organizationUserId_organizationUsers_id_fk" FOREIGN KEY ("organizationUserId") REFERENCES "public"."organizationUsers"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "userCourseProgress" ADD CONSTRAINT "userCourseProgress_courseId_courses_id_fk" FOREIGN KEY ("courseId") REFERENCES "public"."courses"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "userCourseProgress" ADD CONSTRAINT "userCourseProgress_chapterId_Chapter_id_fk" FOREIGN KEY ("chapterId") REFERENCES "public"."Chapter"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "userCourseProgress" ADD CONSTRAINT "userCourseProgress_videoDetailsId_courseProgressVideo_id_fk" FOREIGN KEY ("videoDetailsId") REFERENCES "public"."courseProgressVideo"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "userCourseProgress" ADD CONSTRAINT "userCourseProgress_mcqDetailsId_courseProgressMcq_id_fk" FOREIGN KEY ("mcqDetailsId") REFERENCES "public"."courseProgressMcq"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "userCourseProgress" ADD CONSTRAINT "userCourseProgress_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "userCourseProgress" ADD CONSTRAINT "userCourseProgress_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "userFriendRequests" ADD CONSTRAINT "userFriendRequests_requestedByUserId_organizationUsers_id_fk" FOREIGN KEY ("requestedByUserId") REFERENCES "public"."organizationUsers"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "userFriendRequests" ADD CONSTRAINT "userFriendRequests_requestedToUserId_organizationUsers_id_fk" FOREIGN KEY ("requestedToUserId") REFERENCES "public"."organizationUsers"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "userFriendRequests" ADD CONSTRAINT "userFriendRequests_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "userFriendRequests" ADD CONSTRAINT "userFriendRequests_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user" ADD CONSTRAINT "user_roleId_role_id_fk" FOREIGN KEY ("roleId") REFERENCES "public"."role"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user" ADD CONSTRAINT "user_languageId_languages_id_fk" FOREIGN KEY ("languageId") REFERENCES "public"."languages"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user" ADD CONSTRAINT "user_countryId_countries_id_fk" FOREIGN KEY ("countryId") REFERENCES "public"."countries"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user" ADD CONSTRAINT "user_stateId_states_id_fk" FOREIGN KEY ("stateId") REFERENCES "public"."states"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user" ADD CONSTRAINT "user_cityId_cities_id_fk" FOREIGN KEY ("cityId") REFERENCES "public"."cities"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user" ADD CONSTRAINT "user_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user" ADD CONSTRAINT "user_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "videoContent" ADD CONSTRAINT "videoContent_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "videoContent" ADD CONSTRAINT "videoContent_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinarAttendees" ADD CONSTRAINT "webinarAttendees_webinarId_live_webinars_id_fk" FOREIGN KEY ("webinarId") REFERENCES "public"."live_webinars"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinarAttendees" ADD CONSTRAINT "webinarAttendees_organizationUserId_organizationUsers_id_fk" FOREIGN KEY ("organizationUserId") REFERENCES "public"."organizationUsers"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinarAttendees" ADD CONSTRAINT "webinarAttendees_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinarAttendees" ADD CONSTRAINT "webinarAttendees_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinarContent" ADD CONSTRAINT "webinarContent_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinarContent" ADD CONSTRAINT "webinarContent_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinarFeedback" ADD CONSTRAINT "webinarFeedback_organizationUserId_organizationUsers_id_fk" FOREIGN KEY ("organizationUserId") REFERENCES "public"."organizationUsers"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinarFeedback" ADD CONSTRAINT "webinarFeedback_webinarId_live_webinars_id_fk" FOREIGN KEY ("webinarId") REFERENCES "public"."live_webinars"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinarFeedback" ADD CONSTRAINT "webinarFeedback_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinarFeedback" ADD CONSTRAINT "webinarFeedback_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinar_platform" ADD CONSTRAINT "webinar_platform_host_id_organizationUsers_id_fk" FOREIGN KEY ("host_id") REFERENCES "public"."organizationUsers"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinar_platform" ADD CONSTRAINT "webinar_platform_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinar_platform" ADD CONSTRAINT "webinar_platform_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinarRecordings" ADD CONSTRAINT "webinarRecordings_webinarId_live_webinars_id_fk" FOREIGN KEY ("webinarId") REFERENCES "public"."live_webinars"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinarRecordings" ADD CONSTRAINT "webinarRecordings_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinarRecordings" ADD CONSTRAINT "webinarRecordings_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "whatsappOtp" ADD CONSTRAINT "whatsappOtp_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "whatsappOtp" ADD CONSTRAINT "whatsappOtp_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "zoomWebhookHistory" ADD CONSTRAINT "zoomWebhookHistory_createdById_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "zoomWebhookHistory" ADD CONSTRAINT "zoomWebhookHistory_updatedById_user_id_fk" FOREIGN KEY ("updatedById") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "coursedetailsindex" ON "courseReviews" USING btree ("courseId","reviewerById");--> statement-breakpoint
CREATE INDEX "courseindex" ON "courses" USING btree ("categoryId","languageId");--> statement-breakpoint
CREATE INDEX "emailIdx" ON "enquiry" USING btree ("email");--> statement-breakpoint
CREATE INDEX "phoneIdx" ON "enquiry" USING btree ("phone");--> statement-breakpoint
CREATE INDEX "courseIdx" ON "enquiry" USING btree ("course");