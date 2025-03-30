import Foundation

extension String {
    func ranges(of: String, options: NSString.CompareOptions, range: Range<Index>?, locale: Locale?) -> [Range<Index>] {
        var ranges: [Range<Index>] = []

        var currentIndex = startIndex

        while currentIndex < endIndex {
            let searchRange = currentIndex ..< endIndex

            guard let range = self.range(of: of, options: options, range: searchRange, locale: locale) else {
                currentIndex = endIndex
                continue
            }

            ranges.append(range)
            currentIndex = range.upperBound
        }

        return ranges
    }

    func replacingOccurrencesExceptFirst(_ of: String, with: String) -> String {
        let ranges = ranges(of: of, options: NSString.CompareOptions(), range: nil, locale: nil)
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

    func replacingOccurrencesExceptLast(_ of: String, with: String) -> String {
        let ranges = ranges(of: of, options: NSString.CompareOptions(), range: nil, locale: nil)
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
