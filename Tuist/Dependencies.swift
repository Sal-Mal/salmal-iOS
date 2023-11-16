import ProjectDescription

let dependencies1 = Dependencies(
  swiftPackageManager: .init([
    .remote(
      url: "https://github.com/Alamofire/Alamofire",
      requirement: .upToNextMajor(from: "5.0.0")
    ),
    .remote(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      requirement: .upToNextMajor(from: "1.2.0")
    ),
    .remote(
      url: "https://github.com/kakao/kakao-ios-sdk",
      requirement: .branch("master")
    ),
    .remote(
      url: "https://github.com/firebase/firebase-ios-sdk",
      requirement: .upToNextMajor(from: "10.16")
    )
  ], productTypes: [
    "ComposableArchitecture": .framework
  ]),
  platforms: [.iOS]
)
