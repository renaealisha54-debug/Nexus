# Nexus
​Nexus IDE is a single-file, mobile-first web application designed as a lightweight, browser-based code editor. I
# Nexus IDE

Nexus IDE is a lightweight, mobile-first development environment engineered to run natively on Android devices. By wrapping an optimized, modern web-editor front end inside a native Java WebView container, Nexus IDE balances cross-platform visual consistency with native device performance. 

The application is designed specifically for developers who require a highly focused, distraction-free interface to write, review, or refactor code on mobile viewports.

## Core Architecture

The project utilizes a hybrid mobile architecture:
*   **Native Layer:** Written in Java (`MainActivity.java`), it handles hardware acceleration, window resizing constraints when the virtual keyboard is toggled, and establishes a secure JavaScript bridge (`AndroidBridge`).
*   **Web Layer:** Built with vanilla HTML5, CSS3 variables, and modern asynchronous JavaScript. It runs locally out of the device's application assets, eliminating network dependency for core interface loading.

## Repository Layout

```text
NexusIDE/
├── app/
│   ├── src/
│   │   ├── main/
│   │   │   ├── assets/
│   │   │   │   └── index.html             # Core IDE Frontend (HTML/CSS/JS)
│   │   │   ├── java/com/nexus/ide/
│   │   │   │   └── MainActivity.java      # Native Android WebContainer Hook
│   │   │   └── AndroidManifest.xml        # Device Permission Blueprint
│   │   └── build.gradle                   # Module Compilation Settings
│   ├── build.gradle                       # Top-Level Build Rules
│   ├── settings.gradle                    # Project Module Registry
│   ├── README.md                          # Project Documentation
│   └── LICENSE                            # MIT License Terms
