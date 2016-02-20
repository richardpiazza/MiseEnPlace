//
//  ConvertableIngredient.swift
//  miseenplace
//
//  Created by Richard Piazza on 8/3/15.
//  Copyright (c) 2015 Richard Piazza. All rights reserved.
//

import Foundation
import MiseEnPlace

public class ConvertableIngredient : Convertable {
    public var measurementAmount: Float
    public var measurementUnit: MeasurementUnit
    public var ratio: Ratio = Ratio(volume: 1, mass: 1)
    
    init() {
        self.measurementAmount = 0
        self.measurementUnit = .AsNeeded
    }
}
