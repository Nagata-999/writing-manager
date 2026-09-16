-- Writing Manager schema (IELTS VOCAB Supabase project)
-- This app uses prefixed tables so it does not collide with existing IELTS VOCAB data.

create table if not exists public.writing_assignments (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  prompt text default '',
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.writing_submissions (
  id uuid primary key default gen_random_uuid(),
  assignment_id uuid not null references public.writing_assignments(id) on delete cascade,
  class_name text not null,
  student_no integer not null,
  student_name text not null,
  essay text not null,
  word_count integer not null default 0,
  status text not null default 'submitted' check(status in ('submitted','reviewed','returned')),
  feedback text default '',
  content_score numeric,
  organization_score numeric,
  vocabulary_score numeric,
  grammar_score numeric,
  submitted_at timestamptz not null default now(),
  reviewed_at timestamptz
);

alter table public.writing_assignments enable row level security;
alter table public.writing_submissions enable row level security;

-- Anonymous students can only read open assignments and create new submissions.
-- They cannot list/read submitted essays.
drop policy if exists "public can read active writing assignments" on public.writing_assignments;
create policy "public can read active writing assignments" on public.writing_assignments
for select to anon using (active = true);

drop policy if exists "public can submit writing essays" on public.writing_submissions;
create policy "public can submit writing essays" on public.writing_submissions
for insert to anon with check (status = 'submitted');

insert into public.writing_assignments(title,prompt)
select 'Practice Essay #1','Write an essay on the assigned topic.'
where not exists (select 1 from public.writing_assignments);

-- Teacher SELECT/UPDATE policies are intentionally not public.
-- Add Supabase Auth + teacher-only policies before enabling the teacher dashboard.