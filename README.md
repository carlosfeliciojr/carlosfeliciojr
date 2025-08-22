# Vibe Coding TODO List

A Flutter TODO list application with overdue task monitoring and glassmorphism UI design.

## Features

- Create and manage multiple TODO lists
- Add, edit, and delete tasks with due dates
- Real-time overdue task monitoring and notifications
- Modern glassmorphism UI design
- Task completion tracking

## Getting started

1. Make sure you have Flutter installed
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application

## Usage

The app follows MVVM architecture with:
- Task and TodoList models for data structure
- ViewModels for business logic
- Repository pattern for data management
- Real-time notifications for overdue tasks

```dart
// Example usage
final task = Task(
  description: 'Complete project',
  dueDate: DateTime.now().add(Duration(days: 1)),
);
```

## Architecture

Built following Flutter architecture guidelines with clear separation of concerns:
- UI Layer: Views and ViewModels
- Data Layer: Repositories and Models
- MVVM pattern implementation
