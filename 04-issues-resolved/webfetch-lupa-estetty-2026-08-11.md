# Webfetch estyi lupasäännöissä — Fetch()-allow-sääntö permissions-listaan

## Ongelma

Agentti ei pystynyt lukemaan verkkosivuja `webfetch`-työkalulla. Istunnossa näkyi
virhe "Permission to fetch was denied". Hakutyökalu (`web_search`) toimi, mutta
suora sivujen luku oli estetty, mikä vaikeutti dokumentaation ja repositorioiden
tutkintaa.

## Oireet

- `webfetch`-kutsu palautui heti virheellä "Permission to fetch was denied"
- Normal-tilassa fetch-työkalut kysyvät aina luvan, ellei allow-sääntöä ole
- `%APPDATA%\devin\config.json`:n `permissions.allow`-listalla oli pelkkiä
  `Exec(...)`- ja `Write(...)`-sääntöjä — ei yhtään `Fetch(...)`-sääntöä

## Juurisyy

Devin CLI:n permission-järjestelmä jakaa työkalut luokkiin. `webfetch` kuuluu
**Fetch**-luokkaan, joka Normal-tilassa on oletuksena "Prompt" (kysy aina).
Tarkistusjärjestys on `deny → ask → allow → oletus (kysy)`, ja koska mikään
sääntö ei matchannut, lupa piti hyväksyä jokaiselle haulle erikseen — tai
kuten tässä tapauksessa, haku estyi kokonaan.

## Ratkaisu

Lisää käyttäjätason konfigiin `%APPDATA%\devin\config.json` → `permissions.allow`:

```json
"Fetch(https://*)",
"Fetch(http://*)"
```

Keskeiset kohdat:

1. `Fetch()`-mallit noudattavat **WHATWG URL Pattern** -standardia, jossa pelkkä
   `*` on "full wildcard" ja matchaa minkä tahansa hostin ja polun. Yksi rivi
   riittää kattamaan kaikki HTTPS-haut — älä lisää domain-kohtaisia rivejä.
2. Käyttäjätason konfigi koskee kaikkia projekteja kerralla (sama periaate kuin
   `agentti-kysyy-lupaa-jokaiseen-komentoon-2026-07-31`-ratkaisun Exec-säännöissä).
3. Sääntö astuu voimaan **heti ilman uudelleenkäynnistystä** — varmistettu
   testihau'lla `https://example.com` samassa istunnossa.
4. Deny voittaa edelleen aina: jos johonkin domainiin halutaan esto, lisää se
   `permissions.deny`-listaan esim. `Fetch(domain:evil.example.com)`.
5. Vaihtoehtoinen reitti ilman käsin editointia: kun webfetch kysyy lupaa,
   promptista löytyy valinta **"Yes, always allow all web fetches"**, joka
   kirjoittaa vastaavan säännön automaattisesti.

Jos haluaa rajata haut vain tiettyihin domaineihin eikä sallia kaikkia:

```json
"Fetch(https://api.github.com/*)",   // tietty polku
"Fetch(https://*.example.com/*)",    // alidomainit
"Fetch(domain:npmjs.org)"            // koko domain, mikä tahansa polku
```

## Konteksti

- Projekti: dev-knowledgebase (ratkaisu koskee kaikkia projekteja)
- Päivämäärä: 2026-08-11 (ratkaistu), kirjattu knowledgebaseen 2026-08-13
- Tehdyt muutokset:
  - `%APPDATA%\devin\config.json` → lisätty `Fetch(https://*)` ja `Fetch(http://*)` allow-listaan
  - `03-configs/devin/ide-setup.md` → v2.2, Fetch-säännöt lisätty suositeltuun permissions-pohjaan
- Liittyy: `04-issues-resolved/agentti-kysyy-lupaa-jokaiseen-komentoon-2026-07-31.md`
  (sama permission-järjestelmä, Exec-puoli)

## Avainsanat

webfetch, web fetch, fetch, Fetch(), Permission to fetch was denied,
permissions.allow, URL pattern, WHATWG, config.json, verkkohaku, sivujen luku,
dokumentaation luku, allow list, Devin CLI, ACP
