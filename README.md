
# Universal Ads List iOS App

## Overview

The **Universal Ads List iOS App** is an application designed for iPhone and iPad that displays a list of advertisements retrieved from an API. It showcases features such as filtering, sorting, and detailed views of advertisements, combining **SwiftUI** and **UIKit** for the user interface. The project follows the **MVVM** architecture pattern, ensuring clean separation of concerns and testability.

## Features

- Universal app compatible with **iPhone** and **iPad**.
- Combine **SwiftUI** and **UIKit** for different screens.
- Fetch and display ads from a remote API.
- **Filters**:
  - Search by ad title.
  - Filter urgent ads.
  - Filter by categories.
- **Sorting**:
  - Alphabetical (A-Z and Z-A).
  - By price (ascending and descending).
- Detailed view of ads with additional information.
- Dynamic and responsive layout with support for light and dark modes.
- Fully testable with unit tests for critical components.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/peslopes/Universal-Ads-List-iOS-App.git
   ```

2. Open the project in Xcode:
   ```bash
   cd Universal-Ads-List-iOS-App
   open UniversalAdsList.xcodeproj
   ```

3. Select a simulator or connected device.

4. Build and run the project (`Cmd + R`).

## Requirements

- **Xcode 14.0+**
- **iOS 16.0+**
- **Swift 5.7+**

## Architecture

This project follows the **MVVM (Model-View-ViewModel)** architecture:

- **Model**:
  - Represents the data structures (e.g., `AdModel`, `CategoryModel`).
- **View**:
  - User interface components built with **SwiftUI** or **UIKit**.
- **ViewModel**:
  - Manages the state and logic, communicating between the Model and the View.
  - E.g., `AdsListViewModel`, `AdDetailsViewModel`, `CategoryFilterMenuViewModel`.

## Technologies Used

- **SwiftUI**
- **UIKit**
- **Combine**
- **XCTest**

## API

The app uses the following endpoints to fetch data:

- **Ads List**:
  [https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json](https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json)

- **Categories**:
  [https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json](https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json)

## Tests

### Unit Tests
- Written with `XCTest` for core ViewModels (`AdsListViewModel`, `AdDetailsViewModel`, etc.).
- Mock objects are used to simulate API responses and improve test reliability.

Run all tests:
```bash
Cmd + U
```
