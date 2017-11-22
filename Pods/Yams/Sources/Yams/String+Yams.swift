//
//  String+Yams.swift
//  Yams
//
//  Created by Norio Nomura on 12/7/16.
//  Copyright (c) 2016 Yams. All rights reserved.
//

import Foundation

extension String {
    typealias LineNumberColumnAndContents = (lineNumber: Int, column: Int, contents: String)

    /// line number, column and contents at utf8 offset.
    ///
    /// - Parameter offset: Int
    /// - Returns: lineNumber: line number start from 0,
    ///            column: utf16 column start from 0,
    ///            contents: substring of line
    func utf8LineNumberColumnAndContents(at offset: Int) -> LineNumberColumnAndContents? {
        guard let index = utf8
            .index(utf8.startIndex, offsetBy: offset, limitedBy: utf8.endIndex)?
            .samePosition(in: self) else { return nil }
        return lineNumberColumnAndContents(at: index)
    }

    /// line number, column and contents at utf16 offset.
    ///
    /// - Parameter offset: Int
    /// - Returns: lineNumber: line number start from 0,
    ///            column: utf16 column start from 0,
    ///            contents: substring of line
    func utf16LineNumberColumnAndContents(at offset: Int) -> LineNumberColumnAndContents? {
        guard let index = utf16
            .index(utf16.startIndex, offsetBy: offset, limitedBy: utf16.endIndex)?
            .samePosition(in: self) else { return nil }
        return lineNumberColumnAndContents(at: index)
    }

    /// line number, column and contents at Index.
    ///
    /// - Parameter index: String.Index
    /// - Returns: lineNumber: line number start from 0,
    ///            column: utf16 column start from 0,
    ///            contents: substring of line
    func lineNumberColumnAndContents(at index: Index) -> LineNumberColumnAndContents {
        assert((startIndex..<endIndex).contains(index))
        var number = 0
        var outStartIndex = startIndex, outEndIndex = startIndex, outContentsEndIndex = startIndex
        getLineStart(&outStartIndex, end: &outEndIndex, contentsEnd: &outContentsEndIndex,
                     for: startIndex..<startIndex)
        while outEndIndex <= index && outEndIndex < endIndex {
            number += 1
            let range: Range = outEndIndex..<outEndIndex
            getLineStart(&outStartIndex, end: &outEndIndex, contentsEnd: &outContentsEndIndex,
                         for: range)
        }
        let utf16StartIndex = outStartIndex.samePosition(in: utf16)!
        let utf16Index = index.samePosition(in: utf16)!
        return (
            number,
            utf16.distance(from: utf16StartIndex, to: utf16Index),
            String(self[outStartIndex..<outEndIndex])
        )
    }

    /// substring indicated by line number.
    ///
    /// - Parameter line: line number starts from 0.
    /// - Returns: substring of line contains line ending characters
    func substring(at line: Int) -> String {
        var number = 0
        var outStartIndex = startIndex, outEndIndex = startIndex, outContentsEndIndex = startIndex
        getLineStart(&outStartIndex, end: &outEndIndex, contentsEnd: &outContentsEndIndex,
                     for: startIndex..<startIndex)
        while number < line && outEndIndex < endIndex {
            number += 1
            let range: Range = outEndIndex..<outEndIndex
            getLineStart(&outStartIndex, end: &outEndIndex, contentsEnd: &outContentsEndIndex,
                         for: range)
        }
        return String(self[outStartIndex..<outEndIndex])
    }

    /// String appending newline if is not ending with newline.
    var endingWithNewLine: String {
        let isEndsWithNewLines = unicodeScalars.last.map(CharacterSet.newlines.contains) ?? false
        if isEndsWithNewLines {
            return self
        } else {
            return self + "\n"
        }
    }
}
