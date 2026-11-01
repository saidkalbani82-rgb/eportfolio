-- STEP 1: Create the ONLY administrator in Supabase > Authentication > Users > Add user.
-- Email must match username@loginDomain in config.js, e.g. researchadmin@yourdomain.com.
-- Choose a strong password and mark email confirmed only if you control that account.
-- STEP 2: Replace the example email below with the EXACT account email, then run.
-- This registers ONE account as the administrator; do not add more rows.
insert into public.portfolio_admins(user_id)
select id from auth.users where email = 'researchadmin@yourdomain.com'
on conflict (user_id) do nothing;
-- Check: this must return exactly one row.
select a.user_id, u.email from public.portfolio_admins a join auth.users u on u.id=a.user_id;
