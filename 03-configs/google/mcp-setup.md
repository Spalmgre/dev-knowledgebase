# Google Cloud MCP -konfiguraatio

Tämä tiedosto määrittelee Devin/Cascade-ympäristöön kytkettävät Google Cloud -MCP-palvelimet, jotka antavat agentille suoran pääsyn gcloud CLI:hin, Cloud Storageen ja tarvittaessa muihin GCP-resursseihin.

**Päivitetty**: 2026-07-16  
**Versio**: 1.0

---

## Suositellut Google MCP -palvelimet

| Palvelin | Paketti / endpoint | Käyttötarkoitus |
|----------|-------------------|-----------------|
| `google-cloud-gcloud` | `npx -y @google-cloud/gcloud-mcp` | gcloud CLI -komennot (GCS, Cloud Run, Secret Manager, IAM, Firebase Functions jne.) |
| `google-cloud-storage` | `npx -y @google-cloud/storage-mcp` | Cloud Storage -bucketit ja objektit suoraan |
| `google-cloud-observability` | `npx -y @google-cloud/observability-mcp` | Logging, Monitoring, Trace, Error Reporting |

Vaihtoehtoisesti Cloud Storageen voi käyttää myös virallista remote-endpointia:

```
https://storage.googleapis.com/storage/mcp
```

Remote-endpoint vaatii OAuth- tai palvelutunnistautumisen.

---

## Devin / Cascade -konfiguraatio

Tiedosto: `%APPDATA%\devin\config.json` (Windows) / `~/.config/devin/config.json` (macOS/Linux)

```json
{
  "mcpServers": {
    "google-cloud-gcloud": {
      "command": "npx",
      "args": ["-y", "@google-cloud/gcloud-mcp"]
    },
    "google-cloud-storage": {
      "command": "npx",
      "args": ["-y", "@google-cloud/storage-mcp"]
    },
    "google-cloud-observability": {
      "command": "npx",
      "args": ["-y", "@google-cloud/observability-mcp"]
    }
  }
}
```

---

## Autentikointi

Paikalliset stdio-MCP:t käyttävät gcloudin Application Default Credentialsia.

1. Varmista, että gcloud on asennettu ja kirjautunut sisään:
   ```bash
   gcloud auth login
   gcloud auth application-default login
   ```
2. Aseta aktiivinen projekti tarvittaessa:
   ```bash
   gcloud config set project melbai-hub
   ```

Jos haluat käyttää palvelutiliä, aseta ympäristömuuttuja configiin:

```json
"env": {
  "GOOGLE_APPLICATION_CREDENTIALS": "C:\\path\\to\\service-account-key.json"
}
```

---

## Tietoturva

- Älä lisää palvelutilien JSON-avaimia gitiin.
- Käytä mieluummin `gcloud auth application-default login` -paikallista autentikointia kuin kovakoodattuja avaimia.
- Aseta IAM-roolit suppeasti: esimerkiksi `roles/storage.objectAdmin` vain tarvittaville bucketeille.

---

## Testaus

Kun konfiguraatio on tallennettu, käynnistä Devin/Cascade uudelleen ja tarkista, että palvelimet ilmestyvät MCP-listaan. Ensimmäisellä käyttökerralla `npx` asentaa paketit automaattisesti.

---

## Lisätiedot

- [gcloud-mcp GitHub](https://github.com/googleapis/gcloud-mcp)
- [Cloud Storage MCP docs](https://docs.cloud.google.com/storage/docs/use-cloud-storage-mcp)
- [Google Cloud MCP overview](https://docs.cloud.google.com/mcp/overview)
