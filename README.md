# Dev Knowledgebase - Keskitetty Osaamispankki

Tämä knowledgebase sisältää toistettavat menetelmät, asetukset ja ohjeet kaikille projekteille.

## Pikaohjeet

### Uusi projekti käynnistettävänä

```
1. Lue: 01-workflows/new-project-setup.md
2. Kopioi pohja: 02-templates/nextjs-supabase/
3. Seuraa workflow vaiheet 1-8
```

### Ongelma: Vercel ei deployaa GitHub-pushista

```
1. Lue: 01-workflows/vercel-github-troubleshoot.md
2. Tarkista kohta 3 (Webhook-asetukset)
3. Jos ei auta: 04-issues-resolved/vercel-github-trigger-2025-06-16.md
```

### Ratkaisu löytyi - miten globaaliksi?

```
Sano agentille: "Lisää tämä knowledgebaseen"
→ Agentti luo dokumentin 04-issues-resolved/
→ Saat ilmoituksen: "Kirjattu knowledgebaseen: [tiedostonimi]"
```

## Hakemistorakenne

```
dev-knowledgebase/
├── 01-workflows/          # Vaiheittaiset prosessit
├── 02-templates/          # Projektien pohjat
├── 03-configs/            # Toimivat asetukset
├── 04-issues-resolved/    # Ratkaistut ongelmat
└── 05-project-index/      # Projektikohtaiset tiedot
```

## Projektit

| Projektin nimi  | Tyyppi | Status     |
| --------------- | ------ | ---------- |
| Klack-SaaS-Chat | Web    | Aktiivinen |
| Klack-Treeni    | Web    | Aktiivinen |
| Klack-Web       | Web    | Aktiivinen |
| Melba-CRM-Talk  | Web    | Aktiivinen |
| MelbAi-Hub      | Web    | Aktiivinen |

Lue tarkemmat tiedot: `05-project-index/`
