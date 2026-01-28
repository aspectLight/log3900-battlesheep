---
trigger: always_on
---

# Flutter Architecture Concepts Summary

## Separation of Concerns

- Divide application functionality into distinct, self-contained units
- Separate UI logic from business logic
- Separate each layer by feature or functionality

## Layered Architecture

### Three Common Layers

**UI Layer (Presentation Layer)**

- Displays data to users
- Handles user interactions
- Exposes data from the business logic layer

**Logic Layer (Domain Layer) - Optional**

- Implements core business logic
- Facilitates interaction between data and UI layers
- Only needed for apps with complex client-side business logic

**Data Layer**

- Manages interactions with data sources (databases, APIs, platform plugins)
- Exposes data and methods to the business logic layer
- Contains Repository classes as single sources of truth

### Layer Communication Rules

- Each layer only communicates with layers directly above or below it
- UI layer should not know the data layer exists, and vice versa

## Single Source of Truth (SSOT)

- Every data type should have one single source of truth
- SSOT is responsible for representing local or remote state
- Only the SSOT class can modify the data
- Benefits: Reduces bugs, simplifies code
- Typically implemented in Repository classes

## Unidirectional Data Flow (UDF)

- State flows: Data Layer → Logic Layer → UI Layer
- Events flow: UI Layer → Logic Layer → Data Layer
- Data changes always happen in the SSOT (data layer)

## UI is a Function of Immutable State

- Flutter is declarative: UI reflects current app state
- Data should be immutable and persistent
- Views should contain minimal logic

## Extensibility

- Each architectural piece should have well-defined inputs and outputs
- Clean interfaces allow swapping implementations without changing consumer code

---

# Flutter Application Architecture Guide

## MVVM Pattern Overview

**Model-View-ViewModel (MVVM)** separates a feature into three parts:

- **View**: UI components (widgets)
- **ViewModel**: Logic and state management
- **Model**: Data layer (repositories and services)

## Application Components

### Views

**Location:** `lib/presentation/screens/` and `lib/presentation/widgets/`

- Widget classes that render UI
- Should contain minimal business logic
- Receive all necessary data from view models
- Have a one-to-one relationship with view models

**Allowed logic in views:**

- Simple conditional statements (show/hide widgets)
- Animation logic
- Layout logic

### View Models

**Location:** `lib/presentation/view_models/`

- Expose application data necessary to render views
- Most application logic lives here
- Have a one-to-one relationship with views

**Main responsibilities:**

- Retrieve data from repositories
- Transform data into presentation format
- Maintain current state needed by the view
- Expose callbacks called **commands** for event handlers

**Relationships:**

- View models and repositories: many-to-many
- One view model can use many repositories

### Repositories

**Location:** `lib/data/repositories/` and `lib/domain/repositories/`

- Single source of truth for model data
- One repository class per data type
- Transform services data into domain models

**Responsibilities:**

- Caching, error handling, retry logic
- Refreshing data, polling services
- User-action-based data updates

**Important rules:**

- Repositories should never be aware of each other
- Relationships: many-to-many with view models and services

### Services

**Location:** `lib/data/services/`

- Lowest layer of the application
- Wrap API endpoints (REST, platform APIs, local files)
- Expose asynchronous response objects (Future, Stream)
- Hold no state - only isolate data-loading
- Relationships: many-to-many with repositories

## Features Definition

- A feature is user-centric, defined by the UI layer
- Every paired view and view model defines one feature
- Often corresponds to a screen

## Optional: Domain Layer (Use-Cases/Interactors)

**Location:** `lib/domain/usecases/` and `lib/domain/entities/`

### When to Add Domain Layer

Add when your app has complex logic that:

- Requires merging data from multiple repositories
- Is exceedingly complex for view models
- Will be reused by different view models

### Use-Case Implementation Rules

- Use-cases depend on repositories (many-to-many relationship)
- View models depend on use-cases AND/OR repositories
- Add use-cases only when needed

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   ├── helpers/
│   ├── themes/
│   └── widgets/
├── data/
│   ├── models/
│   ├── repositories/
│   └── services/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── screens/
│   ├── view_models/
│   └── widgets/
├── routing/
└── main.dart
```

## Key Relationships Summary

- **Views ↔ View Models**: One-to-one
- **View Models ↔ Repositories**: Many-to-many
- **Repositories ↔ Services**: Many-to-many
- **Use-Cases ↔ Repositories**: Many-to-many

---

# Dependency Injection Best Practices

## What is Dependency Injection?

**Dependency Injection (DI)** is a design pattern where objects receive their dependencies from external sources rather than creating them internally.

**Benefits:**

- Easy to test (swap in fake implementations)
- Easy to change (swap implementations without changing code)
- Follows separation of concerns

## Service Locator Pattern (GetIt)

### Registration Types

**Singleton (`registerLazySingleton`)**

- Creates ONE instance for the entire app lifetime
- The same object is returned every time
- Instance is created when first requested (lazy)

**Factory (`registerFactory`)**

- Creates a NEW instance every time you ask for it
- Useful for objects that hold temporary state

## Common DI Pitfalls

### Pitfall 1: Circular Dependencies

Occurs when A depends on B, B depends on C, and C depends on A.

**How to avoid:**

- Depend on lower layers, not peers or higher layers
- Use callbacks or events for upward communication
- Draw your dependency graph before coding

### Pitfall 2: Inconsistent Lifecycle Management

Mixing singleton and factory registrations without understanding consequences.

**How to avoid:**

- Stateless services/repositories → Singleton
- Stateful view models → Factory
- Ask: Does this object hold state that changes? Yes = Factory, No = Singleton

### Pitfall 3: Missing Resource Disposal

Creating objects with resources (timers, streams, listeners) without cleaning them up.

**How to avoid:**

- Always implement dispose for ChangeNotifier
- Cancel streams, timers, subscriptions in dispose()
- Use state management solutions that handle disposal automatically

### Rule 3: Plan Resource Cleanup

Objects needing disposal: ChangeNotifier, StreamSubscription, Timer, AnimationController, TextEditingController, platform channels.

### Rule 4: Infrastructure Depends on Business, Not Vice Versa

Business logic should not depend on infrastructure (Routers, Guards, Analytics). Use callbacks or events instead.

### Rule 5: Visualize Before Implementing

Draw your dependency graph before coding. All arrows should point downward through layers. If you see circular or upward arrows, redesign.

## Checklist for Every DI Setup

- [ ] What layer does this belong to?
- [ ] Does it hold mutable state?
- [ ] Does it need to be shared app-wide?
- [ ] What does it depend on?
- [ ] Does this create a circular dependency?
- [ ] Does it hold resources that need cleanup?
- [ ] Can I test this easily with this setup?
