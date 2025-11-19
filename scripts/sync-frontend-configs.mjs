#!/usr/bin/env node

/**
 * Sync Tailwind and theme configurations across all frontend apps
 * Ensures mobile-first approach and consistent theme setup
 */

import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const ROOT_DIR = path.resolve(__dirname, '..');
const FRONTEND_DIR = path.join(ROOT_DIR, 'frontend');

const TAILWIND_CONFIG_TEMPLATE = `const { fontFamily } = require('tailwindcss/defaultTheme');

/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: ['class'],
  content: [
    './src/**/*.{ts,tsx}',
    './node_modules/@keephy/ui-core/dist/**/*.js',
    './node_modules/@keephy/ui-core/src/**/*.{ts,tsx}',
  ],
  theme: {
    // Mobile-first breakpoints (default is mobile-first)
    screens: {
      xs: '475px',
      sm: '640px',   // Mobile landscape
      md: '768px',   // Tablet
      lg: '1024px',  // Desktop
      xl: '1280px',  // Large desktop
      '2xl': '1536px', // Extra large
    },
    extend: {
      colors: {
        border: 'hsl(var(--border))',
        input: 'hsl(var(--input))',
        ring: 'hsl(var(--ring))',
        background: 'hsl(var(--background))',
        foreground: 'hsl(var(--foreground))',
        primary: {
          DEFAULT: 'hsl(var(--primary))',
          foreground: 'hsl(var(--primary-foreground))',
        },
        secondary: {
          DEFAULT: 'hsl(var(--secondary))',
          foreground: 'hsl(var(--secondary-foreground))',
        },
        destructive: {
          DEFAULT: 'hsl(var(--destructive))',
          foreground: 'hsl(var(--destructive-foreground))',
        },
        muted: {
          DEFAULT: 'hsl(var(--muted))',
          foreground: 'hsl(var(--muted-foreground))',
        },
        accent: {
          DEFAULT: 'hsl(var(--accent))',
          foreground: 'hsl(var(--accent-foreground))',
        },
        card: {
          DEFAULT: 'hsl(var(--card))',
          foreground: 'hsl(var(--card-foreground))',
        },
        popover: {
          DEFAULT: 'hsl(var(--popover))',
          foreground: 'hsl(var(--popover-foreground))',
        },
      },
      borderRadius: {
        lg: '0.5rem',
        md: 'calc(0.5rem - 2px)',
        sm: 'calc(0.5rem - 4px)',
      },
      fontFamily: {
        sans: ['Inter', ...fontFamily.sans],
      },
      // Mobile-first spacing utilities
      spacing: {
        'gutter': '1.5rem',
        'section': '2.5rem',
      },
    },
  },
  plugins: [],
};
`;

