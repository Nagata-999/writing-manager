-- Writing Manager v1
create extension if not exists pgcrypto;

create table if not exists public.assignments (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  prompt text default '',
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.submissions (
  id uuid primary key default gen_random_uuid(),
  assignment_id uuid not null references public.assignments(id) on delete cascade,
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

alter table public.assignments enable row level security;
alter table public.submissions enable row level security;

-- v1: 生徒ページから課題一覧を読める
create policy "public can read active assignments" on public.assignments for select to anon using (active = true);
-- v1: 生徒は提出のみ可能。提出内容の一覧取得は許可しない。
create policy "public can submit essays" on public.submissions for insert to anon with check (status = 'submitted');

-- 初期課題
insert into public.assignments(title,prompt) values
('Practice Essay #1','Write an essay on the assigned topic.');

-- IMPORTANT:
-- teacher.html から全提出を閲覧・更新するには教師認証を追加する必要があります。
-- service_role key をブラウザへ置かないでください。
-- 次版で Supabase Auth + teacher role を追加する前提です。