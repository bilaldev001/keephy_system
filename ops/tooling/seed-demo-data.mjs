#!/usr/bin/env node
/**
 * Lightweight seed script to hydrate demo data for sprint showcases.
 *
 * Usage:
 *   node ops/tooling/seed-demo-data.mjs
 *
 * Environment variables:
 *   SEED_GATEWAY_URL - defaults to http://localhost:3010
 *   SEED_HRMS_URL    - defaults to SEED_GATEWAY_URL
 *   SEED_TENANT_ID   - defaults to demo tenant
 *   SEED_BEARER_TOKEN - defaults to "seed-token"
 */

const gatewayUrl = process.env.SEED_GATEWAY_URL ?? 'http://localhost:3010';
const hrmsUrl = process.env.SEED_HRMS_URL ?? gatewayUrl;
const demoTenantId = process.env.SEED_TENANT_ID ?? '11111111-2222-3333-4444-555555555555';
const seedBearerToken = process.env.SEED_BEARER_TOKEN ?? 'seed-token';

async function request(url, options = {}) {
  const response = await fetch(url, {
    headers: {
      'Content-Type': 'application/json',
      'x-tenant-id': demoTenantId,
      Authorization: `Bearer ${seedBearerToken}`,
      ...(options.headers ?? {}),
    },
    ...options,
  });
  if (!response.ok) {
    const body = await response.text();
    throw new Error(`Request failed ${response.status}: ${body}`);
  }
  if (response.status === 204) {
    return null;
  }
  return response.json();
}

async function seedPayrollConfig() {
  const payload = await request(`${gatewayUrl}/payroll/config`);
  const configs = payload?.data ?? [];
  if (!configs.length) {
    console.warn('[seed] No payroll configs found. Start the API first.');
    return;
  }

  const [config] = configs;
  const updated = await request(`${gatewayUrl}/payroll/config/${config.id}`, {
    method: 'PUT',
    body: JSON.stringify({
      label: 'Sprint Demo Baseline',
      paySchedule: { ...config.paySchedule, payoutDay: 28 },
      statutory: { ...config.statutory, professionalTaxSlab: 'STATE-KA' },
    }),
  });

  console.log('[seed] Payroll configuration updated:', updated?.data?.label ?? config.label);
}

async function previewPayrollRuns() {
  const payload = await request(`${gatewayUrl}/payroll/processing`);
  const runs = payload?.data ?? [];
  console.log(`[seed] Payroll runs: ${runs.length}`);
  runs.slice(0, 2).forEach((run) => {
    console.log(`  - ${run.periodStart} to ${run.periodEnd} (${run.status})`);
  });
}

async function previewPayrollValidation() {
  const payload = await request(`${gatewayUrl}/payroll/validation`);
  const issues = payload?.data ?? [];
  console.log(`[seed] Payroll validation issues: ${issues.length}`);
  issues.slice(0, 2).forEach((issue) => {
    console.log(`  - ${issue.severity} ${issue.category}: ${issue.message}`);
  });
}

async function previewPayrollOutsourcing() {
  const payload = await request(`${gatewayUrl}/payroll/outsourcing?tenantId=${demoTenantId}`);
  const rows = payload?.data ?? [];
  console.log(`[seed] Payroll outsourcing runs: ${rows.length}`);
  rows.slice(0, 2).forEach((row) => {
    console.log(`  - ${row.name} (${row.status}) vendor=${row.vendor}`);
  });
}

async function previewAnnouncements() {
  const payload = await request(`${hrmsUrl}/hrms/announcements`);
  const announcements = payload?.data ?? [];
  console.log(`[seed] Announcements available: ${announcements.length}`);
  announcements.slice(0, 2).forEach((item) => {
    console.log(`  - ${item.title} (${item.category})`);
  });
}

async function previewChecklists() {
  const payload = await request(`${gatewayUrl}/onboarding/checklists`);
  const checklists = payload?.data ?? [];
  console.log(`[seed] Onboarding checklists: ${checklists.length}`);
  checklists.slice(0, 2).forEach((item) => {
    console.log(`  - ${item.title} (${item.status})`);
  });
}

async function previewFbmsBusinesses() {
  const payload = await request(`${gatewayUrl}/fbms/businesses?limit=5`);
  const rows = Array.isArray(payload?.data) ? payload.data : Array.isArray(payload) ? payload : [];
  console.log(`[seed] FBMS businesses: ${rows.length}`);
  rows.slice(0, 3).forEach((business) => {
    console.log(`  - ${business.name} (${business.status})`);
  });
}

async function previewScmSuppliers() {
  const payload = await request(`${gatewayUrl}/scm/suppliers?tenantId=11111111-2222-3333-4444-555555555555&limit=5`);
  const data = payload?.data ?? [];
  console.log(`[seed] SCM suppliers: ${data.length}`);
  data.slice(0, 3).forEach((supplier) => {
    console.log(`  - ${supplier.name} (${supplier.category}) score=${supplier.reliabilityScore}`);
  });
}

