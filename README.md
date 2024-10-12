# SLIC Mobile Application

## Overview

This Flutter application is developed for Saudi Arabia Leather Industry (SLIC), a leading company in the leather industry. The app aims to streamline various business processes and improve operational efficiency.

## Features

- **Sales Order Management**: Create and manage sales orders efficiently.
- **Customer Quotation**: Generate and track customer quotations.
- **Stock Transfer**: Manage stock transfers between different locations.
- **Sales Return Invoice**: Process and manage sales returns.
- **Goods Issue**: Handle goods issues from production to finished goods.
- **Foreign Purchase Order**: Manage foreign purchase orders.
- **Logging System**: Comprehensive logging for debugging and auditing.

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio or VS Code with Flutter extensions

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/your-repo/slic-mobile-app.git
   ```
2. Navigate to the project directory:
   ```
   cd slic-mobile-app
   ```
3. Install dependencies:
   ```
   flutter pub get
   ```
4. Run the app:
   ```
   flutter run
   ```

## Project Structure

- `lib/`: Contains the main Dart code for the application.
  - `cubits/`: State management using Cubit pattern.
  - `models/`: Data models for the application.
  - `services/`: API and other services.
  - `view/`: UI components and screens.
    - `screens/`: Individual screens of the application.
    - `widgets/`: Reusable UI components.
  - `utils/`: Utility functions and constants.

## Key Components

- **LogViewerScreen**: A dedicated screen for viewing and managing application logs.
- **MainScreen**: The main dashboard of the application, providing access to various features.
- **SalesOrderScreen**: Manages sales order operations.
- **LogService**: Handles logging functionality throughout the application.

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the [MIT License](LICENSE).

## Contact

For any queries regarding this project, please contact the SLIC IT department.
