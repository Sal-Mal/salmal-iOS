// Project.stencil

import ProjectDescription

let project = Project(
  name: "Core",
  targets: [
    Target(
      name: "Core",
      platform: .iOS,
      product: .framework,
      bundleId: "com.framework.salmal.Core",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: .iphone),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: [
        .external(name: "Alamofire")
      ]
    ),
    
    Target(
      name: "CoreTests",
      platform: .iOS,
      product: .unitTests,
      bundleId: "com.framework.salmal.CoreTests",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: .iphone),
      sources: ["Tests/**"],
      dependencies: [
        .target(name: "Core")
      ]
    )
  ]
)
