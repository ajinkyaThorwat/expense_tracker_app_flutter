# Expense Tracker App (Flutter)

This is a mobile application built with Flutter to help users track their expenses. It utilizes Back4App as the backend for user authentication and data storage.

## Project Overview

The Expense Tracker App allows users to:

* Sign up and log in securely.
* Add new expense records, including title, amount, category, and date.
* View a history of their expenses, filtered by date range.
* Visualize their spending patterns using pie and bar charts.

## Technologies Used

* **Flutter:** For building cross-platform mobile applications (iOS and Android) from a single codebase.
* **Parse SDK for Flutter:** To interact with the Back4App backend for user authentication and data persistence.
* **Back4App:** A Backend as a Service (BaaS) platform that provides Parse Server hosting, database services, and user management.
* `video_player` package: For displaying a background video on the login screen.
* `fl_chart` package:  For creating interactive pie and bar charts to visualize expense data.

## Features

* **User Authentication:** Secure signup and login functionality managed by Back4App.
* **Expense Management:**
    * Adding new expenses with details (title, amount, category, date).
    * Viewing a list of expenses.
    * Editing existing expense records.
    * Deleting expenses.
* **Data Visualization:**
    * Pie chart to show expense distribution across categories.
    * Bar chart to compare spending across categories.
* **Data Persistence:** Expense data is stored on Back4App, ensuring data is saved even if the app is closed.

## Architecture

The application follows a layered architecture:

* **Frontend (Flutter):** Handles the user interface and user interactions.
* **Backend (Back4App):** Provides user authentication, data storage, and API endpoints.
* **Parse SDK:** Acts as a bridge between the Flutter app and the Back4App backend.

## Setup Instructions

1.  **Prerequisites:**
    * Flutter SDK installed on your development machine.
    * Android Studio or Xcode (depending on your target platform) for building the app.
    * A Back4App account and a created Parse App.

2.  **Clone the Repository:**
    ```bash
    git clone <your_repository_url>
    cd expense_tracker_app
    ```

3.  **Flutter Dependencies:**
    ```bash
    flutter pub get
    ```

4.  **Back4App Configuration:**
    * Replace the following values in `lib/main.dart` with your Back4App credentials:
        ```dart
        const appId = '<YOUR_APP_ID>';
        const clientKey = '<YOUR_CLIENT_KEY>';
        const serverUrl = '<YOUR_SERVER_URL>'; // Usually '[https://parseapi.back4app.com](https://parseapi.back4app.com)'
        await Parse().initialize(appId, serverUrl, clientKey: clientKey, autoSendSessionId: true);
        ```

5.  **Run the App:**
    * Connect an Android emulator/device or an iOS simulator/device.
    * ```bash
        flutter run
        ```

## Code Structure
lib/
├── main.dart             # Entry point of the Flutter application.
├── login_screen.dart     # Login screen with video background.
├── signup_screen.dart    # Signup screen.
├── home_screen.dart      # Main screen with expense tracking functionality.
├── widgets/
│   ├── InsightsTab.dart     # Tab for displaying expense insights (charts).
│   ├── expense_pie_chart.dart # Pie chart widget.
│   └── expense_bar_chart.dart # Bar chart widget.