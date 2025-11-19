const fs = require('fs');
const path = require('path');

const componentsDir = path.join(__dirname, '../frontend/packages/ui-core/src/components');
const cheatComponentsFile = path.join(__dirname, '../frontend/marketing/src/pages/cheatcomponents.tsx');

const ignoreFiles = new Set([
  'index.tsx',
  'index.ts',
  'types.ts',
]);

function toPascalCase(name) {
  return name
    .replace(/\.tsx?$/, '')
    .split(/[-_]/)
    .filter(Boolean)
    .map((segment) => segment.charAt(0).toUpperCase() + segment.slice(1))
    .join('');
}

function collectComponentNames(dir) {
  const names = new Set();

  function walk(currentDir) {
    const entries = fs.readdirSync(currentDir, { withFileTypes: true });
    for (const entry of entries) {
      const entryPath = path.join(currentDir, entry.name);
      if (entry.isDirectory()) {
        walk(entryPath);
        continue;
      }
      if (!entry.name.match(/\.tsx?$/)) {
        continue;
      }
      if (ignoreFiles.has(entry.name)) {
        continue;
      }
      const relative = path.relative(componentsDir, entryPath);
      const componentName = toPascalCase(relative.replace(/\\/g, '-'));
      if (componentName) {
        names.add(componentName);
      }
    }
  }

  walk(dir);
  return names;
}

function collectCheatComponents(file) {
  const source = fs.readFileSync(file, 'utf-8');
  const matches = source.match(/<([A-Z][A-Za-z0-9]+)/g) || [];
  const names = new Set();
  matches.forEach((match) => {
    const name = match.replace('<', '');
    names.add(name);
  });
  return names;
}

const exportedComponents = collectComponentNames(componentsDir);
const cheatComponents = collectCheatComponents(cheatComponentsFile);

const ignoreNames = new Set([
  'Head',
  'Link',
  'dynamic',
  'SiteLayout',
  'Container',
  'Stack',
  'Text',
  'Grid',
  'Heading',
]);

const missing = [];
exportedComponents.forEach((component) => {
  if (ignoreNames.has(component)) {
    return;
  }
  if (!cheatComponents.has(component)) {
    missing.push(component);
  }
});

missing.sort();

console.log('Total exported components found:', exportedComponents.size);
console.log('Components rendered on cheat page:', cheatComponents.size);
console.log('Missing components count:', missing.length);
console.log('--- Missing components ---');
console.log(missing.join(', '));
