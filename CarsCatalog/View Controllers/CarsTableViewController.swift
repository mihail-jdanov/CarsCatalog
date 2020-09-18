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

    @IBAction func addCarButtonAction(_ sender: Any) {
        editCarAlertController.show(isNewCar: true, over: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CarsManager.cars.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
        let car = CarsManager.cars[indexPath.row]
        cell.textLabel?.text = car.manufacturer + " " + car.model
        return cell
    }

}
