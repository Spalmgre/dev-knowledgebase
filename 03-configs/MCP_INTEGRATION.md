# MCP (Model Context Protocol) Integration Guidelines

Tämä dokumentti määrittelee MCP-palveluiden ja Skills-osaamisen standardit ja käytännöt kaikissa projekteissa. MCP mahdollistaa tekoälyagenttien kommunikoinnin ulkoisten palveluiden kanssa standardoidulla tavalla.

**Palvelukohtaiset valmiit MCP-konfiguraatiot:**
- Supabase: `03-configs/supabase/mcp-setup.md`
- Vercel: `03-configs/vercel/mcp-setup.md`

---

# MCP Perusteet

## Mikä on MCP?

MCP (Model Context Protocol) on avoin standardi, joka mahdollistaa tekoälymallien integroinnin ulkoisiin tietolähteisiin ja työkaluihin. Se tarjoaa:

- **Standardoidut rajapinnat** tietojen hakemiseen ja käsittelyyn
- **Turvallinen kommunikaatio** agenttien ja palveluiden välillä
- **Skaalautuva arkkitehtuuri** useille palveluille
- **Versionhallinta** API-muutoksille

## MCP-arkkitehtuuri

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   AI Agent      │    │   MCP Server    │    │ External Service│
│                 │◄──►│                 │◄──►│                 │
│ - Cascade       │    │ - Resources     │    │ - Database      │
│ - Custom Agents │    │ - Tools         │    │ - APIs          │
│ - Skills        │    │ - Prompts       │    │ - File Systems  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

---

# MCP Server -konfiguraatio

## Perusasetukset

```json
// mcp-server.json
{
  "name": "knowledgebase-mcp",
  "version": "1.0.0",
  "description": "MCP server for knowledgebase management",
  "server": {
    "command": "node",
    "args": ["dist/server.js"],
    "env": {
      "NODE_ENV": "production"
    }
  },
  "capabilities": {
    "resources": {},
    "tools": {},
    "prompts": {}
  }
}
```

## Server -implementaatio

