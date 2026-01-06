const fs = require('fs');
const path = require('path');

// Base plugin info
const plugin = {
  name: "softwayapp-marketplace",
  displayName: "SoftwayApp Development Marketplace",
  version: "1.0.0",
  description: "Complete development toolkit with 32+ skills, 4 commands, and 3 agents for enterprise workflows",
  author: {
    name: "SoftwayApp",
    email: "dev@softwayapp.com"
  },
  homepage: "https://github.com/softwayapp/market-place",
  repository: {
    type: "git",
    url: "https://github.com/softwayapp/market-place"
  },
  license: "MIT",
  keywords: ["development", "automation", "skills", "enterprise", "marketplace"],
  main: "./",
  commands: {},
  skills: {}
};

// Find all command files
const commandsDir = path.join(__dirname, 'commands');
const commandFiles = fs.readdirSync(commandsDir).filter(f => f.endsWith('.md'));

commandFiles.forEach(file => {
  const name = path.basename(file, '.md');
  const content = fs.readFileSync(path.join(commandsDir, file), 'utf8');
  const match = content.match(/^---\s*\n([\s\S]*?)\n---/);

  if (match) {
    const frontmatter = match[1];
    const descMatch = frontmatter.match(/description:\s*(.+)/);
    const description = descMatch ? descMatch[1].trim() : name + ' command';

    plugin.commands[name] = {
      description,
      file: './commands/' + file
    };
  }
});

// Find all skill directories
function findSkills(dir, basePath = '') {
  const items = fs.readdirSync(dir);

  items.forEach(item => {
    const fullPath = path.join(dir, item);
    const stat = fs.statSync(fullPath);

    if (stat.isDirectory()) {
      const skillFile = path.join(fullPath, 'SKILL.md');
      if (fs.existsSync(skillFile)) {
        const content = fs.readFileSync(skillFile, 'utf8');
        const match = content.match(/^---\s*\n([\s\S]*?)\n---/);

        if (match) {
          const frontmatter = match[1];
          const nameMatch = frontmatter.match(/name:\s*(.+)/);
          const descMatch = frontmatter.match(/description:\s*(.+)/);

          const skillName = nameMatch ? nameMatch[1].trim() : item;
          const description = descMatch ? descMatch[1].trim() : item + ' skill';

          const relativePath = path.relative(__dirname, fullPath).replace(/\\/g, '/');

          plugin.skills[skillName] = {
            description,
            path: './' + relativePath
          };
        }
      } else {
        findSkills(fullPath, path.join(basePath, item));
      }
    }
  });
}

findSkills(path.join(__dirname, 'skills'));

// Write plugin.json
fs.writeFileSync(
  path.join(__dirname, '.claude', 'plugin.json'),
  JSON.stringify(plugin, null, 2)
);

console.log('Generated plugin.json with ' + Object.keys(plugin.commands).length + ' commands and ' + Object.keys(plugin.skills).length + ' skills');
