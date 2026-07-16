# Vercel EVE - Agent Framework

EVE on Vercelin avoimen lähdekoodin agenttikehys tuotantokäyttöön. Se soveltuu ensisijaisesti uusiin projekteihin, joiden keskeinen toiminnallisuus on itsenäinen tai keskusteleva AI-agentti.

**Päivitetty**: 2026-07-16  
**Versio**: 1.0  
**Tila**: Beta — tarkista aina ajantasainen dokumentaatio ennen käyttöönottoa.

---

## Milloin käytetään

Käytä EVEä uudessa agenttiprojektissa, kun tarvitaan vähintään yksi seuraavista:

- Pitkäkestoinen, keskeytyvä ja jatkettava agenttityö.
- Työkalukutsuja, aliedustajia, ajastuksia tai useita käyttökanavia.
- Hyväksyntä ennen vaikutuksellista toimenpidettä.
- Eristetty ympäristö agentin ajamalle koodille.
- Jäljitettävyys ja evalit ennen tuotantoon vientiä.

EVE ei ole oletusvalinta tavalliselle web-sovellukselle, yksittäiselle LLM-kutsulle tai olemassa olevan sovelluksen pieneen AI-ominaisuuteen. Arvioi silloin kevyempi toteutus erikseen.

---

## Uuden agenttiprojektin alustus

1. Varmista projektin tavoite, käyttäjät, data, työkalut, integraatiot ja vaikutukselliset toiminnot.
2. Alusta erillinen projekti:

```bash
npx eve@latest init my-agent
```

3. Komento luo projektihakemiston, asentaa riippuvuudet, alustaa Gitin ja käynnistää interaktiivisen terminaalikäyttöliittymän.
4. Avaa luotu projekti ja tee ensimmäinen toteutus vain näihin tiedostoihin:
   - `agent/instructions.md`: agentin pysyvä rooli, rajat ja toimintaperiaatteet.
   - `agent/agent.ts`: malli ja tarvittavat runtime-asetukset.
5. Käynnistä paikallinen kehitys projektin generoimalla komennolla, yleensä `npm run dev` tai `eve dev`.
6. Lisää kyvykkyydet vain tarpeen mukaan ja testaa ne evaleilla ennen tuotantoa.

> Älä aja `npx eve@latest init .` olemassa olevassa projektissa ilman erillistä suunnitelmaa ja puhdasta Git-tilaa. Se on scaffoldauskomento, ei riskitön migraatio.

---

## Suositeltu rakenne

```text
my-agent/
├── package.json
└── agent/
    ├── agent.ts
    ├── instructions.md
    ├── tools/
    ├── skills/
    ├── connections/
    ├── channels/
    ├── subagents/
    ├── schedules/
    └── evals/
```

- `instructions.md`: aina mukana oleva system prompt. Kirjaa tehtävä, datarajat, turvallisuusrajat ja vastaustapa.
- `agent.ts`: valittu malli sekä agentin runtime-määritykset.
- `tools/`: tyypitetyt, rajatut funktiot agentin käyttöön.
- `skills/`: pidemmät, tarvittaessa ladattavat toimintamenettelyt.
- `connections/`: MCP- tai OpenAPI-yhteydet. Tunnisteita ja avaimia ei anneta mallille.
- `channels/`: käyttökanavien adapterit; HTTP on käytettävissä oletuksena.
- `subagents/`: selkeästi rajatut delegoidut tehtävät.
- `schedules/`: toistuvat ajastetut työt.
- `evals/`: toistettavat odotusten, työkalukutsujen ja vastausten testit.

Aloita `instructions.md`- ja `agent.ts`-tiedostoilla. Lisää kansio vasta, kun käyttötapaus sitä tarvitsee.

---

## Toteutusperiaatteet

