
# Diáknap Csapatverseny API

Ez a Node.js és Express alapú API egy iskolai diáknap csapatversenyének kezelését szolgálja.

## Telepítés és indítás

1.  **Telepítsd a függőségeket:**
    Mielőtt elkezdenéd, győződj meg róla, hogy a Node.js telepítve van a gépeden.
    A projekt mappájában futtasd a következő parancsot a szükséges csomagok telepítéséhez:
    ```bash
    npm install
    ```
    *Megjegyzés Windows-on:* Ha a parancs futtatása hibára fut a PowerShell végrehajtási házirendje miatt, futtasd először ezt a parancsot: `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass`, majd próbáld újra az `npm install`-t.

2.  **Adatbázis inicializálása és feltöltése:**
    Az API egy SQLite adatbázist használ. Az adatbázis fájl (`competition.db`) automatikusan létrejön az első indításkor.
    A versenyállomások feltöltéséhez futtasd a következő parancsot a terminálban:
    ```bash
    node db/database.js
    ```
    Ez a script létrehozza a szükséges táblákat és feltölti a 15 alapértelmezett állomást.

3.  **Szerver indítása:**
    Indítsd el a szervert a következő paranccsal:
    ```bash
    node index.js
    ```
    A szerver a `http://localhost:3000` címen lesz elérhető.

## Használat

### Swagger UI (OpenAPI)

Ha fut a szerver, a Swagger UI itt érhető el:

* `http://localhost:3000/api-docs`

Az API a következő endpointokat biztosítja:

### Osztályok (`/api/classes`)

*   `GET /`: Visszaadja az összes osztály listáját.
*   `POST /`: Létrehoz egy új osztályt.
    *   Body: `{ "name": "10.B" }`

### Diákok (`/api/students`)

*   `POST /`: Hozzáad egy új diákot egy osztályhoz. A `is_team` mező automatikusan `true` lesz, ha a `is_sport` `false` vagy nincs megadva.
    *   Body: `{ "name": "Minta János", "class_id": 1, "is_sport": false }`
*   `GET /:classId`: Visszaadja egy adott osztály diákjainak listáját.

### Csapatok (`/api/teams`)

*   `GET /:classId`: Lekérdezi az adott osztályhoz tartozó csapatot és annak tagjait. A csapat automatikusan frissül, amikor új diákot adnak hozzá az osztályhoz.
*   `GET /menetlevel/:classId`: Generál egy "menetlevelet" (útvonalat) az osztály csapatának. A kezdő állomás minden csapatnál más, egy egyszerű rotációs logika alapján.

### Állomások (`/api/stations`)

*   `GET /`: Visszaadja az összes versenyállomás listáját.

### Pontok (`/api/scores`)

*   `POST /`: Rögzít egy pontszámot egy csapatnak egy adott állomáson.
    *   Body: `{ "team_id": 1, "station_id": 5, "points": 9, "bonus_points": 1 }`
*   `GET /:teamId`: Lekérdezi egy csapat összes megszerzett pontját és az összpontszámot.
