//
//  CarsTableViewController.swift
//  CarsCatalog
//
//  Created by Михаил Жданов on 18.09.2020.
//

import UIKit

class CarsTableViewController: UITableViewController {
    
    private let cellReuseId = "CarCell"
    private let editCarAlertController = EditCarAlertController()
    
    private lazy var deleteBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(deleteButtonAction)
        )
    }()
    
    private lazy var doneBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(deleteButtonAction)
        )
    }()

    @IBAction func addCarButtonAction(_ sender: Any) {
        editCarAlertController.show(over: self, saveActionCompletion: {
            self.tableView.reloadSections([0], with: .fade)
            self.updateEmptyViewAndDeleteButtonVisibility(animated: true)
        }, alertDisappearCompletion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        setupTableViewBackgroundView()
        updateEmptyViewAndDeleteButtonVisibility(animated: false)
    }
    
    private func setupTableViewBackgroundView() {
        let view = UIView()
        view.alpha = 0
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.alpha = 0.5
        label.text = "Нет автомобилей"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        tableView.backgroundView = view
    }
    
    @objc
    private func deleteButtonAction() {
        let isEditing = !tableView.isEditing
        navigationItem.leftBarButtonItem = isEditing ? doneBarButtonItem : deleteBarButtonItem
        tableView.setEditing(isEditing, animated: true)
    }
    
    private func updateEmptyViewAndDeleteButtonVisibility(animated: Bool) {
        let duration = animated ? 0.5 : 0
        UIView.animate(withDuration: duration) {
            self.tableView.backgroundView?.alpha = CarsManager.shared.cars.isEmpty ? 1 : 0
        }
        if CarsManager.shared.cars.isEmpty {
            navigationItem.leftBarButtonItem = nil
            DispatchQueue.main.async {
                self.tableView.isEditing = false
            }
        } else {
            navigationItem.leftBarButtonItem = tableView.isEditing ? doneBarButtonItem : deleteBarButtonItem
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CarsManager.shared.cars.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
        let car = CarsManager.shared.cars[indexPath.row]
        cell.textLabel?.text = car.manufacturer + " " + car.model
        cell.detailTextLabel?.text = "\(car.bodyType.stringValue), \(car.yearOfIssue) год выпуска"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editCarAlertController.show(over: self, editingCarIndex: indexPath.row, saveActionCompletion: {
            tableView.reloadSections([0], with: .fade)
        }, alertDisappearCompletion: {
            tableView.deselectRow(at: indexPath, animated: true)
        })
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        CarsManager.shared.deleteCar(atIndex: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        updateEmptyViewAndDeleteButtonVisibility(animated: true)
    }
    
}
