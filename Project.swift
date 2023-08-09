import ProjectDescription
import ProjectDescriptionHelpers
import RTTuistSimplifier

// New feature: This manifest file will dynamically generate a bit different Xcode project depending if
//              it's run from local folder or being integrated as `.project(name:, path:)` dependency
//              from another root manifest file.
// E.g.:
//      Another root manifest file integrating this file using `.project(name: "TuistExampleLoggingLibrary", path: "Pods/TuistExampleLoggingLibrary")`
//
let isRootManifest = Environment.isRootManifest.getBoolean(default: false)

// MARK: - Project

let mainTargetName = "TuistRootManifestFileExample"

let mainTarget = Target.makeTarget(name: mainTargetName,
                                   sources: ["Targets/TuistRootManifestFileExample/Sources/**"],
                                   resources: ["Targets/TuistRootManifestFileExample/Resources/**"],
                                   dependencies: [
                                    .project(target: "TuistExampleLoggingLibrary", path: "Pods/TuistExampleLoggingLibrary"),
                                   ]
)

/** Test Targets **/
let testTarget = Target.makeTarget(name: "UnitTests",
                                   product: .unitTests,
                                   sources: ["Targets/TuistRootManifestFileExample/Tests/**"],
                                   dependencies: [
                                    .target(name: mainTargetName),
                                   ])

// we don't want to generate the test targets if integrated using `.project()` dependency
let targets = isRootManifest ? [mainTarget, testTarget] : [mainTarget]

/** Main Xcode Project **/
let project = Project.makeProject(name: mainTargetName,
                                  targets: targets)
