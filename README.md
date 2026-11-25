# Storm Season Kit

A phone-friendly storm preparedness guide for South-East Queensland households: what to do when a warning is issued, a 72-hour and 14-day kit list, grab bags, pets, upkeep reminders, safety and contacts.

Based on Get Ready Queensland, Queensland Health, Brisbane City Council and SES guidance. Prices are rough November 2026 estimates. Always follow official warnings and emergency services on the day.

## Saving your list

- Signed out: ticks, upkeep dates and your household plan are saved in your browser on that device only.
- Signed in (email and password): they're saved to your own private row in Supabase, protected by row-level security, so only you can read or change them. Only your email and your list are stored.

## Setup (for the site owner)

1. Create a Supabase project.
2. Run `supabase-setup.sql` in the SQL Editor.
3. In Authentication > Sign In / Providers > Email, turn off "Confirm email" (Supabase's built-in email only sends to the project's own team).
4. Put the project URL and the anon / publishable key into `index.html` (`SB_URL` and `SB_KEY`). Never use the service-role or secret key.
