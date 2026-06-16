# Database Schema Patterns - Config

Toimivat tietokantamallit ja skeemat.

**Päivitetty**: 2025-06-16  
**Versio**: 1.0

---

## 1. Peruskäyttäjä + Metatiedot

### Käyttötapaus
- Käyttäjäprofiili
- Käyttäjäasetukset
- Profiilitiedot

### Skeema

```sql
CREATE TABLE "UserProfile" (
    "id" TEXT PRIMARY KEY DEFAULT uuid_generate_v4(),
    "userId" TEXT UNIQUE NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    "displayName" TEXT,
    "avatarUrl" TEXT,
    "preferences" JSONB DEFAULT '{}',
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- RLS
ALTER TABLE "UserProfile" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view any profile" 
ON "UserProfile" FOR SELECT TO anon, authenticated USING (true);

CREATE POLICY "Users can update own profile" 
ON "UserProfile" FOR UPDATE TO authenticated 
USING ("userId" = auth.uid()::text);
```

---

## 2. Workspace + Jäsenyydet

### Käyttötapaus
- Tiimityöskentely
- Monikäyttäjäiset projektit
- Organisaatiot

### Skeema

```sql
-- Workspace
CREATE TABLE "Workspace" (
    "id" TEXT PRIMARY KEY DEFAULT uuid_generate_v4(),
    "slug" TEXT UNIQUE NOT NULL,
    "displayName" TEXT NOT NULL,
    "ownerId" TEXT NOT NULL,
    "settings" JSONB DEFAULT '{}',
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Jäsenyydet
CREATE TABLE "WorkspaceMember" (
    "id" TEXT PRIMARY KEY DEFAULT uuid_generate_v4(),
    "workspaceId" TEXT REFERENCES "Workspace"("id") ON DELETE CASCADE,
    "userId" TEXT NOT NULL,
    "role" TEXT DEFAULT 'member', -- 'owner', 'admin', 'member'
    "joinedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE("workspaceId", "userId")
);

-- Workspace-kohtainen data
CREATE TABLE "WorkspaceData" (
    "id" TEXT PRIMARY KEY DEFAULT uuid_generate_v4(),
    "workspaceId" TEXT REFERENCES "Workspace"("id") ON DELETE CASCADE,
    "data" JSONB NOT NULL,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- RLS
ALTER TABLE "Workspace" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "WorkspaceMember" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "WorkspaceData" ENABLE ROW LEVEL SECURITY;

-- Käyttäjä näkee workspace jos on jäsen
CREATE POLICY "View workspace if member" 
ON "Workspace" FOR SELECT TO authenticated 
USING (
    "ownerId" = auth.uid()::text OR
    EXISTS (
        SELECT 1 FROM "WorkspaceMember" 
        WHERE "workspaceId" = "Workspace"."id" 
        AND "userId" = auth.uid()::text
    )
);

-- Käyttäjä näkee data jos on workspace-jäsen
CREATE POLICY "View data if workspace member" 
ON "WorkspaceData" FOR SELECT TO authenticated 
USING (
    EXISTS (
        SELECT 1 FROM "WorkspaceMember" 
        WHERE "workspaceId" = "WorkspaceData"."workspaceId" 
        AND "userId" = auth.uid()::text
    )
);
```

---

## 3. Content + Tila (Draft → Published)

### Käyttötapaus
- Blogi / Artikkelit
- Dokumentit
- Sisällönhallinta

### Skeema

```sql
CREATE TYPE content_status AS ENUM ('draft', 'review', 'published', 'archived');

CREATE TABLE "Content" (
    "id" TEXT PRIMARY KEY DEFAULT uuid_generate_v4(),
    "slug" TEXT UNIQUE,
    "title" TEXT NOT NULL,
    "body" TEXT,
    "status" content_status DEFAULT 'draft',
    "authorId" TEXT NOT NULL,
    "publishedAt" TIMESTAMP,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- RLS
ALTER TABLE "Content" ENABLE ROW LEVEL SECURITY;

-- Julkaistu sisältö näkyy kaikille
CREATE POLICY "Published content visible to all" 
ON "Content" FOR SELECT TO anon, authenticated 
USING ("status" = 'published' AND "publishedAt" <= NOW());

-- Draft näkyy vain kirjoittajalle
CREATE POLICY "Drafts visible to author" 
ON "Content" FOR SELECT TO authenticated 
USING (
    "authorId" = auth.uid()::text OR
    "status" = 'published'
);

-- Kirjoittaja voi muokata omia
CREATE POLICY "Author can modify own" 
ON "Content" FOR ALL TO authenticated 
USING ("authorId" = auth.uid()::text);
```

