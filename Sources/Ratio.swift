//===----------------------------------------------------------------------===//
//
// Ratio.swift
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

/// ## Ratio
/// Holds the relation between volume and weight
public struct Ratio {
    public var volume: Double = 1.0
    public var weight: Double = 1.0
    
    public init() {
        
    }
    
    public init(volume: Double, weight: Double) {
        self.volume = volume
        self.weight = weight
    }
    
    public static func makeRatio(volumeConvertable: Convertable, weightConvertable: Convertable) -> Ratio {
        let volume = volumeConvertable.amount(for: .fluidOunce)
        let weight = weightConvertable.amount(for: .ounce)
        
        guard volume != 0.0 && weight != 0.0 else {
            return Ratio(volume: volume, weight: weight)
        }
        
        var ratioVolume = volume
        var ratioWeight = weight
        
        if volume >= weight {
            ratioVolume = ratioVolume / ratioWeight
            ratioWeight = ratioWeight / ratioWeight
        } else {
            ratioWeight = ratioWeight / ratioVolume
            ratioVolume = ratioVolume / ratioVolume
        }
        
        return Ratio(volume: ratioVolume, weight: ratioWeight)
    }
}
