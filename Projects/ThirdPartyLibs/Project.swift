// Project.stencil

import ProjectDescription

let project = Project(
  name: "ThirdPartyLibs",
  targets: [
    Target(
      name: "ThirdPartyLibs",
      platform: .iOS,
      product: .framework,
      bundleId: "com.framework.salmal.ThirdPartyLibs",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: [
        .external(name: "Alamofire"),
        .external(name: "Kingfisher"),
        .external(name: "ComposableArchitecture")
      ]
    )
  ]
)
