# Administrator login and uploads

1. In Supabase SQL Editor run `supabase/schema.sql`.
2. In Supabase Authentication > Users, create **one** account with your real email and a strong password.
3. In `supabase/authorize-admin.sql`, replace the sample email with your actual account email; run the script in SQL Editor. Check that the final query returns exactly one administrator.
4. In `config.js`, set `supabaseUrl` and `supabaseAnonKey` from Supabase project settings. **Never add a password or service-role key to GitHub.**
5. Publish the files on GitHub Pages and visit `https://saidkalbani82-rgb.github.io/eportfolio/admin.html`. Sign in using your **email address** and password. Username-only login is optional and requires a controlled email domain alias as described in `SETUP.md`.
6. Under **Profile & Contact**, upload a profile photo and save. Under **Content Entries**, add a gallery/achievement entry, attach an image and/or PDF certificate, then save. You can also upload media separately under **Upload Media**.
7. Changes are stored in Supabase and displayed on the public website; no new GitHub commit is needed for each content change.

Uploads: PNG/JPG/WebP/PDF, maximum 5 MB per file. Public media is visible to visitors; upload only material intended for publication. Disable public sign-ups in Supabase Authentication settings.
