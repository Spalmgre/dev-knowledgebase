# Klack-SDD - Project Index

**Tiedostonimi**: `Klack-SDD.md`  
**Projektin kansio**: `C:\TYO\GitHub Local\Klack-SDD`  
**GitHub-repo**: https://github.com/Spalmgre/Klack-SDD  
**Status**: Kehitys (v0.01, vaihe 1: SDD-purku ja rakenneanalyysi)

---

## Yleiskuva

**Tyyppi**: Desktop + paikallinen web-UI (Windows 11, selain `http://klack-rea`)  
**Teknologiat**: Määritellään vaiheessa 2 (UI-pohja kopioidaan MyBrainSP:stä); työkaluja Node.js (carve-isc.js); RE: `morluto/rea` MCP; ajoneuvoliitäntä J2534 (MongoosePro JLR, x86-silta WOW64)  
**Tarkoitus**: JLR SDD 131/132 -ohjelmiston reverse engineering → moderni diagnostiikka-, ohjelmointi- ja kustomointiohjelmisto n. 1998–2012 Jaguar/Land Rover -malleille, OpenRouter.ai-agentilla varustettuna.

---

## Knowledgebase-yhteensopivuus

**Knowledgebase-versio**: 1.1 (documentation-standard)  
**Viimeksi päivitetty**: 2026-11-12  

### Noudatetut määritykset

- [x] `01-workflows/SYSTEM_INSTRUCTIONS.md` luettu
- [x] `01-workflows/workflow-rules.md` luettu (jaettu työpuu, nimetyt polut commitissa)
- [x] `03-configs/documentation-standard.md` sovellettu (AGENTS.md, HANDOVER.md, VERSION, docs/dumps/ — kaikki luotu 2026-11-12)
- [x] `03-configs/devin/project-window-colors.md` — viininpunainen `#5A1E2E` asetettu juuren ja docs/.vscode/settings.json
- [ ] `03-configs/ARCHITECTURE.md` / `UI_UX_STANDARDS.md` — sovelletaan vasta vaiheessa 2 (UI-kopiointi)
- Ei sovellu (ei käytössä): Supabase, Vercel, OAuth, keep-alive — projekti on 100 % paikallinen

### Dokumentoidut poikkeamat

| Kohta | Knowledgebase | Tämä projekti | Syy |
|-------|---------------|---------------|-----|
| Hosting | Vercel tms. | Paikallinen palvelin `http://klack-rea` | ECU-flashing ei saa riippua internetistä |
| Tietokanta | Supabase tms. | Ei vielä / paikallinen | Offline-first-vaatimus |
| Dump-malli | Generoidut (MelbAi-Hub) tai käsin (MyBrainSP) | Käsin ylläpidetyt (MyBrainSP-malli) | Ei build-infrastruktuuria vielä |
| Versio | VERSION-vakio koodissa | `VERSION`-tiedosto juuressa | Ei koodikantaa vielä; siirretään koodiin kun runko syntyy |

---

## Linkit

| Palvelu | URL | Huomiot |
|---------|-----|---------|
| **Production** | `http://klack-rea` (paikallinen) | ei julkaistu vielä |
| **GitHub** | https://github.com/Spalmgre/Klack-SDD | private |

---

## Asetukset

Ei Supabase-/Vercel-määrityksiä. Paikallinen verkko-osoite: Windows hosts `127.0.0.1 klack-rea` + porttiohjaus (toteutetaan vaiheessa 2).

## Rakenteen erityispiirteet

- `JLR_Root/`, `extracted/`, `work/`, `output/` jätetty tarkoituksella `.gitignore`-suojattuina (GB-kokoiset SDD-binäärit).
- Kohdeajoneuvot: n. 1998–2012 JLR. Lähdealusta SDD 131→132 (offline), referenssi SDD 130 (.ova).

## Ratkaistut ongelmat (tässä projektissa)

| Päivämäärä | Ongelma | Knowledgebase-dokumentti |
|------------|---------|--------------------------|
| — | (ei vielä) | — |

---

## Muistiinpanot

- PRD: `docs/PRD.md` (vaiheistus 1–5: purku → UI-runko → x86 J2534-silta → diagnostiikka+AI+telemetria → kenttätestaus)
- UI-referenssi: `C:\TYO\GitHub Local\MyBrainSP`
