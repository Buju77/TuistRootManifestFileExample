import ProjectDescription
// import ProjectDescriptionHelpers  // no idea why this needs to be commented out to make generation work

import RTTuistSimplifier

// New feature: This manifest file will dynamically generate a bit different Xcode project depending if
//              it's run from local folder or being integrated as `.project(name:, path:)` dependency
//              from another root manifest file.
// E.g.:
//      Another root manifest file integrating this file using `.project(name: "TuistExampleLoggingLibrary", path: "Pods/TuistExampleLoggingLibrary")`
//
let isRootManifest = Environment.isRootManifest.getBoolean(default: false)

// MARK: Main Target

let mainTargetName = "TuistExampleLoggingLibrary"

// Header search path needs to be adapted depending on how its integrated: local vs pods dependency
let headerPrefix = isRootManifest ? "" : "../../"

let targetSettings: Settings = .settings(
    base: [
        "OTHER_LDFLAGS": "-ObjC",
        "HEADER_SEARCH_PATHS": ["$(inherited)",
                                "\(headerPrefix)Tuist/Dependencies/SwiftPackageManager/.build/checkouts/CocoaLumberjack/Sources/**",
                               ]
    ]
)
let mainTarget = Target.makeTarget(name: mainTargetName,
                                   sources: ["TuistExampleLoggingLibrary/Sources/**"],
                                   dependencies: [
                                    .external(name: "CocoaLumberjack"),
                                    .external(name: "CocoaLumberjackSwift")
                                   ],
                                   settings: targetSettings)

// MARK: Test Targets

let unitTestsTarget = Target.makeTarget(name: "UnitTests",
                                        product: .unitTests,
                                        sources: ["UnitTests/**"],
                                        dependencies: [
                                            .target(name: mainTargetName)
                                        ])

let integrationTestsTarget = Target.makeTarget(name: "IntegrationTests",
                                               product: .unitTests,
                                               sources: ["IntegrationTests/**"],
                                               dependencies: [
                                                .target(name: mainTargetName)
                                               ])

// MARK: Main Xcode Project

// we don't want to generate the test targets if integrated using `.project()` dependency
let targets = isRootManifest ? [mainTarget, unitTestsTarget, integrationTestsTarget] : [mainTarget]

let project = Project.makeProject(name: mainTargetName,
                                  targets: targets,
                                  addDefaultAdditionalFiles: isRootManifest, // only add when local
                                  generateSwiftlintTarget: isRootManifest,   // only generate when local
                                  generateSchemes: isRootManifest)           // only generate when local
