# Etapa 1 — Ecranul de login cu conturi salvate

## Ce face etapa asta

- Aplicatia porneste pe **Login**: lista conturilor salvate pe dispozitiv.
- **Tap pe un cont conectat** (bifa verde) → intri direct in Home.
- **Tap pe un cont deconectat** (lacat gri) → apare un dialog cu parola.
- **Meniul ⋮** al fiecarui cont: *Deconecteaza* (data viitoare cere parola) sau *Sterge de pe dispozitiv* (dispare din lista, cu confirmare).
- **Creeaza cont nou** (jos) → ecranul de alegere a rolului.
- **Home** e provizoriu: arata numele si rolul, plus doua butoane sus: *Schimba contul* si *Iesi din cont*.

> **Limitari intentionate (le rezolvam in etapele urmatoare):**
> - Conturile sunt **date de test** scrise in cod si traiesc doar **in memorie** → daca inchizi aplicatia, totul revine la starea initiala (etapa 3).
> - Parola **nu se verifica real**: orice parola nevida e acceptata. Verificarea reala o face un server, nu telefonul.

## Structura fisierelor

```
lib/
├── main.dart                       porneste aplicatia pe LoginScreen
├── data/
│   └── account_store.dart          NOU – lista conturilor salvate + operatii
├── models/
│   ├── enums.dart                  + UserRole.label (numele afisat al rolului)
│   ├── saved_account.dart          NOU – un User + daca e conectat
│   └── ...
└── screens/
    ├── login_screen.dart           NOU – ecranul principal de login
    ├── home_screen.dart            NOU – Home provizoriu
    └── role_selection_screen.dart  foloseste acum role.label
```

De ce foldere separate:

| Folder | Ce pune acolo | Intrebarea la care raspunde |
|---|---|---|
| `models/` | Forma datelor | *Cum arata un cont?* |
| `data/` | De unde vin datele si cum le modifici | *Unde tin conturile?* |
| `screens/` | Ce vede utilizatorul | *Cum le afisez?* |

Avantajul: in etapa 3 schimbam **doar** `account_store.dart` (sa salveze pe telefon), iar ecranele raman neatinse.

---

## `models/saved_account.dart`

```dart
class SavedAccount {
  final User user;
  bool isLoggedIn;
  ...
}
```

Un cont salvat = un `User` + o singura informatie in plus: **e conectat sau nu**.
`isLoggedIn` nu e `final` pentru ca se schimba (te deconectezi / te conectezi).
„Sters” nu e o stare — contul pur si simplu dispare din lista.

## `models/enums.dart` — `label`

```dart
String get label => switch (this) {
  UserRole.customer => 'Customer',
  ...
};
```

Un **getter** (`get`) arata ca un camp, dar e calculat: scrii `role.label`, nu `role.label()`.
Inainte, textul rolului era doar in ecranul de rol; acum il folosesc si Login, si Home, deci l-am mutat langa enum — **o singura sursa**.

## `data/account_store.dart`

```dart
class AccountStore {
  AccountStore._();
  static final AccountStore instance = AccountStore._();
```

Asta e un **singleton**: exista **un singur** `AccountStore` in toata aplicatia.
- `AccountStore._()` — constructor privat (`_`), nimeni din afara nu poate face `AccountStore()`.
- `instance` — singurul obiect, folosit de peste tot: `AccountStore.instance`.

De ce conteaza: cand treci Login → Home → Login, ecranul de Login se **creeaza din nou**. Daca lista ar fi in ecran, s-ar pierde deconectarile. Fiind in store, ea supravietuieste navigarii.

```dart
final List<SavedAccount> _accounts = [ ... ];
List<SavedAccount> get accounts => List.unmodifiable(_accounts);
```

- `_accounts` e **privata**: doar store-ul o poate modifica.
- Ecranele primesc o copie **needitabila** → singura cale de a schimba ceva e prin metodele store-ului (`login`, `logout`, `remove`). Asa stii mereu unde se modifica datele.

| Metoda | Ce face |
|---|---|
| `login(id, parola)` | Daca parola nu e goala → marcheaza contul conectat, intoarce `true` |
| `logout(id)` | Marcheaza contul deconectat |
| `remove(id)` | Scoate contul din lista |

---

## `screens/login_screen.dart`

### Ecranul — `LoginScreen` (StatefulWidget)

Stateful pentru ca lista se schimba pe ecran (deconectare, stergere) si trebuie redesenata.

```dart
Expanded(
  child: accounts.isEmpty
      ? const Center(child: Text('Niciun cont salvat'))
      : ListView(children: [ for (final account in accounts) _AccountTile(...) ]),
),
OutlinedButton.icon( ... 'Creeaza cont nou' ),
```

- `Expanded` = „ia tot spatiul ramas” → lista ocupa mijlocul, butonul ramane lipit jos.
- `ListView` = lista care se poate derula (daca ai multe conturi).
- `? :` = daca nu sunt conturi, arata un mesaj in loc de lista goala.

