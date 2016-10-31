import Foundation
import Commander
import PathKit
import Stencil
import GenumKit

enum CoreDataError: ErrorType, CustomStringConvertible {
  case InvalidMask(actual: String, placeholder: String)

  var description: String {
    switch self {
    case .InvalidMask(let actual, let placeholder):
      return "Incorrect --file-mask '\(actual)'. It should contain '\(placeholder)', e.g '\(placeholder).swift'"
    }
  }
}

let coreDataHumanCommand = commandForFile(.Human)
let coreDataMachineCommand = commandForFile(.Machine)

let coreDataModelCommand = command(
  outputOption,
  templateOption("coredata-model"), templatePathOption,
  Option<String>("enumName", "CoreDataEntity", flag: "e", description: "The name of the enum to generate"),
  Argument<Path>("FILE",
    description: "CoreData model tp parse.",
    validator: pathExists)
) { output, templateName, templatePath, enumName, modelPath in

  do {
    let templateRealPath = try findTemplate(
      "coredata-model",
      templateShortName: templateName,
      templateFullPath: templatePath
    )

    let parser = CoreDataModelParser()
    try parser.parseModelFile(String(modelPath))

    let template = try GenumTemplate(path: templateRealPath)
    let context = parser.stencilContext(enumName: enumName)
    let rendered = try template.render(context)

    output.write(rendered, onlyIfChanged: true)
  } catch {
    printError("error: failed to render template \(error)")
  }
}

private let classPlaceholder = "{{class}}"

private enum EntityFile {
  case Machine
  case Human

  var templatePrefix: String {
    switch self {
    case .Machine:
      return "coredata-machine"
    case .Human:
      return "coredata-human"
    }
  }

  var defaultMask: String {
    switch self {
    case .Machine:
      return "\(classPlaceholder)+Properties.swift"
    case .Human:
      return "\(classPlaceholder).swift"
    }
  }

  var isRewritable: Bool {
    switch self {
    case .Machine:
      return true
    case .Human:
      return false
    }
  }
}

private func commandForFile(fileType: EntityFile) -> CommandType {
  return command(
    templateOption(fileType.templatePrefix), templatePathOption,
    Option<String>("file-mask", "",
      description: "The file name mask for entity file, e.g: \"_\(classPlaceholder).swift\""),
    Option<Path>("output", ".",
      description: "The output directory"),
    Argument<Path>("FILE",
      description: "CoreData model to parse.",
      validator: pathExists)
  ) { templateName, templatePath, fileMask, outputDir, modelPath in

    do {

      let fileMask = fileMask.isEmpty ? fileType.defaultMask : fileMask

      if !fileMask.containsString(classPlaceholder) {
        throw CoreDataError.InvalidMask(actual: fileMask, placeholder: classPlaceholder)
      }

      let templateRealPath = try findTemplate(
        fileType.templatePrefix,
        templateShortName: templateName,
        templateFullPath: templatePath
      )

      let parser = CoreDataModelParser()
      try parser.parseModelFile(String(modelPath))

      let template = try GenumTemplate(path: templateRealPath)

      try outputDir.mkpath()

      for entity in parser.entities {
        guard let className = entity.className else {
          continue
        }
        let fileName = fileMask.stringByReplacingOccurrencesOfString(classPlaceholder, withString: className)
        let entityPath = outputDir + fileName
        if entityPath.exists && !fileType.isRewritable {
          continue
        }

        let context = parser.stencilContextForEntity(entity)

        let rendered = try template.render(context)

        let output: OutputDestination = .File(entityPath)
        output.write(rendered, onlyIfChanged: true)
      }
    } catch {
      printError("error: failed to render template \(error)")
    }
  }
}
