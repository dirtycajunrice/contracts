#!/usr/bin/env node
import fs from 'fs';
import { version } from '../package.json';
import proc from 'child_process';

const [date] = new Date().toISOString().split('T');

const changelog = fs.readFileSync('CHANGELOG.md', 'utf8');

const unreleased = /^## Unreleased$/im;

if (!unreleased.test(changelog)) {
  console.error('Missing changelog entry');
  process.exit(1);
}

fs.writeFileSync('CHANGELOG.md', changelog.replace(unreleased, `## ${version} (${date})`));

proc.execSync('git add CHANGELOG.md', { stdio: 'inherit' });