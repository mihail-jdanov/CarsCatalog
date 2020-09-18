//
//  EditCarAlertController.swift
//  CarsCatalog
//
//  Created by Михаил Жданов on 19.09.2020.
//

import UIKit

class EditCarAlertController: NSObject {
    
    private let yearOfIssuePickerView = UIPickerView()
    private let bodyTypePickerView = UIPickerView()
    
    private var manufacturerTextField: UITextField?
    private var modelTextField: UITextField?
    private var yearOfIssueTextField: UITextField?
    private var bodyTypeTextField: UITextField?
    private var saveAlertAction: UIAlertAction?
    
    override init() {
        super.init()
        setupPickerViews()
    }
    
    private func setupPickerViews() {
        yearOfIssuePickerView.delegate = self
        yearOfIssuePickerView.dataSource = self
        bodyTypePickerView.delegate = self
        bodyTypePickerView.dataSource = self
    }
    
    private func getPickerViewTitle(_ pickerView: UIPickerView, forRow row: Int) -> String? {
        switch pickerView {
        case yearOfIssuePickerView:
            return String(CarsManager.yearOfIssueValues[row])
        case bodyTypePickerView:
            return CarsManager.bodyTypeValues[row].stringValue
        default:
            return nil
        }
    }
    
    @objc
    private func validateTextFields() {
        var isValidationPassed = true
        let textFields = [manufacturerTextField, modelTextField, yearOfIssueTextField, bodyTypeTextField]
        for textField in textFields where textField?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            isValidationPassed = false
        }
        saveAlertAction?.isEnabled = isValidationPassed
    }
    
    func show(isNewCar: Bool, over viewController: UIViewController) {
        let alertTitle = isNewCar ? "Добавить автомобиль" : "Редактировать автомобиль"
        let alertController = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            self.manufacturerTextField = textField
            textField.placeholder = "Производитель"
            textField.addTarget(self, action: #selector(self.validateTextFields), for: .editingChanged)
        }
        alertController.addTextField { (textField) in
            self.modelTextField = textField
            textField.placeholder = "Модель"
            textField.addTarget(self, action: #selector(self.validateTextFields), for: .editingChanged)
        }
        alertController.addTextField { (textField) in
            self.yearOfIssueTextField = textField
            textField.placeholder = "Год выпуска"
            textField.inputView = self.yearOfIssuePickerView
            textField.delegate = self
            textField.addTarget(self, action: #selector(self.validateTextFields), for: .editingChanged)
        }
        alertController.addTextField { (textField) in
            self.bodyTypeTextField = textField
            textField.placeholder = "Тип кузова"
            textField.inputView = self.bodyTypePickerView
            textField.delegate = self
            textField.addTarget(self, action: #selector(self.validateTextFields), for: .editingChanged)
        }
        let saveActionTitle = isNewCar ? "Добавить" : "Сохранить"
        let saveAction = UIAlertAction(title: saveActionTitle, style: .default) { (action) in
            if isNewCar {
                
            } else {
                
            }
        }
        saveAlertAction = saveAction
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        alertController.preferredAction = saveAction
        viewController.present(alertController, animated: true, completion: nil)
        validateTextFields()
    }
    
}

extension EditCarAlertController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return getPickerViewTitle(pickerView, forRow: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let title = getPickerViewTitle(pickerView, forRow: row)
        switch pickerView {
        case yearOfIssuePickerView:
            yearOfIssueTextField?.text = title
        case bodyTypePickerView:
            bodyTypeTextField?.text = title
        default:
            break
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case yearOfIssuePickerView:
            return CarsManager.yearOfIssueValues.count
        case bodyTypePickerView:
            return CarsManager.bodyTypeValues.count
        default:
            return 0
        }
    }
    
}

extension EditCarAlertController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case yearOfIssueTextField, bodyTypeTextField:
            return false
        default:
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case yearOfIssueTextField:
            let row = yearOfIssuePickerView.selectedRow(inComponent: 0)
            textField.text = getPickerViewTitle(yearOfIssuePickerView, forRow: row)
        case bodyTypeTextField:
            let row = bodyTypePickerView.selectedRow(inComponent: 0)
            textField.text = getPickerViewTitle(bodyTypePickerView, forRow: row)
        default:
            break
        }
        validateTextFields()
    }
    
}