const GLOBALS_CSS_TEMPLATE = `@tailwind base;
@tailwind components;
@tailwind utilities;

@import '@keephy/ui-core/styles.css';

@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 240 10% 3.9%;
    --card: 0 0% 100%;
    --card-foreground: 240 10% 3.9%;
    --popover: 0 0% 100%;
    --popover-foreground: 240 10% 3.9%;
    --primary: 222 47% 11%;
    --primary-foreground: 210 40% 98%;
    --secondary: 210 40% 96.1%;
    --secondary-foreground: 222 47% 11%;
    --muted: 210 40% 96.1%;
    --muted-foreground: 215.4 16.3% 46.9%;
    --accent: 210 40% 96.1%;
    --accent-foreground: 222 47% 11%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 210 40% 98%;
    --border: 214.3 31.8% 91.4%;
    --input: 214.3 31.8% 91.4%;
    --ring: 222.2 84% 4.9%;
  }

  .dark {
    --background: 240 10% 3.9%;
    --foreground: 0 0% 98%;
    --card: 240 10% 3.9%;
    --card-foreground: 0 0% 98%;
    --popover: 240 10% 3.9%;
    --popover-foreground: 0 0% 98%;
    --primary: 210 40% 98%;
    --primary-foreground: 222.2 47.4% 11.2%;
    --secondary: 240 3.7% 15.9%;
    --secondary-foreground: 0 0% 98%;
    --muted: 240 3.7% 15.9%;
    --muted-foreground: 240 5% 64.9%;
    --accent: 240 3.7% 15.9%;
    --accent-foreground: 0 0% 98%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 0 0% 98%;
    --border: 240 3.7% 15.9%;
    --input: 240 3.7% 15.9%;
    --ring: 210 40% 98%;
  }

  html {
    @apply scroll-smooth;
    /* Mobile-first: Base font size for mobile */
    font-size: 16px;
  }

  /* Desktop font size */
  @media (min-width: 1024px) {
    html {
      font-size: 16px;
    }
  }

  body {
    @apply font-sans antialiased;
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
      'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif;
    background-color: hsl(var(--background));
    color: hsl(var(--foreground));
    /* Mobile-first: Ensure proper rendering on mobile */
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-rendering: optimizeLegibility;
  }

  * {
    @apply border-border;
  }

  /* Mobile-first: Touch target sizing */
  @media (max-width: 768px) {
    button,
    a,
    input,
    select,
    textarea {
      min-height: 44px; /* iOS touch target minimum */
    }
  }
}

@layer utilities {
  .line-clamp-2 {
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
  }

  .line-clamp-3 {
    display: -webkit-box;
    -webkit-line-clamp: 3;
    -webkit-box-orient: vertical;
    overflow: hidden;
  }

  /* Smooth scrolling */
  html {
    scroll-behavior: smooth;
  }

  /* Custom scrollbar */
  ::-webkit-scrollbar {
    width: 8px;
    height: 8px;
  }

  ::-webkit-scrollbar-track {
    @apply bg-muted;
  }

  ::-webkit-scrollbar-thumb {
    @apply bg-border rounded-md;
  }

  ::-webkit-scrollbar-thumb:hover {
    @apply bg-muted-foreground/30;
  }
}

/* Animation utilities */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateX(-10px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

.animate-fade-in {
  animation: fadeIn 0.3s ease-out;
}

.animate-slide-in {
  animation: slideIn 0.3s ease-out;
}

/* Focus styles */
:focus-visible {
  @apply outline-none ring-2 ring-ring ring-offset-2 ring-offset-background;
}

/* Selection styles */
::selection {
  @apply bg-primary/20 text-primary-foreground;
}
`;

async function findFrontendApps() {
  const entries = await fs.readdir(FRONTEND_DIR, { withFileTypes: true });
  return entries
    .filter((entry) => entry.isDirectory() && entry.name !== 'node_modules' && entry.name !== 'packages')
    .map((entry) => entry.name);
}

async function updateTailwindConfig(appName) {
  const configPath = path.join(FRONTEND_DIR, appName, 'tailwind.config.js');
  try {
    await fs.writeFile(configPath, TAILWIND_CONFIG_TEMPLATE);
    console.log(`✅ Updated tailwind.config.js for ${appName}`);
    return true;
  } catch (error) {
    console.error(`❌ Failed to update tailwind.config.js for ${appName}:`, error.message);
    return false;
  }
}

async function updateGlobalsCSS(appName) {
  const cssPath = path.join(FRONTEND_DIR, appName, 'src', 'styles', 'globals.css');
  try {
    // Ensure directory exists
    await fs.mkdir(path.dirname(cssPath), { recursive: true });
    await fs.writeFile(cssPath, GLOBALS_CSS_TEMPLATE);
    console.log(`✅ Updated globals.css for ${appName}`);
    return true;
  } catch (error) {
    console.error(`❌ Failed to update globals.css for ${appName}:`, error.message);
    return false;
  }
}

async function main() {
  console.log('🔄 Syncing frontend configurations...\n');

  const apps = await findFrontendApps();
  console.log(`Found ${apps.length} frontend apps: ${apps.join(', ')}\n`);

  let successCount = 0;
  let failCount = 0;

  for (const app of apps) {
    console.log(`Processing ${app}...`);
    const tailwindOk = await updateTailwindConfig(app);
    const cssOk = await updateGlobalsCSS(app);
    
    if (tailwindOk && cssOk) {
      successCount++;
    } else {
      failCount++;
    }
    console.log('');
  }

  console.log('\n📊 Summary:');
  console.log(`✅ Successfully updated: ${successCount}/${apps.length}`);
  if (failCount > 0) {
    console.log(`❌ Failed: ${failCount}/${apps.length}`);
  }
  console.log('\n✨ Done!');
}

main().catch(console.error);

