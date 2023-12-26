// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UnsplashPhotoPicker",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "UnsplashPhotoPicker",
            targets: ["UnsplashPhotoPicker"]),
        .library(
            name: "UnsplashPhotoPickerUI_iOS",
            targets: ["UnsplashPhotoPickerUI_iOS"]),
        .library(
            name: "UnsplashPhotoPickerUI_tvOS",
            targets: ["UnsplashPhotoPickerUI_tvOS"]),
    ],
    targets: [
        .target(
            name: "UnsplashPhotoPicker",
            dependencies: [],
            path: "UnsplashPhotoPicker/UnsplashPhotoPicker",
            exclude: ["Info.plist", "UnsplashPhotoPicker.h"]
        ),
        .target(
            name: "UnsplashPhotoPickerUI_iOS",
            dependencies: ["UnsplashPhotoPicker"],
            path: "UnsplashPhotoPicker/UnsplashPhotoPickerUI_iOS",
            resources: [
                .process("Resources/PhotoViewFor_iOS.xib"),
            ]
        ),
        .target(
            name: "UnsplashPhotoPickerUI_tvOS",
            dependencies: ["UnsplashPhotoPicker"],
            path: "UnsplashPhotoPicker/UnsplashPhotoPickerUI_tvOS",
            resources: [
                .process("Resources/PhotoViewFor_tvOS.xib"),
            ]
        )
    ]
)
