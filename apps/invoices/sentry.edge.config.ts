/*
 * This file configures the initialization of Sentry for edge features (middleware, edge routes, and so on).
 * The config you add here will be used whenever one of the edge features is loaded.
 * Note that this config is unrelated to the Vercel Edge Runtime and is also required when running locally.
 * https://docs.sentry.io/platforms/javascript/guides/nextjs/
 */

import * as Sentry from "@sentry/nextjs";
import pkg from "./package.json";

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  tracesSampleRate: 0.1,
  debug: false,
  environment: process.env.SENTRY_ENVIRONMENT,
  release: `${pkg.name}@${pkg.version}`,
});
