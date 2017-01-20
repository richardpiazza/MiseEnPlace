//===----------------------------------------------------------------------===//
//
// String+MiseEnPlace.swift
//
// Copyright (c) 2016 Richard Piazza
// https://github.com/richardpiazza/MiseEnPlace
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
//===----------------------------------------------------------------------===//

import Foundation

internal extension String {
    internal func ranges(of: String, options: NSString.CompareOptions, range: Range<Index>?, locale: Locale?) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        
        var currentIndex = self.startIndex
        
        while currentIndex < self.endIndex {
            let searchRange = currentIndex..<self.endIndex
            
            guard let range = self.range(of: of, options: options, range: searchRange, locale: locale) else {
                currentIndex = self.endIndex
                continue
            }
            
            ranges.append(range)
            currentIndex = range.upperBound
        }
        
        return ranges
    }
    
    internal func replacingOccurrencesExceptFirst(_ of: String, with: String) -> String {
        let ranges = self.ranges(of: of, options: NSString.CompareOptions(), range: nil, locale: nil)
        guard ranges.count > 1 else {
            return self
        }
        
        var replacement = self
        
        for (index, range) in ranges.reversed().enumerated() {
            if index < ranges.count - 1 {
                replacement.replaceSubrange(range, with: with)
            }
        }
        
        return replacement
    }
    
    internal func replacingOccurrencesExceptLast(_ of: String, with: String) -> String {
        let ranges = self.ranges(of: of, options: NSString.CompareOptions(), range: nil, locale: nil)
        guard ranges.count > 1 else {
            return self
        }
        
        var replacement = self
        
        for (index, range) in ranges.enumerated() {
            if index < ranges.count - 1 {
                replacement.replaceSubrange(range, with: with)
            }
        }
        
        return replacement
    }
}