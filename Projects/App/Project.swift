// Project.stencil

import ProjectDescription

let project = Project(
  name: "SalmalApp",
  options: .options(disableBundleAccessors: true, disableSynthesizedResourceAccessors: false),
  targets: [
    Target(
      name: "SalmalApp",
      platform: .iOS,
      product: .app,
      bundleId: "com.salmal.SalmalApp",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
      infoPlist: .extendingDefault(with: [
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
        "UILaunchStoryboardName": "LaunchScreen"
      ]),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .project(target: "UI", path: "../UI"),
        
        .external(name: "Alamofire"),
        .external(name: "Kingfisher"),
        .external(name: "ComposableArchitecture"),
      ]
    )
  ]
)
