---
description: 'Vue.js coding standards. Use when writing or reviewing Vue Single File Components. Covers Composition API, Nuxt patterns, and Vue 3.4+ conventions.'
applyTo: '**/*.vue'
---

# Vue.js Code Standards

## SFC Structure

- Order sections: `<script setup>` → `<template>` → `<style scoped>`
- Use `<script setup lang="ts">` — never the Options API in new code
- Use `<style scoped>` by default — use `:deep()` only when targeting child component styles
- One component per file — file name matches component name in PascalCase

## Composition API

- Use `ref()` for primitives, `reactive()` for objects — prefer `ref()` when in doubt
- Use `computed()` for derived state — never compute in the template
- Use `watch()` for reacting to specific value changes, `watchEffect()` for auto-tracking
- Extract reusable logic into composables (`use` prefix): `useAuth()`, `useFetch()`
- Composables return reactive refs — call them at the top level of `<script setup>`
- Use `toRef()` and `toRefs()` to destructure reactive objects without losing reactivity
- Use `shallowRef()` for large objects that don't need deep reactivity

## Props & Events

- Define props with TypeScript: `defineProps<{ title: string; count?: number }>()`
- Use `withDefaults()` for prop defaults: `withDefaults(defineProps<Props>(), { count: 0 })`
- Define emits with TypeScript: `defineEmits<{ update: [value: string]; close: [] }>()`
- Use `defineModel()` (Vue 3.4+) for two-way binding: `const name = defineModel<string>()`
- Prefix events with a verb: `update:modelValue`, `submit`, `cancel`, `select`
- Use `v-bind="$attrs"` to forward attributes to inner elements

## State Management (Pinia)

- Use Pinia stores — never Vuex for new projects
- Use Setup Stores (function syntax) over Option Stores for better TypeScript inference
- One store per domain: `useUserStore()`, `useCartStore()`
- Use `storeToRefs()` to destructure store state without losing reactivity
- Keep stores thin — business logic in composables, stores handle shared state
- Use getters for derived state, actions for async or multi-step mutations

## Routing

- Use `<RouterLink>` instead of `<a>` for internal navigation
- Use route params for resource IDs, query params for filters/sorting
- Use navigation guards (`beforeEach`) for auth checks — not component-level checks
- In Nuxt, use file-based routing — `pages/users/[id].vue` for dynamic routes
- Use `useRoute()` and `useRouter()` composables — not `this.$route`

## Template Best Practices

- Use `v-if` / `v-else` for conditional rendering — avoid `v-show` unless toggling is frequent
- Use `:key` on `v-for` — always use a unique identifier, never the index
- Keep template logic minimal — move complex expressions to `computed()`
- Use `<component :is="...">` for dynamic components with `defineAsyncComponent()`
- Use `<Teleport>` for modals and overlays that need to live at the document root
- Use `<Suspense>` with async components for loading states

## Testing (Vitest + Vue Test Utils)

- Use `mount()` for integration tests, `shallowMount()` for isolated unit tests
- Test component behavior (what it renders, what it emits) — not internal state
- Use `wrapper.find()` with data-testid selectors — avoid CSS class selectors
- Test composables independently — render them in a minimal test component
- Use `vi.mock()` for mocking modules, `vi.fn()` for function spies
- Use `flushPromises()` after async operations before asserting

## Performance

- Use `v-once` for static content that never changes
- Use `defineAsyncComponent()` for route-level and below-the-fold code splitting
- Use `v-memo` to skip re-renders of expensive list items
- Keep `watchEffect()` side effects lightweight — debounce expensive reactions
