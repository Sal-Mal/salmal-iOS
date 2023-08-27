import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
  description: "Custom template",
  attributes: [
    nameAttribute
  ],
  items: [
    .file(
      path: "Project.swift",
      templatePath: "Project.stencil"
    ),
    .file(
      path: "Sources/\(nameAttribute)App.swift",
      templatePath: "App.stencil"
    ),
    .file(
      path: "Sources/ContentView.swift",
      templatePath: "ContentView.stencil"
    ),
    .file(
      path: "Tests/\(nameAttribute)Tests.swift",
      templatePath: "AppTests.stencil"
    ),
    .file(
      path: "Resources/LaunchScreen.storyboard",
      templatePath: "LaunchScreen.stencil"
    ),
    .directory(
      path: "Resources",
      sourcePath: "Assets.xcassets"
    ),
    .directory(
      path: "Resources",
      sourcePath: "Preview Content"
    )
  ]
)
