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
            path: "Sources/SalmalApp.swift",
            templatePath: "SalmalApp.stencil"
        ),
        .file(
            path: "Sources/ContentView.swift",
            templatePath: "ContentView.stencil"
        ),
        .file(
            path: "Sources/LaunchScreen.storyboard",
            templatePath: "LaunchScreen.stencil"
        )
    ]
)
