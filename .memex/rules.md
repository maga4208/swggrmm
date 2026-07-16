# SimpleIOSApp Documentation

## Project Overview
SimpleIOSApp is a basic iOS counter application built using a programmatic UI approach (no storyboards). The app displays a welcome message, a counter, and a button to increment the counter.

## Project Structure
```
SimpleIOSApp/
├── .git/                  # Git repository
├── .gitignore             # Git ignore file
├── .memex/                # Memex universe configuration directory
│   ├── config.yaml        # Project metadata for Memex
│   └── rules.md           # Project documentation and guidelines
├── SimpleIOSApp/          # Source code directory
│   ├── AppDelegate.swift  # Application delegate
│   ├── Info.plist         # App configuration
│   ├── LaunchScreen.storyboard # Launch screen
│   ├── SceneDelegate.swift # Scene lifecycle management
│   └── ViewController.swift # Main UI implementation
├── SimpleIOSApp.xcodeproj/ # Xcode project (generated)
└── project.yml            # XcodeGen configuration
```

## Memex Universe
The `.memex` directory is used by the Memex universe, a template system for project management. The `config.yaml` file stores metadata about the project, while `rules.md` (this file) provides instructions and documentation for working with this project. These files are used by the Memex agent to guide development and iteration on the project.

## Prerequisites
- macOS (required for Xcode)
- Xcode 14.0+ (Apple's IDE for iOS development)
- XcodeGen (tool for generating Xcode projects from YAML)

## Setup Instructions

### Install Xcode
```
# Install from Mac App Store or download from:
# https://developer.apple.com/xcode/
```

### Install XcodeGen
```bash
# Using Homebrew
brew install xcodegen

# Or using Mint
mint install yonaskolb/XcodeGen
```

## Building and Running

### Generate Xcode Project
```bash
xcodegen generate
```

### Open in Xcode
```bash
open SimpleIOSApp.xcodeproj
```

### Run the App
1. Select a simulator or connected device in Xcode
2. Press ⌘R or click the Run button

## Development Workflow

### Modifying the Project
1. Edit the `project.yml` file to change project settings
2. Run `xcodegen generate` to update the Xcode project

## App Features
- Welcome message display
- Counter with numeric display
- Increment button to increase counter value
- Programmatic UI implementation (no storyboards)
- iOS 15.0+ compatibility

## Troubleshooting
- If build fails, ensure Xcode command line tools are installed: `xcode-select --install`
- For code signing issues, check project settings and Apple Developer account
- For XcodeGen errors, verify `project.yml` syntax is correct
