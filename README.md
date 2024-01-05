# FileDownloader
>  A simple and powerful framework for downloading files in Swift.

## Features

- [x] Closure-based and Combine-based APIs for flexibility.
- [x] Pause, resume, and cancel downloads.
- [x] Progress tracking
- [x] Caching for performance
- [x] Error handling
- [x] Easy file retrieval

#### 🔨 Technologies: Swift, Combine, No Third Party libraries.
####  🚀Platform: 📱iOS & 🖥️MacOS

## Includes

- [x] Neuromorphic design on reusable AddButton.
- [x] Custom modifiers to speed up your layout creation.
- [x] Handling reactively the keyboard
- [x] Modal presentation to add new tasks

## Requirements

- iOS 13.0+
- Xcode 11.0+

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Getting Started


### Using CocoaPods 
To install it, simply add the following line to your Podfile:

```ruby
pod 'FileDownloader'
```


### Using Swift Package Manager:

1. Add the following to your Package.swift file:
```Swift
dependencies: [
    .package(url: "https://github.com/HolyBuz/FileDownloader")
]
```

2. Run swift package update to fetch the package.

## Usage

1. Import the framework:

```Swift
import FileDownloader
```

2. Create a File object:

```Swift
let file = File(url: URL(string: "https://example.com/file.zip")!)
```

3. Start the download:

Using closures:

```Swift
FileHandler.download(file: file) { progress in
    print("Progress:", progress)
} onCompletion: { result in
    switch result {
    case .success(let locationURL):
        print("Download complete:", locationURL)
    case .failure(let error):
        print("Error:", error)
    }
}
```

Using Combine:

```Swift
let publisher = DownloadTaskPublisher(file: file)

publisher.sink { completion in
    print("Completion:", completion)
} receiveValue: { event in
    switch event {
    case .progress(let percentage):
        print("Progress:", percentage)
    case .url(let locationURL):
        print("Location URL:", locationURL)
    }
}
```

4. Pause, resume, or cancel downloads:

```Swift
FileHandler.pause(file: file)
FileHandler.resume(file: file)
FileHandler.cancel(file: file)
```

5. Retrieve a downloaded file:

```Swift
let localFileURL = FileHandler.get(file: file)
```
## Author

HolyBuz, holybuz@gmail.com

## License

FileDownloader is available under the MIT license. See the LICENSE file for more info.

## Thanks for stopping by!
