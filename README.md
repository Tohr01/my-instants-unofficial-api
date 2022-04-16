<p align="center">
  <img src="https://github.com/Tohr01/my-instants-unofficial-api/blob/main/pictures/banner.jpg" style="object-fit: cover; width: 100%;" alt="An unofficial API for myinstants.com"/>
</p>

## Installation
1. Add this line to your Package.swift
```
.package(url: "https://github.com/Tohr01/my-instants-unofficial-api.git", from: "1.0.2")
```

## Usage example

```swift
import Foundation
import my_instants_unofficial_api

Task {
    let instants = MyInstants()
    do {
        let buttons = try await instants.search("test")
        guard let buttons = buttons else {
            return
        }

        print(buttons) // Prints array of buttons. Every button in array will contain the name and complete the audio URL
    } catch {
        print(error.localizedDescription)
    }
}
```
Remember to make sure, that the main process doesn't quit while the Task is running.

## Todo
1. Support iOS
2. Implement downloading of audio files

## Package requirements
```
macOS Catalina (10.15) or higher
```

## Dependencies
🔍 HTML parsing done with [SwiftSoup](https://github.com/scinfu/SwiftSoup)
