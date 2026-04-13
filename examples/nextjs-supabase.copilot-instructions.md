# Repository-Wide Instructions for GitHub Copilot

## About This Project

This is a SaaS application built with Next.js 15, Supabase, Tailwind CSS, and Stripe.

### Tech Stack

- **Framework**: Next.js 15 (App Router, Server Components, Server Actions)
- **Database**: Supabase (PostgreSQL + Auth + Realtime + Storage)
- **Styling**: Tailwind CSS 4 + shadcn/ui components
- **Payments**: Stripe (Checkout, Subscriptions, Webhooks)
- **Deployment**: Vercel
- **Testing**: Vitest (unit), Playwright (e2e)

### Project Structure

```
src/
├── app/             # Next.js App Router pages and layouts
│   ├── (auth)/      # Auth pages (login, signup, reset)
│   ├── (dashboard)/ # Protected dashboard pages
│   ├── api/         # API routes (webhooks, etc.)
│   └── layout.tsx   # Root layout
├── components/      # React components (by feature, not by type)
│   ├── ui/          # shadcn/ui primitives
│   └── [feature]/   # Feature-specific components
├── lib/             # Shared utilities
│   ├── supabase/    # Supabase client (server + browser)
│   ├── stripe/      # Stripe helpers
│   └── utils.ts     # General utilities
├── hooks/           # Custom React hooks
└── types/           # TypeScript type definitions
```

## Code Conventions

- Use Server Components by default. Add `"use client"` only when you need interactivity, hooks, or browser APIs.
- Fetch data in Server Components using Supabase server client. Never fetch in client components directly.
- Use Server Actions for mutations (forms, updates, deletes). Put them in `actions.ts` files co-located with the page.
- Use `redirect()` from `next/navigation` in Server Actions, not `router.push()`.
- All database queries go through Supabase client — no raw SQL in application code.
- Use Supabase RLS policies for authorization. Don't check permissions in application code.
- Use `cn()` utility (from `lib/utils.ts`) for conditional Tailwind classes.
- Stripe webhook handlers live in `app/api/webhooks/stripe/route.ts`. Verify signatures.
- Environment variables: `NEXT_PUBLIC_*` for client, everything else server-only.

## dx-toolkit Components in Use

### Active Agents

- `nextjs-expert` — Next.js App Router patterns
- `supabase-expert` — RLS, Edge Functions, Auth
- `typescript-expert` — Strict TypeScript
- `frontend-expert` — Performance, accessibility
- `payments-expert` — Stripe integration patterns

### Active Instructions

- `typescript.instructions.md` — Applied to `**/*.ts, **/*.tsx`
- `react.instructions.md` — Applied to `**/*.tsx, **/*.jsx`
- `css.instructions.md` — Applied to `**/*.css`
- `testing.instructions.md` — Applied to `**/*.test.*`

### Recommended Skills

- `/explore` — Define new features with specs
- `/develop` — Implement in thin vertical slices
- `/check` — Debug failures, write regression tests
- `/polish` — Performance optimization, security audit

### Active Hooks

- `format-on-edit` — Prettier for TS/TSX/CSS/JSON/MD
- `guard-protected-files` — Protect .env, lock files
- `secret-scanner` — Catch hardcoded API keys
- `config-protector` — Don't weaken ESLint/Prettier rules
- `console-log-detector` — Catch debug statements

## Testing Conventions

- Unit tests: `*.test.ts` co-located with source files
- Component tests: `*.test.tsx` using Testing Library
- E2E tests: `e2e/*.spec.ts` using Playwright
- Run: `npm test` (unit), `npm run test:e2e` (e2e)
- Mock Supabase with `@supabase/supabase-js` mock client
- Mock Stripe with `stripe-mock` or fixture data
