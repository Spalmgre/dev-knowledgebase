# Päivittää kaikkiin C:\TYO\GitHub Local -kansion projekteihin
# pakollisen knowledgebase-alustusosion AGENTS.md-tiedostoihin.
# Aja kerran kun uusia projekteja tai knowledgebase-päivityksiä tulee.

$basePath = "C:\TYO\GitHub Local"
$requiredSection = @"

## Pakollinen alustus (tee aina ennen työn aloittamista)

1. Hae viimeisimmät knowledgebase-päivitykset:
   ```bash
   cd C:\TYO\GitHub Local\dev-knowledgebase && git pull origin main
   ```
2. Lue knowledgebase-määritykset:
   - `AGENTS.md`
   - `01-workflows/SYSTEM_INSTRUCTIONS.md`
   - `01-workflows/workflow-rules.md`
   - `03-configs/ARCHITECTURE.md`
   - `03-configs/UI_UX_STANDARDS.md`
   - `03-configs/MCP_INTEGRATION.md`
   - `03-configs/devin/ide-setup.md`
3. Varmista että tämän projektin `AGENTS.md` on yhdenmukainen knowledgebasen kanssa. Jos knowledgebase on päivittynyt, päivitä myös tämä tiedosto.
"@

Get-ChildItem -Path $basePath -Directory | ForEach-Object {
    $agentsPath = Join-Path $_.FullName "AGENTS.md"
    if (Test-Path $agentsPath) {
        $content = Get-Content $agentsPath -Raw
        if ($content -match "## Pakollinen alustus") {
            Write-Host "OK: $($_.Name) - alustusosa jo olemassa"
        } else {
            Write-Host "PÄIVITETÄÄN: $($_.Name)"
            $content = $content + $requiredSection
            Set-Content -Path $agentsPath -Value $content -NoNewline
        }
    } else {
        Write-Host "OHITETAAN: $($_.Name) - ei AGENTS.md"
    }
}

Write-Host "Valmis. Tarkista muutokset ja commitoi/pushaa kukin projekti erikseen."
