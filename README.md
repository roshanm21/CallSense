# CallSense

CallSense is a Flutter MVP for checking message text against common scam
warning phrases, extracting text from screenshots on-device, searching public
company information, and sharing family alerts.

## Run the app

1. Install Flutter and generate the Android/iOS platform folders from the
   `app/` directory if they are not present:

   ```sh
   cd app
   flutter create --platforms=android,ios .
   ```

2. Install Dart dependencies:

   ```sh
   flutter pub get
   ```

3. Copy `app/env.example.json` to `app/env.json`, fill in your Supabase project
   URL and anon key, then run from the `app/` directory:

   ```sh
   flutter run --dart-define-from-file=env.json
   ```

   The anon key is intended for client apps; never put a Supabase service-role
   key in the Flutter app. If Supabase is not configured, local message scans
   still work.

## Supabase setup

1. Apply `supabase/migrations/001_initial_schema.sql`.
2. Enable anonymous sign-ins in Supabase Auth for family linking.
3. Set the Edge Function secret and deploy the function:

   ```sh
   supabase secrets set TAVILY_API_KEY=your_tavily_key
   supabase functions deploy verify-company
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
