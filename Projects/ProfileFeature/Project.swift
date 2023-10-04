// Project.stencil

import ProjectDescription

let project = Project(
  name: "ProfileFeature",
  targets: [
    Target(
      name: "ProfileFeature",
      platform: .iOS,
      product: .framework,
      bundleId: "com.framework.salmal.ProfileFeature",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: .iphone),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: [
        .project(target: "UI", path: "../UI"),
        .project(target: "Core", path: "../Core")
      ]
    ),
    
    Target(
      name: "ProfileFeatureTests",
      platform: .iOS,
      product: .unitTests,
      bundleId: "com.framework.salmal.ProfileFeatureTests",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: .iphone),
      sources: ["Tests/**"],
      dependencies: [
        .target(name: "ProfileFeature")
      ]
    ),
    
    Target(
      name: "ProfileFeatureDemo",
      platform: .iOS,
      product: .app,
      bundleId: "com.framework.salmal.ProfileFeatureDemo",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: .iphone),
      infoPlist: .extendingDefault(with: [
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
        "UILaunchStoryboardName": "LaunchScreen"
      ]),
      sources: ["DemoApp/Sources/**"],
      resources: ["DemoApp/Resources/**"],
      dependencies: [
        .target(name: "ProfileFeature")
      ]
    ),
  ]
)
