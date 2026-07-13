# Knowledgebase Agent Instructions

Tämä on keskitetty osaamispankki kaikille projekteille. Kaikki toimivat ratkaisut, asetukset ja prosessit dokumentoidaan tänne.

---

## Kun aloitat uuden projektin

1. Lue `01-workflows/new-project-setup.md`
2. Lue globaalit määritykset: `01-workflows/SYSTEM_INSTRUCTIONS.md`, `01-workflows/workflow-rules.md`, `03-configs/ARCHITECTURE.md`, `03-configs/UI_UX_STANDARDS.md`, `03-configs/MCP_INTEGRATION.md`
3. Seuraa vaiheet tarkasti järjestyksessä
4. Kopioi pohja `02-templates/` kansiosta projektityypin mukaan
5. Varmista että projektin `AGENTS.md` sisältää pakollisen knowledgebase-alustusosion (`git pull origin main` + knowledgebase-viittaukset)
6. Aseta palvelut projektin teknologioiden mukaan: Supabase (`03-configs/supabase/`) jos käytössä, Vercel (`03-configs/vercel/`) jos käytössä

---

## Kun käyttäjä pyytää lisäämään globaaliksi

**Käyttäjä saattaa sanoa (tunnista nämä):**

- "Tämä on globaalisti käytettävä"
- "Lisää knowledgebaseen"
- "Toista tämä muissa projekteissa"
- "Tämä pitää muistaa jatkossa"
- "Tee tästä toistettava"
- "Dokumentoi tämä"

**Toimenpiteet:**

1. Luo tiedosto `04-issues-resolved/[kuvaava-nimi]-[YYYY-MM-DD].md`
2. Kirjaa seuraavat kohdat:
   - **Ongelma**: Mitä yritettiin ratkaista
   - **Ratkaisu**: Miten se ratkaistiin (tarkat askeleet)
   - **Konteksti**: Mikä projekti, milloin
   - **Avainsanat**: Hakusanat tulevia hakuja varten
3. Jos kyse asetuksista → päivitä myös `03-configs/` vastaava tiedosto
4. Ilmoita käyttäjälle: "Kirjattu knowledgebaseen: [tiedostonimi]"
5. Jatka projektityötä normaalisti

**Esimerkki käyttäjän pyynnöstä:**

```
Käyttäjä: "Tämä Supabase RLS-ratkaisu pitää olla kaikissa projekteissa"
→ Luo: 04-issues-resolved/supabase-rls-policy-2025-06-16.md
→ Päivitä: 03-configs/supabase/rls-templates.sql
→ Ilmoita: "Kirjattu knowledgebaseen: supabase-rls-policy-2025-06-16.md"
```

---

## Kun kohtaat teknisen ongelman

1. **Tarkista ensin** `04-issues-resolved/` - onko ratkaisu jo olemassa?
   - Käytä grep-hakua avainsanoilla
   - Lue relevantit dokumentit
2. **Jos löytyy** → sovella ratkaisu suoraan
3. **Jos ei löydy** → ratkaise ongelma normaalisti
4. **Ratkaisun jälkeen** → kysy käyttäjältä: "Tallennetaanko tämä ratkaisu knowledgebaseen jatkoa varten?"

---

## Hakemistorakenne (tarkista aina oikea kansio)

| Kansio                | Sisältö                                 |
| --------------------- | --------------------------------------- |
| `01-workflows/`       | Vaiheittaiset prosessit (miten tehdään) |
| `02-templates/`       | Kopioitavat projektipohjat              |
| `03-configs/`         | Toimivat asetukset ja määritykset       |
| `04-issues-resolved/` | Ratkaistut ongelmat ja ratkaisut        |
| `05-project-index/`   | Projektikohtaiset tiedot ja linkit      |

---

## Tärkeimmät viittausdokumentit

- **Uusi projekti (Next.js)**: `01-workflows/new-project-setup.md`
- **System instructions**: `01-workflows/SYSTEM_INSTRUCTIONS.md`
- **Workflow rules**: `01-workflows/workflow-rules.md`
- **Expo → Vercel web PWA**: `01-workflows/expo-vercel-web-deploy.md`
- **Arkkitehtuuri**: `03-configs/ARCHITECTURE.md`
- **UI/UX standardit**: `03-configs/UI_UX_STANDARDS.md`
- **MCP integraatio**: `03-configs/MCP_INTEGRATION.md`
- **Supabase MCP**: `03-configs/supabase/mcp-setup.md`
- **Supabase OAuth**: `03-configs/supabase/oauth-providers.md`
- **Supabase keep-alive**: `03-configs/supabase/keep-alive-heartbeat.md`
- **Vercel MCP**: `03-configs/vercel/mcp-setup.md`
- **Vercel deployment**: `03-configs/vercel/project-settings.md`
- **Vercel ei deployaa**: `04-issues-resolved/vercel-github-trigger-2025-06-16.md`
- **Git push -auto ei toimi**: `04-issues-resolved/git-push-vaatii-ide-allowlist-2026-06-23.md`

---

## DOX-yhteensopivuus

Tämä knowledgebase noudattaa DOX-sääntöjä:

- Jokaisella kansiolla on oma `AGENTS.md`
- Alikansioiden säännöt täydentävät näitä sääntöjä
- Ristiriitatilanteessa spesifimpi sääntö voittaa
