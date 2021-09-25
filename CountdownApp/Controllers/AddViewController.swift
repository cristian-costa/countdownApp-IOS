//
//  AddViewController.swift
//  CountdownApp
//
//  Created by Cristian Costa on 21/09/2021.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let realm = try! Realm()
    var eventsArray: Results<Evento>?
    var date: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textField.frame.height - 1, width: textField.frame.width, height: 1.0)
        bottomLine.backgroundColor = hexStringToUIColor(hex: "#ECB390").cgColor
        textField.borderStyle = UITextField.BorderStyle.none
        textField.layer.addSublayer(bottomLine)
        textField.becomeFirstResponder()
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        let evento = Evento()
        if textField.text! != "" {
            evento.name = textField.text!
            evento.date = date
            save(evento: evento)
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        date = sender.date
    }
    
    //MARK: - DATA MANIPULATION METHODS
    func save(evento: Evento) {
        do {
            try realm.write({
                realm.add(evento)
            })
        } catch {
            print("Error saving context, \(error)")
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
