# Klack-Treeni - Project Index

**Tiedostonimi**: `Klack-Treeni.md`  
**Projektin kansio**: `C:\TYO\GitHub Local\Klack-Treeni`  
**GitHub-repo**: https://github.com/Spalmgre/Klack-Treeni  
**Status**: Aktiivinen

---

## Yleiskuva

**Tyyppi**: Multi-platform (iOS / Android / Web PWA)  
**Teknologiat**: Expo SDK 54 (~54.0.33), React Native 0.81.5, React 19.1, TypeScript 5.9, @supabase/supabase-js 2.87, React Navigation 7 (native-stack), react-native-web 0.21, AsyncStorage, uuid, @vercel/speed-insights  
**Tarkoitus**: Treenien seurantasovellus (treenipohjat, treenikerrat, liikepankki). Local-first + Supabase-sync. Suomenkielinen UI.

---

## Knowledgebase-yhteensopivuus

**Knowledgebase-versio**: 1.0  
**Viimeksi päivitetty**: 2026-07-16  
**Sovelluksen versio**: v2.70 (versiointi: Dashboard/Login-footerit + Projectlog.md; `package.json` version on vanhentunut eikä sitä käytetä)

### Noudatetut määritykset

- [x] Vercel-deployment GitHub-pushista (auto)
- [x] Supabase auth + cloud sync
- [ ] `01-workflows/new-project-setup.md` — EI sovellu sellaisenaan (Next.js-pohja)
- [x] `01-workflows/SYSTEM_INSTRUCTIONS.md` luettu
- [x] `01-workflows/workflow-rules.md` luettu
- [x] `03-configs/ARCHITECTURE.md` luettu; sovellettu Expo/RN-kontekstiin, poikkeukset dokumentoitu alla
- [x] `03-configs/UI_UX_STANDARDS.md` luettu; sovellettu Expo/RN-kontekstiin, poikkeukset dokumentoitu alla
- [x] `03-configs/MCP_INTEGRATION.md` luettu (MCP-palvelimet saatavilla)
- [ ] `03-configs/supabase/oauth-providers.md` — ei OAuth-providereita käytössä (email-auth)

### Dokumentoidut poikkeamat

- **EI Next.js** — projekti on **Expo + react-native-web**, jonka web-build deployataan Vercelille. `02-templates/`-pohjat ja Next.js-workflowt eivät sovellu sellaisenaan.
- **Supabase-konfiguraatio kovakoodattu** tiedostossa `config/supabase.ts` (`SUPABASE_URL` + `SUPABASE_ANON_KEY`), ei `NEXT_PUBLIC_*` env-muuttujia. Auth-storage = AsyncStorage; `detectSessionInUrl` vain webissä.
- **DB-malli**: `plans` ja `workouts` tallentavat lihasryhmät/liikkeet `muscle_groups`-**JSONB**-sarakkeeseen (ei normalisoituja liiketauluja) → liike-kenttien lisäys ei vaadi SQL-migraatiota.
- **Local-first + Supabase-sync** (offline-first): paikallinen tila on totuus, joka synkataan pilveen.
- **DOX-hierarkia**: jokaisessa alikansiossa oma `AGENTS.md`, joka pitää lukea ennen muokkausta.

---

## Linkit

| Palvelu      | URL                                      | Huomiot                                                                   |
| ------------ | ---------------------------------------- | ------------------------------------------------------------------------- |
| **GitHub**   | https://github.com/Spalmgre/Klack-Treeni | Auto-deploy Verceliin main-branchista                                     |
| **Supabase** | https://cklzrolyxbbiyqnwddzd.supabase.co | Ref `cklzrolyxbbiyqnwddzd`; URL+anon key tiedostossa `config/supabase.ts` |
| **Vercel**   |                                          | Web PWA; `vercel.json` SPA-rewrite `/(.*) → /index.html`                  |

---

## Asetukset

- **Build/dev**: `npm run web` (Expo web), `npm run start` (Expo), `npm run ios` / `npm run android`. Tyyppitarkistus: `npx tsc --noEmit`.
- **Vercel**: SPA-rewrite (`vercel.json`) ohjaa kaikki reitit `index.html`:ään.
- **GitHub Actions**: `supabase-heartbeat.yml` pitää Supabase-projektin hereillä (ettei pausetu).
- **Navigaatio**: React Navigation native-stack (ei tab-navigaatiota).
- **Skinit/teemat**: winter / autumn / spring / summer (`styleVariants.ts`, `getVariant(skin)`).

---

## Ratkaistut ongelmat

| Päivämäärä | Ongelma                                         | Knowledgebase-dokumentti                                         |
| ---------- | ----------------------------------------------- | ---------------------------------------------------------------- |
| 2026-06-23 | Git push -auto vaatii IDE-allowlistin (`git *`) | `04-issues-resolved/git-push-vaatii-ide-allowlist-2026-06-23.md` |

---

## Muistiinpanot

- Globaalit säännöt projektin juuren `AGENTS.md`:ssä: suomenkielinen UI aina, local-first + Supabase-sync, versiointityönkulku (footerit + Projectlog.md), `git add -A && git commit && git push` automaattisesti valmiiden muutosten jälkeen.
- Sovellusversio kasvaa footereista (`DashboardScreen`, `LoginScreen`) ja `Projectlog.md`-merkinnästä — ei `package.json`:sta.
- Juuri- ja projektin `AGENTS.md` -tiedostojen null-byte -korruptio poistettu ja koodiblokkien muotoilu korjattu 2026-07-16.
