# UserListMVVM

A modern iOS application using MVVM pattern, Combine framework for reactive programming, and programmatic UIKit implementation.

## 🏗 Architecture

The project follows the MVVM (Model-View-ViewModel) architecture pattern with a Coordinator pattern for navigation flow management. 
Each module is structured with clear separation of concerns:
```
Module/
├── Model/
│   └── CellViewModel/
├── View/
│   └── Cells/
├── ViewController/
└── ViewModel/
```

### Component Responsibilities

- **Model**: Contains the cell view models that handle the presentation logic for table/collection view cells
- **View**: Manages UI state changes and user interactions that don't require navigation
- **ViewController**: Handles navigation actions and view controller-specific UI operations
- **ViewModel**: Implements business logic and manages data flow

## 🛠 Technical Stack

- **UI Framework**: Programmatic UIKit
- **Reactive Programming**: Combine
- **iOS Deployment Target**: iOS 13.0+
- **Pattern**: MVVM + Coordinator
- **Data Management**: Diffable Data Source

## 🔑 Key Features

### Modern Collection View Implementation
- Utilizes `UITableViewDiffableDataSource` for efficient data management
- Automatic diffing and animations for data updates
- No more unneccessary `reloadData` calls


### Coordinator Pattern for Root Changes
- Type-safe routing & data passing using enum cases

```swift
enum Roots: Hashable {
    case splash
    case userList([User])
}
```

### MVVM Implementation
- Clear separation of concerns
- Protocol-oriented view model interfaces
- Reactive state management

```swift
protocol UserListViewModelProtocol {
    var state: AnyPublisher<UserListViewState, Never> { get }
    var destination: AnyPublisher<UserListDestinations?, Never> { get }
}
```

### Programmatic UI
- No storyboards or XIB files
- Clean and maintainable UI code
- Proper use of Auto Layout constraints

## 🚀 Getting Started

1. Clone the repository
2. Open `UserListMVVM.xcodeproj`
3. Build and run the project
4. In order to test with actual device, you need to change the team and bundle identifier in the project settings.

## 📦 Requirements

- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

## 🔨 Installation

```bash
git clone https://github.com/yourusername/UserListMVVM.git
cd UserListMVVM
```

## 👨‍💻 Author

Furkan Alioglu