1. **Tee työkalut pieniksi ja tyypitetyiksi.** Jokaisella työkalulla on yksi vastuu, validoitu syöte ja rajattu tulos.
2. **Suojaa vaikutukselliset toimenpiteet.** Vaadi hyväksyntä ennen kirjoituksia, julkaisuja, maksutoimia, tietojen poistamista tai ulkoisia viestejä.
3. **Pidä salaisuudet palvelinpuolella.** Käytä ympäristömuuttujia ja yhteysmäärityksiä; älä tallenna avaimia `instructions.md`-, `skills/`- tai client-tiedostoihin.
4. **Hyödynnä sandboxia epäluotetulle koodille.** Agentin generoimaa koodia ei saa ajaa sovelluksen omassa runtime-ympäristössä.
5. **Tee evalit jokaiselle kriittiselle työnkululle.** Testaa ainakin onnistuminen, puuttuva data, virheellinen syöte, työkalun epäonnistuminen ja hyväksynnän vaatima toiminto.
6. **Seuraa ajoja.** Tarkista traceista mallin ja työkalujen toiminta; vie OpenTelemetry-data käytössä olevaan observability-palveluun.

---

## Vercel-käyttöönotto

EVE tarjoaa kestävät sessiot Workflow SDK:n avulla, sandboxin Vercel Sandboxilla sekä Vercel Observabilityn Agent Runs -näkymän. Kun projekti julkaistaan Verceliin, lue myös `project-settings.md`, `environment-variables.md` ja tarvittaessa `mcp-setup.md`.

- Valitse malli ja palveluntarjoaja projektin vaatimusten mukaan.
- Lisää kaikki palvelinpuoliset tunnisteet Vercelin Environment Variables -asetuksiin; älä käytä `NEXT_PUBLIC_`-etuliitettä salaisuuksille.
- Testaa durable sessionin jatkaminen, hyväksynnät, yhteydet ja sandbox-käyttö preview-ympäristössä.
- Aja evalit CI:ssä ennen production-deploymentia.

---

## Vanhojen projektien arviointi

EVEä ei oteta automaattisesti käyttöön olemassa oleviin projekteihin. Tee projekti- ja käyttötapauskohtainen päätös ennen migraatiota.

| Kysymys | Jos vastaus on kyllä | Jos vastaus on ei |
|---------|---------------------|------------------|
| Onko agentti sovelluksen keskeinen pitkäkestoinen työnkulku? | Jatka arviointia. | Älä lisää EVEä pelkän AI-ominaisuuden vuoksi. |
| Tarvitaanko durabilityä, hyväksyntiä, sandboxia, kanavia tai evaleja? | EVE voi ratkaista useita tarpeita yhdellä mallilla. | Nykyinen toteutus voi olla tarkoituksenmukaisempi. |
| Voidaanko agenttirajapinta erottaa nykyisestä sovelluslogiikasta? | Tee rajattu proof of concept erilliseen haaraan tai palveluun. | Älä tee laajaa migraatiota. |
| Onko omistaja, evalit ja observability sovittu? | Suunnittele tuotantokäyttöönotto. | Ratkaise nämä ennen toteutusta. |

Arvioinnin lopputulos dokumentoidaan projektin `05-project-index/[projekti].md`-tiedostoon: käyttötapaus, päätös, perustelu, riskit ja seuraava tarkistusajankohta.

---

## Tarkistuslista uudelle EVE-agentille

- [ ] Käyttötapaus edellyttää agenttiruntimea eikä kevyempi toteutus riitä.
- [ ] `npx eve@latest init my-agent` ajettu erilliseen uuteen hakemistoon.
- [ ] `agent/instructions.md` määrittää tehtävän, rajat ja turvallisuussäännöt.
- [ ] Malli ja runtime on määritetty `agent/agent.ts`-tiedostossa.
- [ ] Jokaisella työkalulla on validoitu syöte ja rajattu vastuu.
- [ ] Vaikutukselliset työkalut vaativat hyväksynnän.
- [ ] Salaisuudet ovat vain palvelinpuolen ympäristömuuttujissa tai turvallisissa yhteyksissä.
- [ ] Kriittisille työnkuluille on evalit.
- [ ] Trace- ja virheiden seuranta on testattu.
- [ ] Preview- ja production-käyttöönotto on testattu Vercelissä, jos Verceliä käytetään.

---

## Lähteet

- [EVE documentation](https://eve.dev/docs/introduction)
- [vercel/eve GitHub repository](https://github.com/vercel/eve)
- [Introducing eve - Vercel](https://vercel.com/blog/introducing-eve)
- [Vercel Agentic Infrastructure](https://vercel.com/?utm_medium=influencer&utm_campaign=Agent-Stack&utm_source=youtube&utm_content=dedicated&utm_term=colemedin&ref=plug.dev)