```typescript
// src/mcp/server.ts
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListResourcesRequestSchema,
  ListToolsRequestSchema,
  ReadResourceRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';

class KnowledgebaseMCPServer {
  private server: Server;

  constructor() {
    this.server = new Server(
      {
        name: 'knowledgebase-mcp',
        version: '1.0.0',
      },
      {
        capabilities: {
          resources: {},
          tools: {},
          prompts: {},
        },
      }
    );

    this.setupHandlers();
  }

  private setupHandlers() {
    // Resource handlers
    this.server.setRequestHandler(ListResourcesRequestSchema, async () => ({
      resources: [
        {
          uri: 'knowledgebase://workflows',
          name: 'Project Workflows',
          description: 'All project workflows and processes',
          mimeType: 'text/markdown',
        },
        {
          uri: 'knowledgebase://configs',
          name: 'Configuration Templates',
          description: 'Standardized configuration templates',
          mimeType: 'application/json',
        },
        {
          uri: 'knowledgebase://issues',
          name: 'Resolved Issues',
          description: 'Database of resolved technical issues',
          mimeType: 'text/markdown',
        },
      ],
    }));

    this.server.setRequestHandler(ReadResourceRequestSchema, async (request) => {
      const { uri } = request.params;
      
      switch (uri) {
        case 'knowledgebase://workflows':
          return {
            contents: [
              {
                uri,
                mimeType: 'text/markdown',
                text: await this.getWorkflows(),
              },
            ],
          };
        
        case 'knowledgebase://configs':
          return {
            contents: [
              {
                uri,
                mimeType: 'application/json',
                text: await this.getConfigs(),
              },
            ],
          };
        
        case 'knowledgebase://issues':
          return {
            contents: [
              {
                uri,
                mimeType: 'text/markdown',
                text: await this.getIssues(),
              },
            ],
          };
        
        default:
          throw new Error(`Unknown resource: ${uri}`);
      }
    });

    // Tool handlers
    this.server.setRequestHandler(ListToolsRequestSchema, async () => ({
      tools: [
        {
          name: 'search_knowledgebase',
          description: 'Search the knowledgebase for specific information',
          inputSchema: {
            type: 'object',
            properties: {
              query: {
                type: 'string',
                description: 'Search query',
              },
              category: {
                type: 'string',
                enum: ['workflows', 'configs', 'issues', 'all'],
                description: 'Category to search in',
              },
            },
            required: ['query'],
          },
        },
        {
          name: 'add_to_knowledgebase',
          description: 'Add new information to the knowledgebase',
          inputSchema: {
            type: 'object',
            properties: {
              category: {
                type: 'string',
                enum: ['workflows', 'configs', 'issues'],
                description: 'Category to add to',
              },
              title: {
                type: 'string',
                description: 'Title of the entry',
              },
              content: {
                type: 'string',
                description: 'Content of the entry',
              },
              tags: {
                type: 'array',
                items: { type: 'string' },
                description: 'Tags for the entry',
              },
            },
            required: ['category', 'title', 'content'],
          },
        },
        {
          name: 'update_project_config',
          description: 'Update project configuration based on knowledgebase',
          inputSchema: {
            type: 'object',
            properties: {
              projectPath: {
                type: 'string',
                description: 'Path to the project',
              },
              configType: {
                type: 'string',
                enum: ['supabase', 'vercel', 'github', 'package'],
                description: 'Type of configuration to update',
              },
            },
            required: ['projectPath', 'configType'],
          },
        },
      ],
    }));

    this.server.setRequestHandler(CallToolRequestSchema, async (request) => {
      const { name, arguments: args } = request.params;

      switch (name) {
        case 'search_knowledgebase':
          return await this.searchKnowledgebase(args.query, args.category);
        
        case 'add_to_knowledgebase':
          return await this.addToKnowledgebase(args.category, args.title, args.content, args.tags);
        
        case 'update_project_config':
          return await this.updateProjectConfig(args.projectPath, args.configType);
        
        default:
          throw new Error(`Unknown tool: ${name}`);
      }
    });
  }

  private async getWorkflows(): Promise<string> {
    // Implementation to read workflows from knowledgebase
    const workflowsPath = path.join(process.env.KNOWLEDGE_BASE_PATH!, '01-workflows');
    const files = await fs.readdir(workflowsPath, { recursive: true });
    
    let content = '# Project Workflows\n\n';
    for (const file of files) {
      if (file.endsWith('.md')) {
        const filePath = path.join(workflowsPath, file);
        const fileContent = await fs.readFile(filePath, 'utf-8');
        content += `## ${file}\n\n${fileContent}\n\n`;
      }
    }
    
    return content;
  }

  private async getConfigs(): Promise<string> {
    // Implementation to read configs from knowledgebase
    const configsPath = path.join(process.env.KNOWLEDGE_BASE_PATH!, '03-configs');
    const configs = await this.readConfigsRecursive(configsPath);
    
    return JSON.stringify(configs, null, 2);
  }

  private async getIssues(): Promise<string> {
    // Implementation to read issues from knowledgebase
    const issuesPath = path.join(process.env.KNOWLEDGE_BASE_PATH!, '04-issues-resolved');
    const files = await fs.readdir(issuesPath);
    
    let content = '# Resolved Issues\n\n';
    for (const file of files.sort().reverse()) {
      if (file.endsWith('.md')) {
        const filePath = path.join(issuesPath, file);
        const fileContent = await fs.readFile(filePath, 'utf-8');
        content += `## ${file}\n\n${fileContent}\n\n`;
      }
    }
    
    return content;
  }

  private async searchKnowledgebase(query: string, category: string = 'all'): Promise<any> {
    // Implementation to search knowledgebase
    const knowledgebasePath = process.env.KNOWLEDGE_BASE_PATH!;
    const results: any[] = [];

    const searchInDirectory = async (dir: string, dirName: string) => {
      if (category !== 'all' && category !== dirName) return;
      
      const files = await fs.readdir(dir, { recursive: true });
      
      for (const file of files) {
        if (file.endsWith('.md') || file.endsWith('.json')) {
          const filePath = path.join(dir, file);
          const content = await fs.readFile(filePath, 'utf-8');
          
          if (content.toLowerCase().includes(query.toLowerCase())) {
            results.push({
              file: path.join(dirName, file),
              content: content.substring(0, 500) + '...',
              category: dirName,
            });
          }
        }
      }
    };

    await searchInDirectory(path.join(knowledgebasePath, '01-workflows'), 'workflows');
    await searchInDirectory(path.join(knowledgebasePath, '03-configs'), 'configs');
    await searchInDirectory(path.join(knowledgebasePath, '04-issues-resolved'), 'issues');

    return {
      content: [
        {
          type: 'text',
          text: `Found ${results.length} results for "${query}":\n\n${results.map(r => `**${r.file}** (${r.category})\n${r.content}\n`).join('\n')}`,
        },
      ],
    };
  }

  private async addToKnowledgebase(category: string, title: string, content: string, tags: string[] = []): Promise<any> {
    // Implementation to add to knowledgebase
    const knowledgebasePath = process.env.KNOWLEDGE_BASE_PATH!;
    const timestamp = new Date().toISOString().split('T')[0];
    const filename = `${title.toLowerCase().replace(/\s+/g, '-')}-${timestamp}.md`;
    
    let targetDir: string;
    switch (category) {
      case 'workflows':
        targetDir = path.join(knowledgebasePath, '01-workflows');
        break;
      case 'configs':
        targetDir = path.join(knowledgebasePath, '03-configs');
        break;
      case 'issues':
        targetDir = path.join(knowledgebasePath, '04-issues-resolved');
        break;
      default:
        throw new Error(`Unknown category: ${category}`);
    }

    const filePath = path.join(targetDir, filename);
    const fileContent = `# ${title}

**Tags:** ${tags.join(', ')}
**Created:** ${new Date().toISOString()}

${content}`;

    await fs.writeFile(filePath, fileContent, 'utf-8');

    return {
      content: [
        {
          type: 'text',
          text: `Added "${title}" to knowledgebase in category "${category}"\nFile: ${filename}`,
        },
      ],
    };
  }

  private async updateProjectConfig(projectPath: string, configType: string): Promise<any> {
    // Implementation to update project config
    const knowledgebasePath = process.env.KNOWLEDGE_BASE_PATH!;
    const configTemplatePath = path.join(knowledgebasePath, '03-configs', configType);
    
    if (!await fs.exists(configTemplatePath)) {
      throw new Error(`Config template not found: ${configType}`);
    }

    // Copy config template to project
    const projectConfigPath = path.join(projectPath, configType);
    await fs.copy(configTemplatePath, projectConfigPath, { recursive: true });

    return {
      content: [
        {
          type: 'text',
          text: `Updated ${configType} configuration in project: ${projectPath}`,
        },
      ],
    };
  }

  async run() {
    const transport = new StdioServerTransport();
    await this.server.connect(transport);
  }
}

