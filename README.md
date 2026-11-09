# CallSense

CallSense is a Flutter MVP for checking message text against common scam
warning phrases, extracting text from screenshots on-device, searching public
company information, and sharing family alerts.

## Set up Supabase

The files under `supabase/` are source files; they are not deployed just by
being in this repository. Apply the migration and deploy the Edge Function to
your Supabase project:

1. In the Supabase Dashboard, open **SQL Editor**, create a new query, paste
   the complete contents of
   [`supabase/migrations/001_initial_schema.sql`](./supabase/migrations/001_initial_schema.sql),
   and run it. This creates the family tables, row-level security policies,
   and link-code RPC functions.
2. In **Authentication → Sign In / Providers**, enable **Anonymous Sign-Ins**.
   The app uses anonymous auth for family links and the protected verification
   function.
3. Company verification needs a Tavily API key. In **Edge Functions → Secrets**
   (or **Project Settings → Edge Functions → Secrets**), create
   `TAVILY_API_KEY`. Do not put that value in the Flutter app or this repo.
4. Deploy `supabase/functions/verify-company/` as an Edge Function named
   `verify-company`. Easiest is the Supabase CLI:

   ```sh
   supabase login
   supabase link --project-ref gzsrtiryqhsvjnddogaa
   supabase functions deploy verify-company
   ```

   `supabase login` uses your Supabase account credentials/token. Do not use
   the project's secret/service-role API key as a CLI login token.

Alternatively, run the migration and function deployment from a local
Supabase CLI installation. The app expects the Edge Function to be deployed
before **Verify a company** will work. If Tavily is not configured, company
verification returns a setup error; local message scanning does not require
Supabase.

## Install Flutter and run the app

The VS Code Flutter/Dart extensions provide editor support; they do not
install the Flutter SDK. In VS Code, open the Command Palette and run
**Flutter: Change SDK**. If it asks for a path and there is no Flutter SDK on
your computer, install the SDK using the
[official Flutter macOS installation guide](https://docs.flutter.dev/get-started/install/macos).
For Apple Silicon, Flutter is commonly installed under `~/development/flutter`;
the executable is then `~/development/flutter/bin/flutter`.

Add the SDK's `bin` folder to your shell PATH (zsh is the default on current
macOS). For the common install location:

```sh
echo 'export PATH="$HOME/development/flutter/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
flutter doctor -v
```

If you installed it somewhere else, replace that path with the actual Flutter
SDK folder. VS Code may need **Developer: Reload Window** after changing the
SDK or PATH. In the integrated terminal, these commands should print paths and
versions:

```sh
which flutter
flutter --version
dart --version
```

This repository does not include generated Android/iOS platform folders. Once
Flutter is installed, open a terminal at the repository root and run:

```sh
cd app
flutter create --platforms=android,ios .
flutter pub get
flutter doctor -v
flutter devices
```

You need Android Studio and an Android emulator/device for Android, or Xcode
and an iOS simulator/device for iOS. Create `app/env.json` from
`app/env.example.json` if needed, then run from `app/`:

```sh
flutter run --dart-define-from-file=env.json
```

The project URL and publishable key are already filled in your ignored local
`app/env.json`. That file is not tracked by Git. Never put a Supabase
secret/service-role key in Flutter or commit it. The JWKS URL is not needed in
Flutter; Supabase handles JWT verification. To run the scam detector tests:

```sh
cd app
flutter test
```

Company verification uses Tavily search and RDAP domain registration data.
Search snippets and domain age are signals only and do not authenticate a
caller or prove that a company is legitimate.

## Current limitations

- Call-end detection needs native Android/iOS event-channel implementations;
  `CallService` defines the Flutter bridge only. The app does not record calls.
- The repository does not currently contain generated `android/` or `ios/`
  folders. Generate them before building, and check plugin/platform setup for
  your target devices.
- The red-flag phrase list is a basic demo heuristic and can miss or
  incorrectly flag messages.
- Add and review a real privacy contact and retention policy before release.