---

## 4. Chat / Viestit

### Käyttötapaus
- Keskustelut
- Kommentit
- Viestihistoria

### Skeema

```sql
CREATE TYPE message_role AS ENUM ('user', 'ai');

CREATE TABLE "ChatSession" (
    "id" TEXT PRIMARY KEY DEFAULT uuid_generate_v4(),
    "title" TEXT,
    "userId" TEXT NOT NULL,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "Message" (
    "id" TEXT PRIMARY KEY DEFAULT uuid_generate_v4(),
    "chatSessionId" TEXT REFERENCES "ChatSession"("id") ON DELETE CASCADE,
    "role" message_role NOT NULL,
    "content" TEXT NOT NULL,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- RLS
ALTER TABLE "ChatSession" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Message" ENABLE ROW LEVEL SECURITY;

-- Käyttäjä näkee omat chattinsa
CREATE POLICY "Users see own chats" 
ON "ChatSession" FOR SELECT TO authenticated 
USING ("userId" = auth.uid()::text);

-- Käyttäjä näkee oman chatin viestit
CREATE POLICY "Users see own chat messages" 
ON "Message" FOR SELECT TO authenticated 
USING (
    EXISTS (
        SELECT 1 FROM "ChatSession" 
        WHERE "id" = "Message"."chatSessionId" 
        AND "userId" = auth.uid()::text
    )
);
```

---

## 5. Kategoriat + Tagit

### Käyttötapaus
- Sisällön luokittelu
- Hakutoiminto
- Suodatus

### Skeema

```sql
-- Kategoriat
CREATE TABLE "Category" (
    "id" TEXT PRIMARY KEY DEFAULT uuid_generate_v4(),
    "slug" TEXT UNIQUE NOT NULL,
    "displayName" TEXT NOT NULL,
    "description" TEXT
);

-- Sisältö kuuluu kategoriaan
CREATE TABLE "ContentCategory" (
    "contentId" TEXT NOT NULL,
    "categoryId" TEXT REFERENCES "Category"("id") ON DELETE CASCADE,
    PRIMARY KEY ("contentId", "categoryId")
);

-- Tagit (vapaa teksti)
CREATE TABLE "Tag" (
    "id" TEXT PRIMARY KEY DEFAULT uuid_generate_v4(),
    "name" TEXT UNIQUE NOT NULL
);

-- Sisällön tagit
CREATE TABLE "ContentTag" (
    "contentId" TEXT NOT NULL,
    "tagId" TEXT REFERENCES "Tag"("id") ON DELETE CASCADE,
    PRIMARY KEY ("contentId", "tagId")
);

-- RLS (yleensä julkista luettavaa)
ALTER TABLE "Category" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Tag" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Categories visible to all" 
ON "Category" FOR SELECT TO anon, authenticated USING (true);

CREATE POLICY "Tags visible to all" 
ON "Tag" FOR SELECT TO anon, authenticated USING (true);
```

---

## Valitse sopiva pattern

| Tarve | Suositeltu pattern |
|-------|-------------------|
| Käyttäjäprofiilit | #1 Peruskäyttäjä |
| Tiimityö / Organisaatiot | #2 Workspace |
| Blogi / Dokumentit | #3 Content |
| Chat-sovellus | #4 Chat |
| Luokittelu / Hakemisto | #5 Kategoriat |

---

## Huomioitavaa

- **Aina RLS päälle** production-tauluissa
- **Käytä UUID** ID-kentissä (paitsi jos tarvitset luettavan slug:n)
- **JSONB** joustaviin metatietoihin
- **ENUM** tila-kenttiin (status, role, jne.)
- **TIMESTAMP WITH TIME ZONE** aikaleimoissa