// Start server
const server = new KnowledgebaseMCPServer();
server.run().catch(console.error);
```

---

# Skills Framework

## Skill -rakenne

```typescript
// src/skills/base-skill.ts
export interface SkillInput {
  [key: string]: any;
}

export interface SkillOutput {
  success: boolean;
  data?: any;
  error?: string;
  metadata?: {
    executionTime: number;
    tokensUsed?: number;
    confidence?: number;
  };
}

export abstract class BaseSkill {
  protected name: string;
  protected description: string;
  protected version: string;

  constructor(name: string, description: string, version: string = '1.0.0') {
    this.name = name;
    this.description = description;
    this.version = version;
  }

  abstract execute(input: SkillInput): Promise<SkillOutput>;

  getName(): string {
    return this.name;
  }

  getDescription(): string {
    return this.description;
  }

  getVersion(): string {
    return this.version;
  }

  protected async measureExecutionTime<T>(
    fn: () => Promise<T>
  ): Promise<{ result: T; executionTime: number }> {
    const startTime = Date.now();
    const result = await fn();
    const executionTime = Date.now() - startTime;
    return { result, executionTime };
  }
}
```

## Esimerkki Skills

```typescript
// src/skills/project-setup-skill.ts
import { BaseSkill, SkillInput, SkillOutput } from './base-skill';
import { execSync } from 'child_process';
import * as fs from 'fs/promises';
import * as path from 'path';

export class ProjectSetupSkill extends BaseSkill {
  constructor() {
    super(
      'project-setup',
      'Sets up a new project using knowledgebase templates',
      '1.0.0'
    );
  }

