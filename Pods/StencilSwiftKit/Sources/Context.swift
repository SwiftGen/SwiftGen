//
//  Context.swift
//  Pods
//
//  Created by David Jennes on 14/02/2017.
//
//

import Foundation

public func enrich(context: [AnyHashable: Any], parameters: [String]) throws -> [AnyHashable: Any] {
  var context = context
  
  context["env"] = ProcessInfo().environment
  context["param"] = try Parameters.parse(items: parameters)
  
  return context
}
