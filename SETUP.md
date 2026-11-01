# Doctoral Spectrum — Setup & GitHub Pages Deployment

## 1. What is included
- `index.html` — public bilingual Arabic/English academic portfolio
- `admin.html` — secure single-administrator content dashboard
- `assets/` — site styles and application logic
- `config.js` — Supabase public configuration (no passwords)
- `supabase/schema.sql` — database, row-level security and storage policies
- `supabase/authorize-admin.sql` — explicit admin authorization

## 2. GitHub Pages limitation
GitHub Pages hosts static HTML/CSS/JavaScript only. The backend for login, database and media is Supabase. This is NOT a WordPress theme and does not run PHP.

## 3. Create Supabase project
1. Visit https://supabase.com/dashboard and create a free project.
2. Open **SQL Editor** and run the complete `supabase/schema.sql`.
3. Under **Project Settings → API** (or Connect), copy **Project URL** and the **anon/publishable key**.
4. Open `config.js` and set `supabaseUrl` and `supabaseAnonKey`.
5. Never use the `service_role` or secret API key in the browser or GitHub.

## 4. Create ONE username/password administrator
Supabase Auth authenticates using email/password, not arbitrary usernames. This app offers a **username-only login field** by deriving an email alias (`username@loginDomain`) on the client. For this to work securely and reliably, use a real email domain you control with an actual deliverable mailbox/alias for password recovery. **Do not use a fictional email address or someone else's domain.**

1. Choose a domain you own, e.g. `example.org`, and a mailbox alias `researchadmin@example.org` that can receive recovery emails.
2. Set `loginDomain: 'example.org'` in `config.js`.
3. In Supabase **Authentication → Users → Add user**, create `researchadmin@example.org` with a strong unique password. Confirm the email only when ownership has been verified.
4. Edit `supabase/authorize-admin.sql`, replacing `researchadmin@yourdomain.com` with your exact email alias. Run it in Supabase SQL Editor.
5. Confirm the query returns exactly one admin account.
6. Visit `admin.html`; enter `researchadmin` as username and the Supabase password.
7. Disable public self-signups in Supabase Auth settings. Do not enable anonymous write access.
8. Set an appropriate Supabase **Site URL** and allowed redirect URLs to your actual published site. For password reset, use Supabase's secure recovery flow from the Auth dashboard or add a recovery UI later.

**Alternative if you do not own an email domain:** use your own real email provider and change the usernameEmail function in `assets/admin.js` to accept a full email address; do not create accounts with an unowned domain.

## 5. Publish on GitHub Pages
1. Create a GitHub account at https://github.com if necessary.
2. Create a **public** repository named `doctoral-spectrum` (or another name).
3. Upload the **contents of this folder** to the repository root: `index.html`, `admin.html`, `config.js`, `assets/`, `supabase/`, `SETUP.md`. Do not upload the outer ZIP alone.
4. Commit the files to the `main` branch.
5. Open repository **Settings → Pages**.
6. Under **Build and deployment**, choose **Deploy from a branch**, branch **main**, folder **/(root)**, then Save.
7. Wait for the deployment; visit `https://YOUR-USERNAME.github.io/doctoral-spectrum/`.
8. The admin URL is `https://YOUR-USERNAME.github.io/doctoral-spectrum/admin.html`.
9. Ensure HTTPS is enabled and verify the profile and login work.

## 6. Manage content
- Sign in to `admin.html`.
- **Profile & Contact**: edit bilingual name, university, biography and contact URLs.
- **Content Entries**: add/edit/delete academic milestones, research, thesis, achievements, activities and gallery entries. Choose Published/Under Review/Ready for Submission in the status field.
- **Upload Media**: upload JPG/PNG/WebP or PDF (up to 5 MB), copy the public URL and paste it into an entry's Image URL / PDF URL or the portrait URL.
- The public site fetches published entries from Supabase and updates without a new GitHub commit.

## 7. Security notes
- `config.js` values are public; this is expected for a Supabase publishable/anon key. Security depends on the SQL Row Level Security (RLS) policies.
- Passwords are managed and hashed by Supabase Auth, never stored in the repository or site code.
- The `portfolio_admins` table restricts writes to the explicitly authorized Supabase user ID.
- Public media is visible to everyone with its URL. Do not upload private documents or personal data without consent.
- GitHub Pages and Supabase free plans have usage limits and terms that may change.
- This starter has not been live-tested against your specific Supabase project; test admin login, RLS, uploads and mobile layout before production use.
- External fonts and Supabase JS library load from CDNs; an internet connection is required.

## 8. Troubleshooting
- Blank data: verify Supabase URL/key and that `schema.sql` ran successfully.
- Login denied: verify domain alias, user email/password and one row in `portfolio_admins`.
- Upload denied: verify storage bucket and RLS policies.
- GitHub Pages 404: check repository Settings → Pages and ensure `index.html` is in root.
