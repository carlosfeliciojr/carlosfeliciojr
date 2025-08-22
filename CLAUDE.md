# TODO List

Act as an expert Flutter software developer. Your task is to generate the code for a simple to-do list application based on the following requirements.

Please use Flutter.

**1. Data Models:**
The application needs two primary data models: `List` and `Task`.

* **List Model:**
    * `id`: A unique identifier.
    * `title`: A string for the list's name.
    * `createdAt`: A timestamp or datetime object for when the list was created.

* **Task (or Item) Model:**
    * `id`: A unique identifier.
    * `listId`: A reference to the parent `List` it belongs to.
    * `description`: A string describing the task.
    * `createdAt`: A timestamp or datetime object.
    * `dueDate`: A timestamp or datetime object for the deadline.
    * `isCompleted`: A boolean, defaulting to `false`.

**2. Core Functionality (CRUD Operations):**
Implement the logic for the following features:

* **Lists:**
    * Create a new list.
    * Read/view existing lists.
    * Delete a list (which should also delete all its associated tasks).
* **Tasks:**
    * Add a new task to a specific list.
    * Edit an existing task (e.g., change its description or `dueDate`).
    * Mark a task as complete by updating the `isCompleted` status.
    * Delete a task.

**3. Business Logic: Overdue Warning**
There must be a way to determine if a task is overdue.

* Implement a function or property for the `Task` model called `isOverdue`.
* This function should return `true` only if the current date and time is past the task's `dueDate` AND the task's `isCompleted` status is `false`.

**4. Code Structure:**
* Please organize the code into logical classes, modules, or functions.
* For this example, manage the data in memory (e.g., using arrays or dictionaries). No external database is required.
* Include comments to explain the key parts of the code.
* Provide a simple example showing how to use the generated code (e.g., create a list, add a few tasks, and check their overdue status).

# Flutter Architecture Rules

Based on the Flutter Architecture Guide:

## Core Principles

1. **Separation of Concerns**: Split application into UI layer and Data layer
2. **MVVM Pattern**: Use Model-View-ViewModel architectural pattern
3. **Single Responsibility**: Each component has distinct responsibilities

## Architecture Components

### UI Layer
- **Views**: Widget compositions that describe UI and handle user interactions
  - Should contain minimal logic (only UI-related)
  - Pass events to view models
  - 1:1 relationship with view models
- **View Models**: Handle business logic and UI state
  - Transform repository data for UI consumption
  - Maintain UI state during configuration changes
  - Expose commands for view interactions
  - Should be testable independently of Flutter widgets

### Data Layer
- **Repositories**: Source of truth for application data
  - Transform raw service data into domain models
  - Handle caching, error handling, retry logic
  - One repository per data type
  - Should never be aware of other repositories
- **Services**: Lowest layer wrapping external APIs
  - Expose asynchronous response objects (Future/Stream)
  - Hold no state
  - One service per data source
  - Isolate data-loading operations

## Architecture Rules

1. **Dependency Direction**: UI layer depends on Data layer, never the reverse
2. **Component Relationships**:
   - Views ↔ View Models (1:1)
   - View Models ↔ Repositories (many-to-many)
   - Repositories ↔ Services (many-to-many)
3. **Data Flow**: User actions → View → View Model → Repository → Service
4. **State Management**: View models manage UI state, repositories manage data state
5. **Testing**: Each layer should be independently testable
6. **Modularity**: Components should have well-defined interfaces and boundaries

## Implementation Guidelines

- Views should only contain:
  - Simple if-statements for conditional rendering
  - Animation logic
  - Layout logic based on device info
  - Simple routing logic
- View Models should handle all data-related logic
- Repositories should handle business logic around services
- Services should only wrap external data sources
- Use commands pattern for view-to-viewmodel communication

## Simple App Structure

For this TODO app, use simplified MVVM without domain layer:
- **Models**: `TodoList` and `Task` data classes
- **Views**: Widget classes for UI screens
- **ViewModels**: Business logic and state management
- **Repositories**: In-memory data management (no external services needed)

# Conventional Commits Rules

Follow the Conventional Commits specification (https://www.conventionalcommits.org/en/v1.0.0/):

## Commit Message Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Types

- **feat**: A new feature for the user
- **fix**: A bug fix for the user
- **docs**: Changes to documentation
- **style**: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **test**: Adding missing tests or correcting existing tests
- **chore**: Changes to the build process or auxiliary tools and libraries such as documentation generation
- **perf**: A code change that improves performance
- **ci**: Changes to CI configuration files and scripts
- **build**: Changes that affect the build system or external dependencies
- **revert**: Reverts a previous commit

## Examples

- `feat: add user authentication`
- `fix: resolve null pointer exception in task deletion`
- `docs: update README with installation instructions`
- `refactor: extract task validation logic into separate method`
- `test: add unit tests for TodoList model`
- `chore: update dependencies to latest versions`

## Rules

1. Use present tense ("add feature" not "added feature")
2. Use lowercase for type and description
3. Keep description under 50 characters
4. Include scope when applicable: `feat(auth): add login functionality`
5. Use body to explain what and why, not how
6. Include breaking change footer if applicable: `BREAKING CHANGE: removed deprecated API`