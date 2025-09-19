ALTER TABLE "content" RENAME COLUMN "contentId" TO "contentCode";--> statement-breakpoint
ALTER TABLE "mcqContent" RENAME COLUMN "content" TO "contentId";--> statement-breakpoint
ALTER TABLE "projectContent" RENAME COLUMN "content" TO "contentId";--> statement-breakpoint
ALTER TABLE "resourceContent" RENAME COLUMN "content" TO "contentId";--> statement-breakpoint
ALTER TABLE "videoContent" RENAME COLUMN "content" TO "contentId";--> statement-breakpoint
ALTER TABLE "webinarContent" RENAME COLUMN "content" TO "contentId";--> statement-breakpoint
ALTER TABLE "Chapter" ALTER COLUMN "attachment" SET DATA TYPE text;--> statement-breakpoint
ALTER TABLE "content" ADD COLUMN "content" text NOT NULL;--> statement-breakpoint
ALTER TABLE "mcqContent" ADD CONSTRAINT "mcqContent_contentId_content_id_fk" FOREIGN KEY ("contentId") REFERENCES "public"."content"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "projectContent" ADD CONSTRAINT "projectContent_contentId_content_id_fk" FOREIGN KEY ("contentId") REFERENCES "public"."content"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "resourceContent" ADD CONSTRAINT "resourceContent_contentId_content_id_fk" FOREIGN KEY ("contentId") REFERENCES "public"."content"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "videoContent" ADD CONSTRAINT "videoContent_contentId_content_id_fk" FOREIGN KEY ("contentId") REFERENCES "public"."content"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinarContent" ADD CONSTRAINT "webinarContent_contentId_content_id_fk" FOREIGN KEY ("contentId") REFERENCES "public"."content"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "organizations" DROP COLUMN "address";