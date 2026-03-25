-- Add Ryan Masschelin as a manager
insert into app_users (email, full_name, role, is_active)
values ('ryan.masschelin@rsmd365s.com', 'Ryan Masschelin', 'manager', true)
on conflict (email) do nothing;
