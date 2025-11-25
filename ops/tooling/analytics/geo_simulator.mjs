#!/usr/bin/env node
/**
 * Simulate check-in / check-out events with geolocation metadata.
 *
 * Usage:
 *   node scripts/analytics/geo_simulator.mjs --employee <uuid> --tenant <uuid>
 */

import { randomUUID } from 'crypto';

const gatewayUrl = process.env.GATEWAY_URL ?? 'http://localhost:3010';

function parseArgs() {
  const args = process.argv.slice(2);
  const params = {};
  for (let i = 0; i < args.length; i += 2) {
    if (args[i].startsWith('--') && args[i + 1]) {
      params[args[i].slice(2)] = args[i + 1];
    }
  }
  return params;
}

async function sendEvent(type, payload) {
  const response = await fetch(`${gatewayUrl}/ems/attendance/events`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ type, ...payload }),
  });
  if (!response.ok) {
    const body = await response.text();
    throw new Error(`Failed to send ${type} event: ${response.status} ${body}`);
  }
  const data = await response.json();
  console.log(`[geo_simulator] ${type} event recorded: ${data.data.id}`);
}

async function main() {
  const { employee: employeeId, tenant: tenantId } = parseArgs();
  if (!employeeId) {
    console.error('Usage: node geo_simulator.mjs --employee <uuid> [--tenant <uuid>]');
    process.exit(1);
  }

  const attendanceId = randomUUID();
  const basePayload = {
    employeeId,
    tenantId,
    attendanceId,
    location: {
      lat: 12.9716 + Math.random() * 0.01,
      lon: 77.5946 + Math.random() * 0.01,
      accuracy: Math.round(Math.random() * 50),
      source: 'simulator',
    },
    metadata: { device: 'geo-sim-01' },
  };

  await sendEvent('check_in', basePayload);
  setTimeout(async () => {
    await sendEvent('check_out', basePayload);
  }, 1000);
}

main().catch((error) => {
  console.error('[geo_simulator] error', error);
  process.exit(1);
});