  async execute(input: SkillInput): Promise<SkillOutput> {
    const { projectName, projectType, projectPath } = input;

    try {
      const { result, executionTime } = await this.measureExecutionTime(async () => {
        // 1. Get template from knowledgebase
        const templatePath = path.join(
          process.env.KNOWLEDGE_BASE_PATH!,
          '02-templates',
          projectType
        );

        if (!await fs.access(templatePath).then(() => true).catch(() => false)) {
          throw new Error(`Template not found: ${projectType}`);
        }

        // 2. Create project directory
        await fs.mkdir(projectPath, { recursive: true });

        // 3. Copy template
        await this.copyDirectory(templatePath, projectPath);

        // 4. Update package.json
        const packageJsonPath = path.join(projectPath, 'package.json');
        if (await fs.access(packageJsonPath).then(() => true).catch(() => false)) {
          const packageJson = JSON.parse(await fs.readFile(packageJsonPath, 'utf-8'));
          packageJson.name = projectName;
          await fs.writeFile(packageJsonPath, JSON.stringify(packageJson, null, 2));
        }

        // 5. Install dependencies
        process.chdir(projectPath);
        execSync('npm install', { stdio: 'inherit' });

        // 6. Initialize git
        execSync('git init', { stdio: 'inherit' });
        execSync('git add .', { stdio: 'inherit' });
        execSync('git commit -m "Initial commit"', { stdio: 'inherit' });

        return {
          projectPath,
          projectName,
          projectType,
          setupComplete: true,
        };
      });

      return {
        success: true,
        data: result,
        metadata: { executionTime },
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
        metadata: { executionTime: 0 },
      };
    }
  }

  private async copyDirectory(src: string, dest: string): Promise<void> {
    await fs.mkdir(dest, { recursive: true });
    const entries = await fs.readdir(src, { withFileTypes: true });

    for (const entry of entries) {
      const srcPath = path.join(src, entry.name);
      const destPath = path.join(dest, entry.name);

      if (entry.isDirectory()) {
        await this.copyDirectory(srcPath, destPath);
      } else {
        await fs.copyFile(srcPath, destPath);
      }
    }
  }
}
```

```typescript
// src/skills/config-sync-skill.ts
import { BaseSkill, SkillInput, SkillOutput } from './base-skill';
import * as fs from 'fs/promises';
import * as path from 'path';

export class ConfigSyncSkill extends BaseSkill {
  constructor() {
    super(
      'config-sync',
      'Synchronizes project configurations with knowledgebase',
      '1.0.0'
    );
  }

  async execute(input: SkillInput): Promise<SkillOutput> {
    const { projectPath, configTypes } = input;

    try {
      const { result, executionTime } = await this.measureExecutionTime(async () => {
        const knowledgebasePath = process.env.KNOWLEDGE_BASE_PATH!;
        const syncResults: any[] = [];

        for (const configType of configTypes) {
          const sourcePath = path.join(knowledgebasePath, '03-configs', configType);
          const destPath = path.join(projectPath, configType);

          if (await fs.access(sourcePath).then(() => true).catch(() => false)) {
            await this.syncConfig(sourcePath, destPath);
            syncResults.push({
              configType,
              status: 'synced',
              sourcePath,
              destPath,
            });
          } else {
            syncResults.push({
              configType,
              status: 'not_found',
              sourcePath,
            });
          }
        }

        return {
          projectPath,
          syncResults,
          totalSynced: syncResults.filter(r => r.status === 'synced').length,
        };
      });

      return {
        success: true,
        data: result,
        metadata: { executionTime },
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
        metadata: { executionTime: 0 },
      };
    }
  }

  private async syncConfig(sourcePath: string, destPath: string): Promise<void> {
    // Implementation to sync configuration files
    await fs.mkdir(destPath, { recursive: true });
    
    const entries = await fs.readdir(sourcePath, { withFileTypes: true });
    
    for (const entry of entries) {
      const srcFile = path.join(sourcePath, entry.name);
      const destFile = path.join(destPath, entry.name);

      if (entry.isDirectory()) {
        await this.syncConfig(srcFile, destFile);
      } else {
        // Only copy if destination doesn't exist or is older
        const srcStats = await fs.stat(srcFile);
        
        try {
          const destStats = await fs.stat(destFile);
          
          if (srcStats.mtime > destStats.mtime) {
            await fs.copyFile(srcFile, destFile);
          }
        } catch {
          // Destination doesn't exist, copy it
          await fs.copyFile(srcFile, destFile);
        }
      }
    }
  }
}
```

---

# MCP Client -integraatio

## Client -implementaatio

```typescript
// src/mcp/client.ts
import { Client } from '@modelcontextprotocol/sdk/client/index.js';
import { StdioClientTransport } from '@modelcontextprotocol/sdk/client/stdio.js';

export class MCPClient {
  private client: Client;
  private transport: StdioClientTransport;

