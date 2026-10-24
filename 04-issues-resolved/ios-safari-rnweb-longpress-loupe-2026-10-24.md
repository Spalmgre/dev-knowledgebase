# iOS Safari (React Native Web / PWA): suurennuslasi blokkaa long-pressin + modaali sulkeutuu kenttää napauttaessa

## Ongelma

Expo / react-native-web -sovellusta (Vercel-PWA) käytettiin iPhonella. Kg −/+ -painikkeiden
pitkä painallus (±5 kg toistuvana askelluksena) toimi Windows-PC:llä, mutta ei iPhonessa:
~0,5 s painalluksen jälkeen iOS Safarin tekstinvalinnan suurennuslasi (loupe) aktivoitui ja
katkaisi kosketuksen ennen long-press-viiveen (2100 ms) laukeamista.

Lisäksi kg-arvon napautuksesta avautuva numeromodaali sulkeutui heti kun tekstikenttää
napautettiin, eikä näppäimistö avautunut itsestään.

## Oireet

- Long-press-painike ei lauennut lainkaan iPhone-Safarissa; sen sijaan ruudulla näkyi
  suurennuslasi/valintahirvike.
- Modaalin tekstikentän napautus sulki koko modaalin (näppäimistön avautuminen aiheutti
  viewport-resizen kesken kosketuksen).
- `setTimeout(() => inputRef.current?.focus(), 100)` ei avannut näppäimistöä iPhonessa.

## Juurisyy

1. Valinnan esto (`user-select`) asetettiin vain painikkeiden label-teksteihin, ei koko
   painikkeen pinta-alalle eikä globaalisti; iOS Safarin OS-tason long-press-gestuuri
   ohittaa RNW-nativeen `Pressable.onLongPress`-suppression, kun elementtialue on
   "tekstimäinen". `-webkit-touch-callout`-estoa ei ollut lainkaan.
2. Modaalin sisältö oli tausta-`TouchableOpacity onPress={onClose}` -elementin lapsi.
   Näppäimistön avautuessa iOS Safari skaalaa/siirtää näkymää kesken kosketuksen →
   touchend osui taustaan → `onClose` laukesi. `onStartShouldSetResponder`-esto ei riitä.
3. iOS Safari sallii ohjelmallisen `.focus()`-kutsun vain suorana osana käyttäjän
   kosketustapahtumaa — ajastettu fokus ohitetaan hiljaa.

## Ratkaisu

### A. Suurennuslasin/valinta-estot webissä (`public/index.html`)

```html
<style>
  * { -webkit-tap-highlight-color: transparent; }
  #root div, #root span {
    -webkit-touch-callout: none;
    -webkit-user-select: none;
    user-select: none;
  }
</style>
<script>
  document.addEventListener("contextmenu", function (e) {
    var t = e.target;
    if (t && t.closest && !t.closest('input, textarea, [contenteditable="true"]')) {
      e.preventDefault();
    }
  }, true);
</script>
```

- RNW renderöi kaiken paitsi TextInputin `div`/`span`-elementteinä → tekstikentät säilyvät
  vapaana (input/textarea vaativat valinnan ja karetti-navigoinnin toimiakseen).
- `contextmenu`-esto auttaa myös Android Chrome -long-press-valikkoon.
- Lisäksi RN-puolella: painikkeen (Pressable) styleen `userSelect: 'none'` KOKO
  painikkeelle, ei vain labeliin.
- Long-press-viive lyhennetty 2100 → 700 ms: laukeaa ennen OS-gesturia ja tuntuu
  reippaammalta. Säilytetään natiivi `Pressable.onLongPress` + `delayLongPress` —
  ÄLÄ palaa JS-timeout-ajastimiin (ne rikkoivat sisäkkäiset vieritysalueet Treeni-näkymässä).

### B. Modaalin sulkemisbugi (jaettu modaalikomponentti)

- Tausta ja sisältö **sisaruselementteinä**, ei lapsen ja vanhemman suhteessa:
  backdrop = `StyleSheet.absoluteFillObject`-View ILMAN press-käsittelijää, content sen päällä.
- Tap-outside-sulkeminen POIS numeerisista syöttömodaaleista kokonaan — arvo kuitataan
  näppäimistön Enter/done-napilla (`onSubmitEditing`) tai kentän `onBlur`:lla; tyhjä tai
  virheellinen syöte sulkee tekemättä muutosta (sama malli kuin vapaa muistiinpanokenttä).
- Tekstikentän fokus: käytä RN:n `autoFocus`-proppia (toimii desktopilla ja Androidilla).
  iOS Safarissa autoFocus ohitetaan ilman käyttäjän kosketusta; silloin käyttäjä napauttaa
  kenttää itse modaalin avauduttua — se nyt toimii, koska ikkuna ei enää sulkeudu.
- Suomalainen pilkkudesimaali: korvaa "," → "." ennen `parseFloat`-kutsua.

### C. Muistutus PWA-välimuistista

- Kotivalikkoon lisätty PWA välimuistittaa vanhan bundlen: pyydä testaajaa sulkemaan ja
  avaamaan sovellus uudelleen deployn jälkeen ennen päätelmiä.

## Konteksti

- Projekti: Klack-Treeni (Expo SDK 54, react-native-web 0.21, Vercel auto-deploy GitHubista)
- Päivämäärä: 2026-10-24 (versiot v2.93–v2.95)
- Ratkaisutiedostot projektissa: `public/index.html`, `components/RepeatingButton.tsx`,
  `components/KgEditModal.tsx`, `components/AGENTS.md` (RepeatingButton- ja Modaalit-säännöt)

## Avainsanat

iOS Safari, suurennuslasi, magnifier, loupe, long-press, delayLongPress, onLongPress,
react-native-web, RNW, user-select, -webkit-touch-callout, contextmenu, tap-highlight,
modaali, backdrop, onStartShouldSetResponder, autoFocus, TextInput, näppäimistö, keyboard,
decimal-pad, pilkkudesimaali, PWA välimuisti, iPhone