async function previewInventoryItems() {
  const tenantId = '11111111-2222-3333-4444-555555555555';
  const payload = await request(`${gatewayUrl}/inventory/items?tenantId=${tenantId}&limit=5`);
  const result = payload?.data ?? payload;
  if (!result) {
    console.log('[seed] Inventory items: 0');
    return;
  }
  const rows = Array.isArray(result.data) ? result.data : Array.isArray(result) ? result : [];
  console.log(`[seed] Inventory items: ${rows.length}`);
  rows.slice(0, 3).forEach((item) => {
    console.log(`  - ${item.name} (${item.quantity} ${item.unit ?? 'units'})`);
  });
}

async function previewCrmOpportunities() {
  const tenantId = '11111111-2222-3333-4444-555555555555';
  const payload = await request(`${gatewayUrl}/crm/opportunities?tenantId=${tenantId}&limit=5`);
  const result = payload?.data ?? payload;
  const rows = Array.isArray(result?.data) ? result.data : Array.isArray(result) ? result : [];
  console.log(`[seed] CRM opportunities: ${rows.length}`);
  rows.slice(0, 3).forEach((opp) => {
    console.log(`  - ${opp.name} (${opp.stage}) $${opp.value}`);
  });
}

async function previewClockEvents() {
  const payload = await request(`${gatewayUrl}/ems/attendance/events`);
  const events = payload?.data ?? [];
  console.log(`[seed] Clock geo events: ${events.length}`);
  events.slice(0, 1).forEach((item) => {
    console.log(`  - ${item.type} @ ${item.location?.lat?.toFixed?.(4)},${item.location?.lon?.toFixed?.(4)}`);
  });
}

async function previewSupportTickets() {
  const payload = await request(`${gatewayUrl}/support/tickets?tenantId=${demoTenantId}&limit=5`);
  const result = payload?.data ?? payload;
  const rows = Array.isArray(result?.data) ? result.data : Array.isArray(result) ? result : [];
  console.log(`[seed] Support tickets: ${rows.length}`);
  rows.slice(0, 3).forEach((ticket) => {
    console.log(`  - ${ticket.title} (${ticket.status}/${ticket.priority})`);
  });
}

async function previewComplianceAssessments() {
  const payload = await request(`${gatewayUrl}/compliance/compliance-assessments?tenantId=${demoTenantId}&limit=5`);
  const result = payload?.data ?? payload;
  const rows = Array.isArray(result?.data) ? result.data : Array.isArray(result) ? result : [];
  console.log(`[seed] Compliance assessments: ${rows.length}`);
  rows.slice(0, 3).forEach((assessment) => {
    console.log(`  - ${assessment.title} (${assessment.framework}/${assessment.status})`);
  });
}

async function previewAnalyticsMetrics() {
  const payload = await request(`${gatewayUrl}/analytics/performance-metrics?tenantId=${demoTenantId}&limit=5`);
  const result = payload?.data ?? payload;
  const rows = Array.isArray(result?.data) ? result.data : Array.isArray(result) ? result : [];
  console.log(`[seed] Analytics metrics: ${rows.length}`);
  rows.slice(0, 3).forEach((metric) => {
    console.log(`  - ${metric.metric} ${metric.value} (${metric.trend})`);
  });
}

async function previewEmsAttendance() {
  const payload = await request(`${gatewayUrl}/ems/attendance?tenantId=${demoTenantId}&limit=5`);
  const rows = Array.isArray(payload) ? payload : payload?.data ?? [];
  console.log(`[seed] EMS attendance events: ${rows.length}`);
  rows.slice(0, 3).forEach((event) => {
    console.log(`  - ${event.employeeId} ${event.type} @ ${event.timestamp}`);
  });
}

async function previewBillingInvoices() {
  const payload = await request(`${gatewayUrl}/billing/invoices?tenantId=${demoTenantId}&limit=5`);
  const result = payload?.data ?? payload;
  const rows = Array.isArray(result?.data) ? result.data : Array.isArray(result) ? result : [];
  console.log(`[seed] Billing invoices: ${rows.length}`);
  rows.slice(0, 3).forEach((invoice) => {
    console.log(`  - ${invoice.number} ${invoice.status} $${invoice.total}`);
  });
}

async function safeRun(label, fn) {
  try {
    await fn();
  } catch (error) {
    console.error(`[seed] ${label} failed: ${error.message}`);
  }
}

async function main() {
  await safeRun('seed payroll config', seedPayrollConfig);
  await safeRun('payroll runs', previewPayrollRuns);
  await safeRun('payroll validation', previewPayrollValidation);
  await safeRun('payroll outsourcing', previewPayrollOutsourcing);
  await safeRun('announcements', previewAnnouncements);
  await safeRun('onboarding checklists', previewChecklists);
  await safeRun('fbms businesses', previewFbmsBusinesses);
  await safeRun('scm suppliers', previewScmSuppliers);
  await safeRun('inventory items', previewInventoryItems);
  await safeRun('crm opportunities', previewCrmOpportunities);
  await safeRun('support tickets', previewSupportTickets);
  await safeRun('compliance assessments', previewComplianceAssessments);
  await safeRun('analytics metrics', previewAnalyticsMetrics);
  await safeRun('ems attendance', previewEmsAttendance);
  await safeRun('billing invoices', previewBillingInvoices);
  await safeRun('clock events', previewClockEvents);
  console.log('[seed] Demo data ready.');
}

main();