  constructor(serverCommand: string, serverArgs: string[]) {
    this.transport = new StdioClientTransport({
      command: serverCommand,
      args: serverArgs,
    });

    this.client = new Client(
      {
        name: 'knowledgebase-client',
        version: '1.0.0',
      },
      {
        capabilities: {},
      }
    );
  }

  async connect(): Promise<void> {
    await this.client.connect(this.transport);
  }

  async searchKnowledgebase(query: string, category: string = 'all'): Promise<any> {
    const result = await this.client.request(
      {
        method: 'tools/call',
        params: {
          name: 'search_knowledgebase',
          arguments: {
            query,
            category,
          },
        },
      },
      {}
    );

    return result;
  }

  async addToKnowledgebase(
    category: string,
    title: string,
    content: string,
    tags: string[] = []
  ): Promise<any> {
    const result = await this.client.request(
      {
        method: 'tools/call',
        params: {
          name: 'add_to_knowledgebase',
          arguments: {
            category,
            title,
            content,
            tags,
          },
        },
      },
      {}
    );

    return result;
  }

  async updateProjectConfig(projectPath: string, configType: string): Promise<any> {
    const result = await this.client.request(
      {
        method: 'tools/call',
        params: {
          name: 'update_project_config',
          arguments: {
            projectPath,
            configType,
          },
        },
      },
      {}
    );

    return result;
  }

  async getResource(uri: string): Promise<any> {
    const result = await this.client.request(
      {
        method: 'resources/read',
        params: {
          uri,
        },
      },
      {}
    );

    return result;
  }

  async listResources(): Promise<any> {
    const result = await this.client.request(
      {
        method: 'resources/list',
      },
      {}
    );

    return result;
  }

  async disconnect(): Promise<void> {
    await this.client.close();
  }
}
```

## Käyttö esimerkki

```typescript
// src/examples/mcp-usage.ts
import { MCPClient } from '../mcp/client';
import { ProjectSetupSkill, ConfigSyncSkill } from '../skills';

async function exampleUsage() {
  // Initialize MCP client
  const mcpClient = new MCPClient('node', ['dist/mcp-server.js']);
  await mcpClient.connect();

  try {
    // Search knowledgebase
    const searchResults = await mcpClient.searchKnowledgebase('supabase rls');
    console.log('Search results:', searchResults);

    // Add new issue to knowledgebase
    await mcpClient.addToKnowledgebase(
      'issues',
      'Supabase RLS Policy Issue',
      'Description of the issue and solution...',
      ['supabase', 'rls', 'security']
    );

    // Use skills
    const projectSetupSkill = new ProjectSetupSkill();
    const setupResult = await projectSetupSkill.execute({
      projectName: 'new-project',
      projectType: 'nextjs-supabase',
      projectPath: '/path/to/new-project',
    });

    if (setupResult.success) {
      console.log('Project setup completed:', setupResult.data);
    }

    const configSyncSkill = new ConfigSyncSkill();
    const syncResult = await configSyncSkill.execute({
      projectPath: '/path/to/project',
      configTypes: ['supabase', 'vercel'],
    });

    if (syncResult.success) {
      console.log('Config sync completed:', syncResult.data);
    }

  } finally {
    await mcpClient.disconnect();
  }
}
```

---

# Konfiguraatio

## Environment Variables

```bash
# .env.local
KNOWLEDGE_BASE_PATH=C:\TYO\GitHub Local\dev-knowledgebase
MCP_SERVER_PORT=3001
MCP_SERVER_HOST=localhost
NODE_ENV=development

# Optional: External service configurations
GITHUB_TOKEN=your_github_token
VERCEL_TOKEN=your_vercel_token
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

## Package.json -skriptit

```json
{
  "scripts": {
    "mcp:server": "node dist/mcp/server.js",
    "mcp:client": "node dist/mcp/client.js",
    "skills:setup": "node dist/skills/project-setup-skill.js",
    "skills:sync": "node dist/skills/config-sync-skill.js",
    "build:mcp": "tsc -p tsconfig.mcp.json",
    "dev:mcp": "ts-node src/mcp/server.ts",
    "test:mcp": "jest --testPathPattern=mcp"
  }
}
```

---

# Testaus

## MCP Server -testit

