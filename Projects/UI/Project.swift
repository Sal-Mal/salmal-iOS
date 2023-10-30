// Project.stencil

import ProjectDescription

let project = Project(
  name: "UI",
  options: .options(
    disableBundleAccessors: true,
    disableSynthesizedResourceAccessors: true
  ),
  targets: [
    Target(
      name: "UI",
      platform: .iOS,
      product: .framework,
      bundleId: "com.framework.salmal.UI",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: .iphone),
      infoPlist: .default,
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .project(target: "ThirdPartyLibs", path: "../ThirdPartyLibs")
      ]
    ),
    
    Target(
      name: "UITests",
      platform: .iOS,
      product: .unitTests,
      bundleId: "com.framework.salmal.UITests",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: .iphone),
      sources: ["Tests/**"],
      dependencies: [
        .target(name: "UI")
      ]
    ),
    
    Target(
      name: "UIDemo",
      platform: .iOS,
      product: .app,
      bundleId: "com.framework.salmal.UIDemo",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: .iphone),
      infoPlist: .extendingDefault(with: [
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
        "UILaunchStoryboardName": "LaunchScreen"
      ]),
      sources: ["DemoApp/Sources/**"],
      resources: ["DemoApp/Resources/**"],
      dependencies: [
        .target(name: "UI")
      ]
    ),
  ]
)
