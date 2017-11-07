import Foundation

internal extension String {
    internal func ranges(of: String, options: String.CompareOptions, range: Range<Index>?, locale: Locale?) -> [Range<Index>] {
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
        let ranges = self.ranges(of: of, options: String.CompareOptions(), range: nil, locale: nil)
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
        let ranges = self.ranges(of: of, options: String.CompareOptions(), range: nil, locale: nil)
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
