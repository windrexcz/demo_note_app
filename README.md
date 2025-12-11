Demonstrační flutter projekt 

## Popis projektu

Tento projekt je jednoduchá flutter aplikace pro poznámky, která umožňuje uživatelům vytvářet, upravovat a mazat poznámky.

## Funkce

### Poznámky:
- Stránka pro zobrazení
- Fulltext vyhledávání / odfiltrování důležitých poznámek
- Dialog pro vytvoření / úpravu
- Tap -> Detail
- Tap and hold -> Kontext menu

### Témata
- Stránka pro zobrazení
- Dialog pro vytvoření / úpravu
- Tap -> Vyfiltrování poznámek z daného tématu
- Tap and hold -> Kontext menu

### Misc
- Načtení příkladových dat
- Lokalizace pro češtinu a angličtinu
- Ukládání poznámek pomocí Hive databáze
- Použití Riverpod pro správu stavu
- Responsivní design pro různé velikosti obrazovek
- Routing pomocí go_router

#### Zdroje

Využitá ikona aplikace pochází z Flaticon:
https://www.flaticon.com/free-icon/wirte_10270677?term=note&page=1&position=3&origin=search&related_id=10270677#

#### Užitečné příkazy

- Vygenerování lokalizačních souborů:

```
flutter gen-l10n
```

- Spuštění build runneru

```
dart run build_runner build --delete-conflicting-outputs
```

- Android sestavení
```
flutter build apk
```
