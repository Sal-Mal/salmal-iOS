// Project.stencil

import ProjectDescription

let project = Project(
  name: "LoginFeature",
  targets: [
    Target(
      name: "LoginFeature",
      platform: .iOS,
      product: .framework,
      bundleId: "com.framework.salmal.LoginFeature",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: .iphone),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: [
        .project(target: "UI", path: "../UI"),
        .project(target: "Core", path: "../Core")
      ]
    ),
    
    Target(
      name: "LoginFeatureTests",
      platform: .iOS,
      product: .unitTests,
      bundleId: "com.framework.salmal.LoginFeatureTests",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: .iphone),
      sources: ["Tests/**"],
      dependencies: [
        .target(name: "LoginFeature")
      ]
    ),
    
    Target(
      name: "LoginFeatureDemo",
      platform: .iOS,
      product: .app,
      bundleId: "com.framework.salmal.LoginFeatureDemo",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: .iphone),
      infoPlist: .extendingDefault(with: [
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
        "UILaunchStoryboardName": "LaunchScreen"
      ]),
      sources: ["DemoApp/Sources/**"],
      resources: ["DemoApp/Resources/**"],
      dependencies: [
        .target(name: "LoginFeature")
      ]
    ),
  ]
)
