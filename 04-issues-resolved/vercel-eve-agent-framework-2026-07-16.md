# Vercel EVE - Agent Framework käyttömalli

## Ongelma

Uusille agenttiprojekteille puuttui yhteinen tapa arvioida ja ottaa käyttöön Vercelin EVE-agenttikehys. Vanhoihin projekteihin kohdistuva automaattinen migraatio olisi riskialtis ja tarpeeton ilman käyttötapauskohtaista arviointia.

## Oireet

- Agenttiprojektin toteutusmalli olisi pitänyt valita tapauskohtaisesti ilman yhteistä kriteeristöä.
- EVE:n scaffoldauskomentoa olisi voitu ajaa olemassa olevaan projektiin ilman migraatiosuunnitelmaa.
- Kestävät sessiot, hyväksynnät, sandbox, yhteydet, kanavat, jäljitettävyys ja evalit olisivat voineet jäädä suunnittelematta.

## Juurisyy

EVE on uusi tuotantoon suunnattu agenttikehys, jota ei ollut dokumentoitu knowledgebaseen eikä lisätty uuden projektin arviointivaiheeseen.

## Ratkaisu

1. Luo uusi EVE-agentti erilliseen hakemistoon komennolla `npx eve@latest init my-agent`.
2. Arvioi ensin, tarvitseeko projekti EVE:n tarjoamia pitkäkestoisia sessioita, hyväksyntöjä, sandboxia, useita kanavia, yhteyksiä tai evaleja.
3. Aloita `agent/instructions.md`- ja `agent/agent.ts`-tiedostoista; lisää työkalut, taidot, yhteydet, kanavat, aliedustajat, ajastukset ja evalit vain tarpeen mukaan.
4. Vaadi hyväksyntä kaikille vaikutuksellisille toiminnoille, pidä salaisuudet palvelinpuolella ja testaa kriittiset työnkulut evaleilla.
5. Arvioi vanha projekti erikseen. Tee korkeintaan rajattu proof of concept, jos agenttirajapinta voidaan eriyttää ja EVE:n kyvykkyydet ratkaisevat todellisen tarpeen.
6. Dokumentoi päätös projektin `05-project-index/[projekti].md`-tiedostoon.

Yksityiskohtainen ohje on `03-configs/vercel/eve-agent-framework.md`-tiedostossa. Uuden projektin workflow ohjaa arvioimaan EVE:n vain uusille agenttiprojekteille.

## Konteksti

- **Knowledgebase:** `dev-knowledgebase`
- **Päivä:** 2026-07-16
- **Lähteet:** EVE:n dokumentaatio, Vercelin julkaisu ja `vercel/eve`-repository.

## Avainsanat

vercel, eve, agent framework, agentti, durable workflow, approval, sandbox, mcp, evals, observability, migration
