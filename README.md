# MiseEnPlace
[![Version](https://img.shields.io/cocoapods/v/MiseEnPlace.svg?style=flat)](http://cocoadocs.org/docsets/MiseEnPlace)
[![Platform](https://img.shields.io/cocoapods/p/MiseEnPlace.svg?style=flat)](http://cocoadocs.org/docsets/MiseEnPlace)

A Framework for converting and interpreting common measurements used in cooking.

#### MeasurementUnit.swift

The `MeasurementUnit` enum is the heart of the MiseEnPlace framework. This enum represents some unit of measure, along with `MeasurementSystem` and `MeasurementMethod` that it belongs to.

All of the logic for how and when to convert to other units and amounts is contained within the enum.

#### MeasurementMethod.swift

The `MeasurementMethod` represents the ways in which something can be measured. In the case of the MiseEnPlace framework, this means `Volume` and `Mass`.

#### MeasurementSystem.swift

Similar to the `MeasurementMethod` the `MeasurementSystem` enum represents the types of unit systems that can be used. Currently only `US` and `Metric` are supported.

#### MeasurementSystemMethod.swift

The `MeasurementSystemMethod` represents the ways `MeasurementMethod`s and `MeasurementSystem`s can be combined.

#### Convertable.swift

The `Convertable` protocol defines the properties needed to be able to perform conversion and interpretation.

#### Converter.swift

The `Converter` class provides functions needed for the conversion of amounts from one system of measurement to another system of measurement.

This class is primarily used for the functions

    scale()
    convert()

#### Interpreter.swift

The `Interpreter` class produces human-readable output from `ScaleMeasure`.
