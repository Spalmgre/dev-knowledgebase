-- Supabase RLS Policy Templates
-- Toimivat RLS-politiikat yleisiin käyttötapauksiin
-- Versio: 1.0 (2025-06-16)

-- ============================================
-- 1. USER-OMISTAMA DATA
-- Käyttäjä näkee vain omat tietonsa
-- ============================================

-- Taulun luonti esimerkillä
CREATE TABLE IF NOT EXISTS "UserData" (
    "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "userId" TEXT NOT NULL,
    "data" JSONB,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- RLS päälle
ALTER TABLE "UserData" ENABLE ROW LEVEL SECURITY;

-- Politikka: käyttäjä näkee vain omat tietonsa
CREATE POLICY "Users can view own data" 
ON "UserData" 
FOR SELECT 
TO authenticated 
USING ("userId" = auth.uid()::text);

-- Politikka: käyttäjä voi lisätä vain omia tietoja
CREATE POLICY "Users can insert own data" 
ON "UserData" 
FOR INSERT 
TO authenticated 
WITH CHECK ("userId" = auth.uid()::text);

-- Politikka: käyttäjä voi päivittää vain omia tietoja
CREATE POLICY "Users can update own data" 
ON "UserData" 
FOR UPDATE 
TO authenticated 
USING ("userId" = auth.uid()::text);

-- Politikka: käyttäjä voi poistaa vain omia tietoja
CREATE POLICY "Users can delete own data" 
ON "UserData" 
FOR DELETE 
TO authenticated 
USING ("userId" = auth.uid()::text);

-- ============================================
-- 2. JULKINEN LUETTAVA DATA
-- Kaikki näkevät, vain kirjautuneet voivat muokata
-- ============================================

CREATE TABLE IF NOT EXISTS "PublicContent" (
    "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "title" TEXT NOT NULL,
    "content" TEXT,
    "createdBy" TEXT,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE "PublicContent" ENABLE ROW LEVEL SECURITY;

-- Kaikki näkevät (anonyymitkin)
CREATE POLICY "Anyone can view public content" 
ON "PublicContent" 
FOR SELECT 
TO anon, authenticated 
USING (true);

-- Vain kirjautuneet voivat lisätä
CREATE POLICY "Authenticated users can insert" 
ON "PublicContent" 
FOR INSERT 
TO authenticated 
WITH CHECK (true);

-- Vain luoja voi päivittää/poistaa
CREATE POLICY "Creator can update own content" 
ON "PublicContent" 
FOR UPDATE 
TO authenticated 
USING ("createdBy" = auth.uid()::text);

-- ============================================
-- 3. WORKSPACE/TEAM -RAJOITETTU DATA
-- Käyttäjä näkee vain oman workspace-nsa datan
-- ============================================

CREATE TABLE IF NOT EXISTS "Workspace" (
    "id" TEXT PRIMARY KEY DEFAULT uuid_generate_v4(),
    "slug" TEXT UNIQUE NOT NULL,
    "displayName" TEXT NOT NULL,
    "ownerId" TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS "WorkspaceMember" (
    "workspaceId" TEXT REFERENCES "Workspace"("id"),
    "userId" TEXT NOT NULL,
    "role" TEXT DEFAULT 'member',
    PRIMARY KEY ("workspaceId", "userId")
);

CREATE TABLE IF NOT EXISTS "WorkspaceData" (
    "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "workspaceId" TEXT REFERENCES "Workspace"("id"),
    "data" JSONB,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE "Workspace" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "WorkspaceMember" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "WorkspaceData" ENABLE ROW LEVEL SECURITY;

-- Käyttäjä näkee workspace-jäsenyytensä perusteella
CREATE POLICY "View workspace data if member" 
ON "WorkspaceData" 
FOR SELECT 
TO authenticated 
USING (
    "workspaceId" IN (
        SELECT "workspaceId" FROM "WorkspaceMember" 
        WHERE "userId" = auth.uid()::text
    )
);

-- ============================================
-- 4. ADMIN-OMISTAMA DATA
-- Vain admin-käyttäjät voivat muokata
-- ============================================

CREATE TABLE IF NOT EXISTS "AdminSettings" (
    "id" TEXT PRIMARY KEY DEFAULT 'default',
    "settings" JSONB,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE "AdminSettings" ENABLE ROW LEVEL SECURITY;

-- Kaikki näkevät
CREATE POLICY "Anyone can view settings" 
ON "AdminSettings" 
FOR SELECT 
TO anon, authenticated 
USING (true);

-- Vain admin voi muokata (tarkistetaan users-taulusta)
CREATE POLICY "Only admins can update" 
ON "AdminSettings" 
FOR ALL 
TO authenticated 
USING (
    EXISTS (
        SELECT 1 FROM auth.users 
        WHERE id = auth.uid() 
        AND raw_user_meta_data->>'role' = 'admin'
    )
);

-- ============================================
-- 5. TRIGGERIT updatedAt-kentälle
-- ============================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW."updatedAt" = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_userdata_updatedat 
    BEFORE UPDATE ON "UserData" 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();
