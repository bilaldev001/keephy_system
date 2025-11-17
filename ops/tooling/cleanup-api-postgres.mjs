#!/usr/bin/env node

/**
 * ⚠️  DEPRECATED: api-postgres has been decommissioned
 * 
 * This script is kept for historical reference only.
 * The api-postgres monolith has been fully decommissioned.
 * 
 * All modules have been migrated to microservices:
 * - Identity → identity-service
 * - Access/RBAC → access-service
 * - Media → media-service
 * - Contacts → contacts-service
 * - Admin → admin-service
 * - AI → ai-service
 * - Mobile → mobile-service
 * - Payments → billing-service
 * - Facilities → facilities-service
 * - Analytics → analytics-service
 * - Security → compliance-service
 * - And many more...
 * 
 * See: backend/docs/api-postgres-decommission-summary.md
 */

console.log('⚠️  api-postgres has been decommissioned.');
console.log('   All modules have been migrated to microservices.');
console.log('   See: backend/docs/api-postgres-decommission-summary.md');
process.exit(0);
