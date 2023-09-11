// Project.stencil

import ProjectDescription

let project = Project(
  name: "MainFeature",
  targets: [
    Target(
      name: "MainFeature",
      platform: .iOS,
      product: .framework,
      bundleId: "com.framework.salmal.MainFeature",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: [
        .project(target: "UI", path: "../UI"),
        .project(target: "Core", path: "../Core")
      ]
    ),
    
    Target(
      name: "MainFeatureTests",
      platform: .iOS,
      product: .unitTests,
      bundleId: "com.framework.salmal.MainFeatureTests",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
      sources: ["Tests/**"],
      dependencies: [
        .target(name: "MainFeature")
      ]
    ),
    
    Target(
      name: "MainFeatureDemo",
      platform: .iOS,
      product: .app,
      bundleId: "com.framework.salmal.MainFeatureDemo",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
      infoPlist: .extendingDefault(with: [
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
        "UILaunchStoryboardName": "LaunchScreen"
      ]),
      sources: ["DemoApp/Sources/**"],
      resources: ["DemoApp/Resources/**"],
      dependencies: [
        .target(name: "MainFeature")
      ]
    ),
  ]
)
