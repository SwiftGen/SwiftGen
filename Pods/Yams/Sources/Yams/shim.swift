//
//  shim.swift
//  Yams
//
//  Created by Norio Nomura 1/27/18.
//  Copyright (c) 2018 Yams. All rights reserved.
//

#if !_runtime(_ObjC) && !swift(>=4.2)
extension Substring {
    func hasPrefix(_ prefix: String) -> Bool {
        return String(self).hasPrefix(prefix)
    }
}
#endif
