-- Run in Supabase SQL Editor. Public content is readable by anyone; writes are admin-only.
create table if not exists public.portfolio_admins (user_id uuid primary key references auth.users(id) on delete cascade);
create table if not exists public.portfolio_profile (
 id integer primary key default 1 check (id=1),
 name_en text, name_ar text, role_en text, role_ar text,
 university_en text, university_ar text, bio_en text, bio_ar text,
 portrait_url text, email text, linkedin text, scholar text,
 updated_at timestamptz default now()
);
create table if not exists public.portfolio_entries (
 id uuid primary key default gen_random_uuid(),
 category text not null check (category in ('journey','research','thesis','achievements','activities','gallery')),
 status text, title_en text not null, title_ar text, body_en text, body_ar text,
 date_label text, image_url text, link_url text,
 sort_order integer not null default 0, published boolean not null default true,
 created_at timestamptz not null default now()
);
create or replace function public.is_portfolio_admin() returns boolean
language sql stable security definer set search_path = '' as $$
 select exists(select 1 from public.portfolio_admins where user_id=(select auth.uid()));
$$;
revoke all on function public.is_portfolio_admin() from public;
grant execute on function public.is_portfolio_admin() to authenticated, anon;
alter table public.portfolio_admins enable row level security;
alter table public.portfolio_profile enable row level security;
alter table public.portfolio_entries enable row level security;
drop policy if exists "Admin can read own membership" on public.portfolio_admins;
create policy "Admin can read own membership" on public.portfolio_admins for select to authenticated using (user_id=(select auth.uid()));
drop policy if exists "Public profile read" on public.portfolio_profile;
create policy "Public profile read" on public.portfolio_profile for select to anon,authenticated using (true);
drop policy if exists "Admin profile insert" on public.portfolio_profile;
create policy "Admin profile insert" on public.portfolio_profile for insert to authenticated with check ((select public.is_portfolio_admin()));
drop policy if exists "Admin profile update" on public.portfolio_profile;
create policy "Admin profile update" on public.portfolio_profile for update to authenticated using ((select public.is_portfolio_admin())) with check ((select public.is_portfolio_admin()));
drop policy if exists "Public published entries" on public.portfolio_entries;
create policy "Public published entries" on public.portfolio_entries for select to anon,authenticated using (published or (select public.is_portfolio_admin()));
drop policy if exists "Admin insert entries" on public.portfolio_entries;
create policy "Admin insert entries" on public.portfolio_entries for insert to authenticated with check ((select public.is_portfolio_admin()));
drop policy if exists "Admin update entries" on public.portfolio_entries;
create policy "Admin update entries" on public.portfolio_entries for update to authenticated using ((select public.is_portfolio_admin())) with check ((select public.is_portfolio_admin()));
drop policy if exists "Admin delete entries" on public.portfolio_entries;
create policy "Admin delete entries" on public.portfolio_entries for delete to authenticated using ((select public.is_portfolio_admin()));
insert into public.portfolio_profile (id,name_en,name_ar,role_en,role_ar,university_en,university_ar,bio_en,bio_ar,email)
values (1,'Doctoral Researcher','باحث دكتوراه','PhD Candidate','باحث دكتوراه','Your University','الجامعة','Welcome to my doctoral e-portfolio.','مرحباً بكم في ملفي الأكاديمي.','researcher@example.com')
on conflict (id) do nothing;
insert into public.portfolio_entries (category,title_en,title_ar,body_en,body_ar,sort_order)
select 'journey','Beginning the doctoral journey','بداية رحلة الدكتوراه','Academic milestones and growth.','محطات التعلم والتطور.',1
where not exists(select 1 from public.portfolio_entries);
-- Storage: bucket is PUBLIC because website visitors must be able to view media.
insert into storage.buckets (id,name,public,file_size_limit,allowed_mime_types)
values ('portfolio-media','portfolio-media',true,5242880,array['image/png','image/jpeg','image/webp','application/pdf'])
on conflict (id) do update set public=true,file_size_limit=5242880,allowed_mime_types=excluded.allowed_mime_types;
drop policy if exists "Public read portfolio media" on storage.objects;
create policy "Public read portfolio media" on storage.objects for select to anon,authenticated using (bucket_id='portfolio-media');
drop policy if exists "Admin upload portfolio media" on storage.objects;
create policy "Admin upload portfolio media" on storage.objects for insert to authenticated with check (bucket_id='portfolio-media' and (select public.is_portfolio_admin()));
drop policy if exists "Admin delete portfolio media" on storage.objects;
create policy "Admin delete portfolio media" on storage.objects for delete to authenticated using (bucket_id='portfolio-media' and (select public.is_portfolio_admin()));
