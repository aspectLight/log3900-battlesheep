# BattleSheep — LOG3900 · Équipe 105

Evolution of the **LOG2990** multiplayer RPG into a **multi-client** system: desktop web app, **mobile client**, and extended backend — built for **LOG3900 — Projet d'évolution d'un logiciel** (Polytechnique Montréal, session 26-1).

| | |
|---|---|
| **Course** | LOG3900 — Software evolution & maintenance |
| **Prerequisite project** | [LOG2990 / équipe 111](https://github.com/aspectLight/log2990-battlesheep) |
| **Team** | Équipe 105 |
| **GitLab (course)** | [LOG3900-105](https://gitlab.com/polytechnique-montr-al/log3900/26-1/equipe-105/LOG3900-105) |
| **GitHub (mirror)** | [`log3900-battlesheep`](https://github.com/aspectLight/log3900-battlesheep) |

## What changed vs LOG2990

This repo **extends an existing codebase** (Angular + NestJS + MongoDB) instead of starting from scratch.

| Deliverable | Stack | Role |
|-------------|-------|------|
| **client** | Angular 19 | Desktop / web (“client lourd”) — game editor, sessions, combat, admin |
| **client_leger** | Flutter 3 | Mobile (“client léger”) — Android APK, lighter UX |
| **server** | NestJS 10 | API, WebSockets, persistence, shared game logic |
| **common** | TypeScript | Shared models and constants |

### New / evolved features (sprints)

- **Mobile client** (`client_leger`) — play and interact from Android
- **Friends system** — friend list, requests, profile sync
- **Shop & rewards** — in-game economy / rewards flow
- **Visual themes** — configurable UI themes (mobile & web)
- **Score sharing** — share results between clients
- **Chat & waiting room** — fixes and UX improvements on web client
- **Release pipeline** — tagged GitLab releases with built artifacts (see `RELEASE.md`, `*/BUILD.md`)

> Active development lives on branch **`dev`**. `master` is the initial imported baseline.

## Architecture

```
┌─────────────────┐     ┌─────────────────┐
│  client         │     │  client_leger   │
│  (Angular)      │     │  (Flutter)      │
└────────┬────────┘     └────────┬────────┘
         │      Socket.IO / REST │
         └──────────┬───────────┘
                    ▼
            ┌───────────────┐
            │    server     │
            │   (NestJS)    │
            └───────┬───────┘
                    ▼
               MongoDB
```

## Tech stack

| Layer | Technologies |
|-------|----------------|
| Web | Angular 19, Angular Material, RxJS, Socket.IO, i18n |
| Mobile | Flutter, Dart 3.10+ |
| Backend | NestJS, Express, Socket.IO, Swagger, Mongoose |
| Data | MongoDB |
| CI/CD | GitLab CI (Pages, server deploy, releases) |

## Getting started

### Prerequisites

- Node.js LTS, MongoDB
- Flutter SDK (for `client_leger` only)

### Install

```bash
cd client && npm ci
cd ../server && npm ci
cd ../client_leger && flutter pub get
```

### Run locally

```bash
# Server
cd server && npm start

# Web client — http://localhost:4200
cd client && npm start

# Mobile — emulator or device
cd client_leger && flutter run
```

### Tests

```bash
cd server && npm test
cd client && npm test
```

## Project docs

| File | Content |
|------|---------|
| [CONTRIBUTING.md](./CONTRIBUTING.md) | Branching, MRs, code review |
| [RELEASE.md](./RELEASE.md) | GitLab release & tag workflow |
| [client/BUILD.md](./client/BUILD.md) | Desktop client build |
| [client_leger/BUILD.md](./client_leger/BUILD.md) | Android APK build |
| [server/BUILD.md](./server/BUILD.md) | Server packaging |

## Branches

| Branch | Description |
|--------|-------------|
| `dev` | **Main development** — mobile + new features |
| `master` | Initial LOG3900 import / course starter snapshot |

## Related repositories

- [log2990-battlesheep](https://github.com/aspectLight/log2990-battlesheep) — original LOG2990 project (équipe 111)

## License & academic use

Course project — Polytechnique Montréal, équipe 105. Evolves staff-provided and prior-team code. Respect course policies on publishing solutions.
