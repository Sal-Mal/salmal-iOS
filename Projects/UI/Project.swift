// Project.stencil

import ProjectDescription

let project = Project(
  name: "UI",
  targets: [
    Target(
      name: "UI",
      platform: .iOS,
      product: .framework,
      bundleId: "com.framework.salmal.UI",
      infoPlist: .default,
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        
      ]
    ),
    
    Target(
      name: "UITests",
      platform: .iOS,
      product: .unitTests,
      bundleId: "com.framework.salmal.UITests",
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
