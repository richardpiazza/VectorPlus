# VectorPlus

A utility & library for interacting with SVG documents.

<p>
    <img src="https://github.com/richardpiazza/VectorPlus/workflows/Swift/badge.svg?branch=main" />
    <img src="https://img.shields.io/badge/Swift-5.2-orange.svg" />
    <a href="https://twitter.com/richardpiazza">
        <img src="https://img.shields.io/badge/twitter-@richardpiazza-blue.svg?style=flat" alt="Twitter: @richardpiazza" />
    </a>
</p>

## Usage

VectorPlus is distributed using the [Swift Package Manager](https://swift.org/package-manager). To install it into a project, add it as a dependency within your `Package.swift` manifest:

```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/richardpiazza/VectorPlus.git", from: "0.3.0")
    ],
    ...
)
```

Then import the **VectorPlus** packages wherever you'd like to use it:

```swift
import VectorPlus
```

## Packages

### VectorPlus

**VectorPlus** acts primarily as a wrapper over `SwiftSVG` providing extensions for interacting with:

* `CoreGraphics`
* `UIKit`
* `AppKit`
* `SwiftUI`

When linked to a target that supports one of these frameworks, multiple options become available.

#### CoreGraphics

* `CGMutablePath.addCommand(_:from:to:)`: Adds a `Path.Command` to the mutable path. The addition of the `Rect`s allow for correct placement and scaling.

* `CGContext.render(path:from:to:) throws`: Rendered a `Path` in the given context. Uses information about _fills_ and _strokes_ to fill and/or stroke the path.

#### UIKit

* `SVG.uiImage(size:) -> UIImage?`: A `CoreGraphics` rendered `UIImage` representation of the SVG paths.

* `SVG.pngData(size:) -> Data?`: A `Data` representation of the `UIImage`.

* **`SVGImageView`**: A `UIImageView` subclass that supports the assignment of an `SVG` object. The `.image` will automatically be generated using the view `bounds`.

#### AppKit

* `SVG.nsImage(size:) -> NSImage?`: A `CoreGraphics` rendered `NSImage` representation of the SVG paths.

* `SVG.pngData(size:) -> Data?`: A `Data` representation of the `NSImage`.

#### SwiftUI

* `SVGView(svg:)`: A `SwiftUI.View` that renders a `SVG` document.

## Command Line Interface

### Inspect

Parses an SVG document and prints out the document description.

### Convert

Parses an SVG document and creates a PNG rendered version of the `Command`s.

Supported conversion options are:

* **absolute**: Translates all elements to 'absolute' paths.

* **symbols**: Generates an Apple Symbols compatible SVG.

* **uikit**: A `UIImageView` subclass that supports dynamic sizing.

### Preview

_macOS only_

Parses an SVG document displaying the results in an Application window. Do to limitations, this sub-command is only available when the `AppKit` framework is present.

### Render

_macOS only_

Parses an SVG document and creates a PNG rendered version of the `Command`s. Do to limitations, this sub-command is only available when the `AppKit` framework is present.
