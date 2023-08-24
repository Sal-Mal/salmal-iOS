// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "PackageName",
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.9.0"),
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.2.0"),
    ]
)