//
//  ConvertableIngredient.swift
//  miseenplace
//
//  Created by Richard Piazza on 8/3/15.
//  Copyright (c) 2015 Richard Piazza. All rights reserved.
//

import Foundation
import MiseEnPlace

open class ConvertableIngredient : Convertable {
    open var measurement = MiseEnPlace.Measurement(amount: 0.0, unit: .asNeeded)
    open var ratio: Ratio = Ratio(volume: 1, weight: 1)
    open var eachMeasurement: MiseEnPlace.Measurement?
}
