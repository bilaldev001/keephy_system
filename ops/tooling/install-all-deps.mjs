#!/usr/bin/env node
import { execSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const repoRoot = path.resolve(__dirname, '..', '..');

const stages = [
  { label: 'Frontend', cwd: path.join(repoRoot, 'frontend') },
  { label: 'Backend', cwd: path.join(repoRoot, 'backend') },
];

const install = (stage, index, total) => {
  const pctStart = Math.round((index / total) * 100);
  process.stdout.write(`[${stage.label}] ${pctStart}% starting install...\n`);
  execSync('npm install', { cwd: stage.cwd, stdio: 'inherit' });
  const pctEnd = Math.round(((index + 1) / total) * 100);
  process.stdout.write(`[${stage.label}] ${pctEnd}% completed\n`);
};

try {
  stages.forEach((stage, index) => install(stage, index, stages.length));
  console.log('All workspace dependencies installed successfully.');
} catch (error) {
  console.error('Failed while installing workspace dependencies.');
  process.exitCode = 1;
}
