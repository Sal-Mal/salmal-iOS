import ProjectDescription

let dependencies = Dependencies(
  swiftPackageManager: [
    .remote(url: "https://github.com/onevcat/Kingfisher", requirement: .upToNextMajor(from: "7.9.0")),
    .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .upToNextMajor(from: "5.0.0")),
    .remote(url: "https://github.com/pointfreeco/swift-composable-architecture", requirement: .upToNextMajor(from: "1.2.0"))
  ],
  platforms: [.iOS]
)