### Tap pe cont — `_onAccountTap`

```dart
Future<void> _onAccountTap(SavedAccount account) async {
  if (account.isLoggedIn) { _openHome(account); return; }

  final password = await _askPassword(account);
  if (password == null) return;          // a apasat Anuleaza
  if (_store.login(account.user.id, password)) { _openHome(account); }
  else if (mounted) { ...SnackBar('Parola incorecta')... }
}
```

- **`async` / `await`**: dialogul nu se inchide instant — utilizatorul scrie parola. `await` inseamna „asteapta pana se inchide dialogul, apoi continua”. Functia intoarce `Future` = „un rezultat care va veni mai tarziu”.
- **`mounted`**: dupa un `await`, ecranul s-ar putea sa nu mai existe. `mounted` verifica ca inca e pe ecran inainte sa-l folosim.

### Dialogul de parola — `_askPassword`

```dart
final controller = TextEditingController();
...
TextField(controller: controller, obscureText: true, ...)
...
FilledButton(onPressed: () => Navigator.pop(dialogContext, controller.text), ...)
```

- `TextEditingController` — prin el citim ce a scris utilizatorul (`controller.text`).
- `obscureText: true` — afiseaza `•••` in loc de litere.
- `Navigator.pop(context, valoare)` — **inchide dialogul si trimite valoarea inapoi** la cine a facut `await`. *Anuleaza* face `pop` fara valoare → primim `null`.

### Meniul ⋮ — `_onAction`

```dart
enum _AccountAction { logout, remove }
```

Un enum mic, privat, pentru cele 2 optiuni din meniu — mai sigur decat texte de tipul `'logout'` (o greseala de scriere ar fi prinsa de compilator).

```dart
case _AccountAction.logout:
  setState(() => _store.logout(account.user.id));
```

**`setState` aici e esential**: store-ul s-a schimbat, dar Flutter nu stie. `setState` ii spune „redeseneaza ecranul” → bifa verde devine lacat.

Stergerea cere intai confirmare (`_confirmRemove`), pentru ca e o actiune pe care utilizatorul nu o poate anula usor. Dialogul intoarce `true` / `false` prin acelasi `Navigator.pop`.

### Navigarea

```dart
Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RoleSelectionScreen()));
Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen(account: account)));
```

Navigatorul e o **stiva de ecrane**:

| Metoda | Ce face cu stiva | Folosit la | Butonul ← Inapoi |
|---|---|---|---|
| `push` | pune ecranul nou **peste** cel curent | Login → Alege rolul | te intoarce la Login |
| `pushReplacement` | **inlocuieste** ecranul curent | Login → Home | nu te intoarce la Login |

De aceea din Home nu poti da „inapoi” la Login fara sa alegi explicit *Schimba contul*.

### Widget-urile mici — `_AccountTile`, `_StatusDot`

Sunt **StatelessWidget**: primesc datele + functiile `onTap` / `onAction` din exterior si doar le deseneaza. Ecranul decide *ce se intampla*, tile-ul doar *arata*.

- `CircleAvatar(child: Text(user.name[0]))` — prima litera din nume, ca avatar.
- `PopupMenuButton` — butonul ⋮ cu meniu. *Deconecteaza* apare doar daca contul e conectat (`if` in interiorul listei).
- `ValueChanged<_AccountAction>` — tipul unei functii care primeste o actiune: tile-ul spune „s-a ales X”, ecranul face ceva cu X.

---

## `screens/home_screen.dart`

Provizoriu, inlocuit in etapa 4. Primeste contul prin constructor (`HomeScreen(account: account)`) — asa se **trimit date intre ecrane**.

| Buton | Ce face |
|---|---|
| *Schimba contul* | Inapoi la Login, contul ramane conectat |
| *Iesi din cont* | `AccountStore.instance.logout(...)`, apoi inapoi la Login → contul cere parola |

---

## Teste — `test/widget_test.dart`

| Test | Verifica |
|---|---|
| se vad conturile salvate | cele 3 conturi de test + butonul de inregistrare |
| contul conectat intra direct | tap pe *Fresh Foods* → Home |
| contul deconectat cere parola | tap pe *Fast Trans* → dialog cu „Parola” |
| butonul de inregistrare | deschide „Cine esti?” |
| alegerea rolului | „Continua” devine activ dupa ce alegi un rol |

`pumpAndSettle()` = „asteapta sa se termine toate animatiile” (navigarea si dialogurile sunt animate).

Rulare:

```
flutter test
```

## Cum incerci pe emulator

1. Pornesti aplicatia → vezi 3 conturi.
2. *Fresh Foods* (bifa verde) → intra direct → *Iesi din cont* → acum are lacat.
3. Tap pe *Fresh Foods* → scrii orice parola → intra.
4. ⋮ pe *Ion Popescu* → *Sterge de pe dispozitiv* → confirmi → dispare.
5. *Creeaza cont nou* → alegi un rol → ← te intoarce la Login.
