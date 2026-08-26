# Gemini Devin Karuselli - Project Index

**Tiedostonimi**: `Gemini-Devin-Karuselli.md`  
**Projektin kansio**: `C:\TYO\GitHub Local\Gemini Devin Karuselli`  
**GitHub-repo**: https://github.com/Spalmgre/Gemini-Devin-Karuselli  
**Status**: Kehitys

---

## Yleiskuva

**Tyyppi**: CLI / orkestroija  
**Teknologiat**: Python 3.10+, google-genai, requests, python-dotenv  
**Tarkoitus**: Kytkee Gemini-arkkitehdin ja Cognition AI:n Devin-koodausagentin automaattiseen kehityssilmukkaan. Gemini analysoi Devinin suorituksia ja päättää seuraavan toimenpiteen (`CONTINUE` / `STOP_REVIEW` / `DONE`).

---

## Knowledgebase-yhteensopivuus

**Knowledgebase-versio**: 1.0  
**Viimeksi päivitetty**: 2026-08-26

### Noudatetut määritykset

- [ ] `01-workflows/new-project-setup.md` käytetty (projekti perustettu ennen workflow'ta — AGENTS.md ja `.devin/config.json` lisätty jälkikäteen 2026-08-26)
- [x] `01-workflows/SYSTEM_INSTRUCTIONS.md` luettu
- [x] `01-workflows/workflow-rules.md` luettu
- [x] `03-configs/ARCHITECTURE.md` luettu ja noudatettu
- [x] `03-configs/UI_UX_STANDARDS.md` luettu (ei UI:ta tässä projektissa)
- [x] `03-configs/devin/ide-setup.md` luettu — `.devin/config.json` permissions luotu

### Dokumentoidut poikkeamat

| Kohta | Knowledgebase | Tämä projekti | Syy |
|-------|---------------|---------------|-----|
| Framework | Next.js + Supabase | Puhdas Python CLI | Orkestroijasovellus, ei web-sovellus |
| Backend | Supabase / Firebase | Gemini API + Devin API | Ulkoiset API:t, ei omaa tietokantaa |
| Hosting | Vercel / Firebase | Ei hostingia | Ajetaan paikallisesti |

---

## Linkit

| Palvelu | URL | Huomiot |
|---------|-----|---------|
| **GitHub** | https://github.com/Spalmgre/Gemini-Devin-Karuselli | |
| **Devin** | https://api.devin.ai | Cognition AI REST API |

---

## Asetukset

- **Konfiguraatio**: `.env` (`GEMINI_API_KEY`, `DEVIN_API_KEY`, `POLL_INTERVAL_SECONDS`, `POLL_TIMEOUT_MINUTES`, `MAX_ITERATIONS`) — ei gitissä
- **Devin permissions**: `.devin/config.json` (allow: python/pip/git/gh, deny: tuhoavat komennot + `.env`-kirjoitukset)

---

## Ratkaistut ongelmat (tässä projektissa)

*(ei vielä dokumentoituja)*

---

## Muistiinpanot

Silmukan turvamekanismit: `STOP_REVIEW`-ihmisportti, `MAX_ITERATIONS`-katkaisu, backoff-retry Devin API:lle, JSON-parsintavirhe → `STOP_REVIEW`-fallback.
