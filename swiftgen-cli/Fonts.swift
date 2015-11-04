//
// SwiftGen
// Copyright (c) 2015 Josep Rodriguez
// MIT Licence
//

import Commander
import PathKit
import GenumKit

let fontsCommand = command(
	outputOption,
	templateOption("fonts"),
	templatePathOption,
	Option<String>("enumName", "Name", flag: "e", description: "The name of the enum to generate"),
	Argument<Path>("FILE", description: "Fonts.plist file to parse.",validator: fileExists))
	{ output, templateName, templatePath, enumName, path in
		
  let parser = FontFileParser()
  
  do {
	try parser.parseTextFile(String(path))
	
	let templateRealPath = try findTemplate("fonts", templateShortName: templateName, templateFullPath: templatePath)
	let template = try GenumTemplate(path: templateRealPath)
	let context = parser.stencilContext(enumName: enumName)
	let rendered = try template.render(context)
	output.write(rendered)
  }
  catch {
	print("Failed to render template \(error)")
  }
}
