# Java (JDK) puuttuu Windows-koneelta — asennus wingetillä

## Ongelma

Koneelta puuttui Java kokonaan, joten Javaa vaativat työkalut (esim. Android-buildit,
Gradle, Firebase-emulaattorit, Keytool/SHA-sertifikaatit) eivät toimineet.

## Oireet

```
java : The term 'java' is not recognized as a name of a cmdlet, function, script file, or executable program.
```

Lisäksi:

- `where.exe java` → `INFO: Could not find files for the given pattern(s).`
- `$env:JAVA_HOME` → tyhjä
- Kansioita `C:\Program Files\Java`, `C:\Program Files\Eclipse Adoptium`,
  `C:\Program Files\Microsoft\jdk*` ei ollut olemassa

## Juurisyy

JDK:ta ei ollut koskaan asennettu koneelle. Windows ei sisällä Javaa vakiona.

Sivuhuomio: ensimmäinen tarkistusyritys epäonnistui virheeseen
`Permission denied for this tool`, koska agentti oli **Plan-tilassa**, jossa
komentojen ajo on estetty. Vaihda Normal-tilaan ennen asennuskomentoja.

## Ratkaisu

### 1. Tarkista nykytila (aja aina ensin)

```powershell
java -version 2>&1
where.exe java 2>&1
$env:JAVA_HOME
Get-ChildItem 'C:\Program Files\Java','C:\Program Files\Eclipse Adoptium','C:\Program Files\Microsoft\jdk*','C:\Program Files (x86)\Java' -ErrorAction SilentlyContinue | Select-Object FullName
```

### 2. Varmista että winget on käytettävissä

```powershell
winget --version    # esim. v1.29.280
```

### 3. Asenna Eclipse Temurin JDK 21 (LTS)

```powershell
winget install --id EclipseAdoptium.Temurin.21.JDK -e --accept-source-agreements --accept-package-agreements
```

Asennus kestää muutaman minuutin (MSI ladataan GitHubista). Odota
`Successfully installed` -viestiä; älä keskeytä.

Vaihtoehtoiset paketit tarpeen mukaan:

- `Microsoft.OpenJDK.21` (Microsoft Build of OpenJDK)
- `EclipseAdoptium.Temurin.17.JDK` (jos työkalu vaatii Java 17, esim. vanhemmat Gradle-versiot)

### 4. Varmista asennus

```powershell
& 'C:\Program Files\Eclipse Adoptium\jdk-21.0.12.8-hotspot\bin\java.exe' -version
[Environment]::GetEnvironmentVariable('JAVA_HOME','Machine')
([Environment]::GetEnvironmentVariable('Path','Machine')) -split ';' | Where-Object { $_ -match 'jdk|Adoptium|Java' }
```

Odotettu tulos:

```
openjdk version "21.0.12" 2026-07-21 LTS
OpenJDK Runtime Environment Temurin-21.0.12+8 (build 21.0.12+8-LTS)
JAVA_HOME = C:\Program Files\Eclipse Adoptium\jdk-21.0.12.8-hotspot\
PATH sisältää: C:\Program Files\Eclipse Adoptium\jdk-21.0.12.8-hotspot\bin
```

Temurin-asennin asettaa `JAVA_HOME`-muuttujan ja PATH-merkinnän automaattisesti —
niitä ei tarvitse lisätä käsin.

### 5. TÄRKEÄ viimeinen vaihe: avaa uusi terminaali

`java -version` **ei toimi** jo avoinna olevissa terminaaleissa eikä IDE:n
integroidussa terminaalissa, koska prosessit käyttävät vanhaa
ympäristömuuttuja-snapshotia. Avaa uusi terminaali tai käynnistä Windsurf/IDE
uudelleen. Tämä ei ole vika asennuksessa.

Jos on pakko käyttää samaa istuntoa, päivitä PATH käsin:

```powershell
$env:JAVA_HOME = [Environment]::GetEnvironmentVariable('JAVA_HOME','Machine')
$env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
```

## Konteksti

- Kone: Windows (stefa), asennettu 2026-07-31
- Koskee kaikkia projekteja, joissa tarvitaan Javaa
- Asennettu versio: Eclipse Temurin JDK 21.0.12+8 (LTS)
- Polku: `C:\Program Files\Eclipse Adoptium\jdk-21.0.12.8-hotspot`

## Avainsanat

java, jdk, java ei löydy, java not recognized, JAVA_HOME, PATH, winget,
Temurin, Eclipse Adoptium, OpenJDK, Java 21, LTS, asennus, Windows,
gradle, keytool, android build, uusi terminaali, ympäristömuuttuja,
Permission denied for this tool, plan mode
