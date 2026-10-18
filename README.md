# Agify

A small iOS app built as a coding challenge for a job interview: enter a first name and get its
estimated age from the [agify API](https://agify.io).

## Beyond the task
- **Search as you type:** debounced by 0.5s; a new query cancels the running request.
- **UI polish:** Liquid Glass input field, rolling number animation, haptic feedback.
- **Rate limit handling:** agify's daily limit is shown with the time until reset.

## Why so much for a small app?
For the task at hand this is deliberately over-engineered. I wanted to show how I usually set up
a project:
- Unit tests and snapshot tests (light and dark mode) with Swift Testing
- SwiftLint on every build, SwiftFormat in a pre-commit hook
- A placeholder for error reporting (e.g. Sentry)
- A mock mode (`-mockAPI`) for demos without network or quota
- `CLAUDE.md` with requirements and conventions for AI-assisted work
- `DECISIONS.md` with the shortcuts I took and what I'd do in a production app

## How I built it
I built this together with Claude Code, which is how I approach most tasks nowadays: I make the
decisions, review every change and make sure I can explain each line. It took me about 2–3 hours.

## Getting started
Requires Xcode 27. Open `agify-ios-challenge/AgifyApp/AgifyApp.xcodeproj` and run.
Once per clone: `git config core.hooksPath .githooks` (needs `brew install swiftformat`).
