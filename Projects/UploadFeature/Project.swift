// Project.stencil

import ProjectDescription

let project = Project(
  name: "UploadFeature",
  targets: [
    Target(
      name: "UploadFeature",
      platform: .iOS,
      product: .framework,
      bundleId: "com.framework.salmal.UploadFeature",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: .iphone),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: [
        .project(target: "UI", path: "../UI"),
        .project(target: "Core", path: "../Core")
      ]
    ),
    
    Target(
      name: "UploadFeatureTests",
      platform: .iOS,
      product: .unitTests,
      bundleId: "com.framework.salmal.UploadFeatureTests",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: .iphone),
      sources: ["Tests/**"],
      dependencies: [
        .target(name: "UploadFeature")
      ]
    ),
    
    Target(
      name: "UploadFeatureDemo",
      platform: .iOS,
      product: .app,
      bundleId: "com.framework.salmal.UploadFeatureDemo",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: .iphone),
      infoPlist: .extendingDefault(with: [
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
        "UILaunchStoryboardName": "LaunchScreen"
      ]),
      sources: ["DemoApp/Sources/**"],
      resources: ["DemoApp/Resources/**"],
      dependencies: [
        .target(name: "UploadFeature")
      ]
    ),
  ]
)