```typescript
// tests/mcp/server.test.ts
import { KnowledgebaseMCPServer } from '../../src/mcp/server';
import { Client } from '@modelcontextprotocol/sdk/client/index.js';
import { StdioClientTransport } from '@modelcontextprotocol/sdk/client/stdio.js';

describe('KnowledgebaseMCPServer', () => {
  let server: KnowledgebaseMCPServer;
  let client: Client;

  beforeAll(async () => {
    server = new KnowledgebaseMCPServer();
    
    // Start server in background
    const transport = new StdioClientTransport({
      command: 'node',
      args: ['dist/test-server.js'],
    });

    client = new Client(
      { name: 'test-client', version: '1.0.0' },
      { capabilities: {} }
    );

    await client.connect(transport);
  });

  afterAll(async () => {
    await client.close();
  });

  test('should list resources', async () => {
    const result = await client.request(
      { method: 'resources/list' },
      {}
    );

    expect(result.resources).toHaveLength(3);
    expect(result.resources[0].name).toBe('Project Workflows');
  });

  test('should search knowledgebase', async () => {
    const result = await client.request(
      {
        method: 'tools/call',
        params: {
          name: 'search_knowledgebase',
          arguments: {
            query: 'supabase',
            category: 'all',
          },
        },
      },
      {}
    );

    expect(result.content).toBeDefined();
    expect(result.content[0].type).toBe('text');
  });

  test('should add to knowledgebase', async () => {
    const result = await client.request(
      {
        method: 'tools/call',
        params: {
          name: 'add_to_knowledgebase',
          arguments: {
            category: 'issues',
            title: 'Test Issue',
            content: 'Test content',
            tags: ['test'],
          },
        },
      },
      {}
    );

    expect(result.content[0].text).toContain('Added "Test Issue"');
  });
});
```

## Skills -testit

```typescript
// tests/skills/project-setup-skill.test.ts
import { ProjectSetupSkill } from '../../src/skills/project-setup-skill';
import * as fs from 'fs/promises';
import * as path from 'path';

describe('ProjectSetupSkill', () => {
  let skill: ProjectSetupSkill;
  let tempDir: string;

  beforeEach(async () => {
    skill = new ProjectSetupSkill();
    tempDir = await fs.mkdtemp(path.join(process.cwd(), 'test-'));
  });

  afterEach(async () => {
    await fs.rm(tempDir, { recursive: true });
  });

  test('should setup new project', async () => {
    const result = await skill.execute({
      projectName: 'test-project',
      projectType: 'nextjs-supabase',
      projectPath: path.join(tempDir, 'test-project'),
    });

    expect(result.success).toBe(true);
    expect(result.data.setupComplete).toBe(true);
    
    const packageJsonPath = path.join(tempDir, 'test-project', 'package.json');
    const packageJson = JSON.parse(await fs.readFile(packageJsonPath, 'utf-8'));
    expect(packageJson.name).toBe('test-project');
  });

  test('should handle missing template', async () => {
    const result = await skill.execute({
      projectName: 'test-project',
      projectType: 'nonexistent-template',
      projectPath: path.join(tempDir, 'test-project'),
    });

    expect(result.success).toBe(false);
    expect(result.error).toContain('Template not found');
  });
});
```

---

# Deployment

## Docker -konfiguraatio

```dockerfile
# Dockerfile
FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY tsconfig*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY src/ ./src/
COPY dist/ ./dist/

# Set environment variables
ENV KNOWLEDGE_BASE_PATH=/app/knowledgebase
ENV NODE_ENV=production

# Expose port
EXPOSE 3001

# Start MCP server
CMD ["npm", "run", "mcp:server"]
```

## Docker Compose

```yaml
# docker-compose.yml
version: '3.8'

services:
  mcp-server:
    build: .
    ports:
      - "3001:3001"
    environment:
      - KNOWLEDGE_BASE_PATH=/app/knowledgebase
      - NODE_ENV=production
    volumes:
      - ./knowledgebase:/app/knowledgebase:ro
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    restart: unless-stopped
```

---

# Tämä MCP-integraatio takaa:

1. **Standardoitu kommunikaatio** - Kaikki agentit käyttävät samaa protokollaa
2. **Skaalautuvuus** - Helposti laajennettava uusilla palveluilla
3. **Turvallisuus** - Kontrolloitu pääsy tietolähteisiin
4. **Ylläpidettävyys** - Keskitetty hallinta kaikille integraatioille
5. **Testattavuus** - Kattavat testausvälineet ja -prosessit
6. **Suorituskyky** - Optimoidut tiedonsiirrot ja välimuisti

**Muista:** Pidä MCP-palvelut aina ajan tasalla ja dokumentoi muutokset knowledgebaseen.
