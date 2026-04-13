# 🍳 Recipes

Step-by-step guides for common tasks with the toolkit.

## What Are Recipes?

Recipes are complete walkthroughs that take you from zero to done. Each recipe focuses on one task and gives you the exact commands, files, and agent invocations you need. They're more detailed than the FAQ — think of them as tutorials.

## Who Are Recipes For?

- Developers setting up a new project and want to use the toolkit from day one
- Teams integrating the toolkit into an existing codebase
- Anyone who learns best by following concrete steps

## Available Recipes

| Recipe                                               | Description                                                        | Time    |
| ---------------------------------------------------- | ------------------------------------------------------------------ | ------- |
| [Set Up a Next.js Project](setup-nextjs-project.md)  | Bootstrap a Next.js app with agents, instructions, testing, and CI | ~20 min |
| [Set Up a Phoenix Project](setup-phoenix-project.md) | Bootstrap an Elixir/Phoenix app with the toolkit                   | ~20 min |
| [Set Up a Monorepo](setup-monorepo.md)               | Create a monorepo with Turborepo or Nx, then wire up the toolkit   | ~30 min |
| [Set Up a Mobile App](setup-mobile-app.md)           | Configure the toolkit for React Native, Expo, or Flutter           | ~20 min |
| [Add a Custom Agent](add-custom-agent.md)            | Create an agent tailored to your domain or team conventions        | ~10 min |
| [CI/CD from Scratch](ci-cd-from-scratch.md)          | Set up a full CI/CD pipeline using toolkit workflows               | ~30 min |

## Recipe Structure

Every recipe follows the same format:

1. **What you'll build** — End result and prerequisites
2. **Steps** — Numbered steps with commands and file contents
3. **Verify** — How to confirm everything works
4. **Next steps** — Where to go from here

## Contributing a Recipe

We welcome new recipes. To add one:

1. Create a new file in `docs/recipes/` named `your-recipe-name.md`
2. Follow the structure above (What you'll build → Steps → Verify → Next steps)
3. Add your recipe to the table in this README
4. Open a PR with the recipe

Keep recipes practical — show real commands, real file contents, and real agent interactions. Skip theory.
