# shopping_list_app

A lightweight Flutter shopping list application demonstrating form handling, state management, HTTP integration with Firebase Realtime Database, and robust error/loading handling.

## Project overview

This project is a simple, production-minded grocery/shopping list app built with Flutter. It showcases:
- Adding, editing, and deleting grocery items
- Validated forms for item input
- Local state management and UI updates
- Remote persistence via HTTP requests to Firebase Realtime Database
- Loading state and error response handling for network operations

The commit history indicates iterative development including: project initialization, adding the new item form, passing data and finalizing the shopping list, posting/fetching data with HTTP and Firebase Realtime Database, managing loading and error states, deleting items, and handling no-data edge cases.

## Features

- Add new grocery items with name, quantity and category
- Input validation and form reset
- Persist items to Firebase Realtime Database using HTTP requests
- Fetch remote items on start and merge with local state
- Delete items locally and remotely
- Visual loading indicators and user-friendly error messages
- Empty-state UI when no items exist

## Technologies

- Flutter (Dart)
- Firebase Realtime Database (REST HTTP API)
- Flutter Material widgets
- Navigator for routing and returning data between screens

## Getting started

Prerequisites
- Flutter SDK (stable channel) installed
- A Firebase Realtime Database instance (or adjust code to use a different backend)

Setup
1. Clone the repository:
   git clone <repo-url>
2. Open the project in your IDE (VS Code / Android Studio).
3. Install dependencies:
   flutter pub get
4. Configure Firebase:
   - Create a Firebase project and Realtime Database.
   - Set database rules (for development you may allow read/write, but secure for production).
   - Update the app code where the Firebase URL is used (search for your base URL in the project, e.g. in any service or data provider file).

Running
- Run on an emulator or device:
  flutter run

## Project structure (high level)

- lib/
  - main.dart — app entry point
  - widgets/
    - grocery_list.dart — main list UI & empty-state handling
    - new_item.dart — form screen for adding items (with validation)
  - models/ — domain models (GroceryItem, Category)
  - data/ — static data helpers and sample categories or dummy items

## Development notes

- Forms: The NewItem form uses a GlobalKey<FormState> on the Form widget to validate and reset fields safely.
- List rendering: The grocery list shows a centered message when there are no items. When items exist, the ListView.builder is used with a proper itemCount to avoid range errors.
- Networking: HTTP requests to Firebase are used for persisting and fetching items. The app handles loading states and displays error messages if operations fail.
- Error handling: Defensive checks are in place for null values and empty lists to prevent runtime exceptions.

## Testing and debugging

- Use Flutter's hot reload for iterative UI development.
- Use debug prints or breakpoints to inspect network responses and model mapping.
- Ensure correct Firebase URL and rules when testing remote sync.

## Contributing

Contributions are welcome. Suggested workflow:
1. Fork the repository
2. Create a feature branch (git checkout -b feature/my-feature)
3. Commit changes with clear messages
4. Open a pull request for review

Please include unit/widget tests for new features where applicable and document behavior in the README.

## License

This project does not include a license file. Add an appropriate open-source license (MIT, Apache 2.0, etc.) if you plan to publish the repo.

---

