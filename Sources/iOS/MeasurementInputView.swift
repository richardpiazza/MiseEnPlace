import UIKit

public protocol MeasurementInputViewDelegate {
    func measurementInputView(_ measurementInputView: MeasurementInputView, didSet measurement: CookingMeasurement)
    func endEditingForMeasurementInputView(_ measurementInputView: MeasurementInputView)
}

public class MeasurementInputView: UIView, UIInputViewAudioFeedback, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private static var ThreeDecimalNumberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 3
        formatter.maximumSignificantDigits = 3
        return formatter
    }
    
    @IBOutlet weak var entryType: UISegmentedControl?
    @IBOutlet weak var numberPicker: UIPickerView?
    @IBOutlet weak var unitPicker: UIPickerView?
    @IBOutlet weak var padContainer: UIView?
    @IBOutlet weak var zero: UIButton?
    @IBOutlet weak var one: UIButton?
    @IBOutlet weak var two: UIButton?
    @IBOutlet weak var three: UIButton?
    @IBOutlet weak var four: UIButton?
    @IBOutlet weak var five: UIButton?
    @IBOutlet weak var six: UIButton?
    @IBOutlet weak var seven: UIButton?
    @IBOutlet weak var eight: UIButton?
    @IBOutlet weak var nine: UIButton?
    @IBOutlet weak var decimal: UIButton?
    @IBOutlet weak var delete: UIButton?
    @IBOutlet weak var done: UIButton?
    @IBOutlet weak var output: UILabel?
    
    public var enableInputClicksWhenVisible: Bool = true
    public var delegate: MeasurementInputViewDelegate?
    public var units: [MeasurementUnit] = MeasurementUnit.allMeasurementUnits {
        didSet {
            unit = units[0]
        }
    }
    
    private let integrals = Integral.allIntegrals
    private let fractions = Fraction.zeroBasedCommonFractions
    
    private var textualValue: String = "" {
        didSet {
            output?.text = textualValue
        }
    }
    
    private var integral: Integral = .zero {
        didSet {
            value = Double(integral.rawValue) + fraction.rawValue
        }
    }
    
    private var fraction: Fraction = .zero {
        didSet {
            value = Double(integral.rawValue) + fraction.rawValue
        }
    }
    
    private var unit: MeasurementUnit = .asNeeded {
        didSet {
            if let delegate = self.delegate {
                delegate.measurementInputView(self, didSet: CookingMeasurement(amount: value, unit: unit))
            }
        }
    }
    private var value: Double = 0.0 {
        didSet {
            if let delegate = self.delegate {
                delegate.measurementInputView(self, didSet: CookingMeasurement(amount: value, unit: unit))
            }
        }
    }
    
    public static func makeInstance() -> MeasurementInputView? {
        let bundle = Bundle(for: self)
        guard let view = bundle.loadNibNamed(String(describing: self), owner: nil, options: nil)?.first as? MeasurementInputView else {
            return nil
        }
        
        view.frame = CGRect(x: 0, y: 0, width: 320, height: 214)
        view.tintColor = UIApplication.shared.delegate?.window??.tintColor
        
        return view
    }
    
    public static func makeInstance(measurementMethod: MeasurementMethod) -> MeasurementInputView? {
        guard let instance = makeInstance() else {
            return nil
        }
        
        instance.units = MeasurementUnit.measurementUnits(forMeasurementMethod: measurementMethod)
        return instance
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        done?.layer.cornerRadius = 4.0
        done?.layer.shadowRadius = 0.0
        done?.layer.shadowColor = UIColor(red: 138/255.0, green: 139/255.0, blue: 143/255.0, alpha: 1.0).cgColor
        done?.layer.shadowOffset = CGSize(width: 0, height: 1)
        done?.layer.shadowOpacity = 1.0
        done?.layer.masksToBounds = true
        done?.clipsToBounds = true
        
        output?.layer.cornerRadius = 4.0
        output?.layer.shadowRadius = 0.0
        output?.layer.shadowColor = UIColor(red: 138/255.0, green: 139/255.0, blue: 143/255.0, alpha: 1.0).cgColor
        output?.layer.shadowOffset = CGSize(width: 0, height: 1)
        output?.layer.shadowOpacity = 1.0
        output?.layer.masksToBounds = true
        output?.clipsToBounds = true
    }
    
    public func setMeasurement(_ measurement: CookingMeasurement, delegate: MeasurementInputViewDelegate) {
        value = measurement.amount
        unit = measurement.unit
        
        if modf(value).1 == 0 {
            textualValue = "\(Int(value))"
        } else {
            if let number = type(of: self).ThreeDecimalNumberFormatter.string(from: NSNumber(value: value)) {
                textualValue = number
            } else {
                textualValue = "\(value)"
            }
        }
        
        let decomposedAmount = modf(measurement.amount)
        let i = Int(decomposedAmount.0)
        let f = decomposedAmount.1
        
        if let intergralI = Integral(rawValue: i), let fractionF = Fraction(commonValue: f) {
            integral = intergralI
            if let row = integrals.index(of: integral) {
                numberPicker?.selectRow(row, inComponent: 0, animated: true)
            }
            
            fraction = fractionF
            if let row = fractions.index(of: fraction) {
                numberPicker?.selectRow(row, inComponent: 1, animated: true)
            }
        } else {
            entryType?.selectedSegmentIndex = 1
            numberPicker?.isHidden = true
            padContainer?.isHidden = false
        }
        
        if let row = units.index(of: unit) {
            unitPicker?.selectRow(row, inComponent: 0, animated: true)
        }
        
        self.delegate = delegate
    }
    
    // MARK: - UIPickerViewDataSource
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == numberPicker {
            return 2
        } else if pickerView == unitPicker {
            return 1
        }
        
        return 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == numberPicker {
            if component == 0 {
                return integrals.count
            } else if component == 1 {
                return fractions.count
            }
        } else if pickerView == unitPicker {
            return units.count
        }
        
        return 0
    }
    
    // MARK: - UIPickerViewDelegate
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == numberPicker {
            if component == 0 {
                return integrals[row].stringValue
            } else if component == 1 {
                return fractions[row].stringValue
            }
        } else if pickerView == unitPicker {
            return units[row].name
        }
        
        return nil
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var title: String?
        
        if pickerView == numberPicker {
            if component == 0 {
                title = integrals[row].stringValue
            } else if component == 1 {
                title = fractions[row].stringValue
            }
        } else if pickerView == unitPicker {
            title = units[row].name
        }
        
        guard let attributedTitle = title else {
            return nil
        }
        
        if let color = UIApplication.shared.delegate?.window??.tintColor {
            return NSAttributedString(string: attributedTitle, attributes: [NSForegroundColorAttributeName:color])
        }
        
        return NSAttributedString(string: attributedTitle, attributes: [NSForegroundColorAttributeName:UIColor.white])
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == numberPicker {
            if component == 0 {
                integral = integrals[row]
            } else if component == 1 {
                fraction = fractions[row]
            }
            
            if modf(value).1 == 0 {
                textualValue = "\(Int(value))"
            } else {
                if let number = type(of: self).ThreeDecimalNumberFormatter.string(from: NSNumber(value: value)) {
                    textualValue = number
                } else {
                    textualValue = "\(value)"
                }
            }
        } else if pickerView == unitPicker {
            unit = units[row]
        }
    }
    
    // MARK: - IBActions
    @IBAction public func didChangeEntryType(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            numberPicker?.isHidden = false
            padContainer?.isHidden = true
        } else {
            numberPicker?.isHidden = true
            padContainer?.isHidden = false
        }
    }
    
    @IBAction public func didTapNumberPad(_ sender: UIButton) {
        if sender == decimal {
            if let _ = textualValue.range(of: ".") {
                return
            }
            
            textualValue = textualValue.appending(".")
        } else if sender == delete {
            guard textualValue.characters.count > 0 else {
                return
            }
            
            let range = textualValue.startIndex..<textualValue.index(textualValue.endIndex, offsetBy: -1)
            textualValue = textualValue.substring(with: range)
        } else {
            guard let title = sender.title(for: .normal) else {
                return
            }
            
            textualValue = textualValue.appending(title)
        }
        
        UIDevice.current.playInputClick()
        
        guard let newValue = Double(textualValue) else {
            value = 0.0
            return
        }
        
        value = newValue
    }
    
    @IBAction public func didTapDone(_ sender: UIButton) {
        UIDevice.current.playInputClick()
        
        if let delegate = self.delegate {
            delegate.endEditingForMeasurementInputView(self)
        }
        
        delegate = nil
    }
}
