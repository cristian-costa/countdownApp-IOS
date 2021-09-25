//
//  ViewController.swift
//  CountdownApp
//
//  Created by Cristian Costa on 21/09/2021.
//

import UIKit
import RealmSwift
import SwipeCellKit

class HomeViewController: SwipeTableViewController {
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let realm = try! Realm()
    var eventsArray: Results<Evento>?
    
    let calendar = Calendar.current
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        loadData()
//        tableView.separatorStyle = .none
        tableView.rowHeight = 80.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadCategory()
    }
    
    func loadData() {
        if eventsArray?.count != 0 {
            let primerEvento = eventsArray![0]
            nameLabel.text = primerEvento.name
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM, YYYY"

            dateLabel.text = dateFormatter.string(from: primerEvento.date!)

            let date1 = calendar.startOfDay(for: primerEvento.date!)
            let date2 = calendar.startOfDay(for: Date())
            let components = calendar.dateComponents([.day], from: date2, to: date1)
            
            if components.day! >= 0 {
                countdownLabel.text = String(components.day!)
            } else {
                countdownLabel.text = "0"
            }
        } else {
            nameLabel.text = "Sin eventos"
            dateLabel.text = "-"
            countdownLabel.text = "-"
        }
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToAdd", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let evento = eventsArray?[indexPath.row] {
            
            let date1 = calendar.startOfDay(for: evento.date!)
            let date2 = calendar.startOfDay(for: Date())
            let components = calendar.dateComponents([.day], from: date2, to: date1)
            var countdownString = ""
            var image: UIImage?
            
            if components.day! > 0 {
                countdownString = String(components.day!)
                image = UIImage(systemName: "arrow.down")
            } else {
                countdownString = "0"
                image = UIImage(systemName: "arrow.right")
            }
            
            cell.textLabel?.text = "\(countdownString) - \(evento.name)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM, YYYY"
            cell.detailTextLabel?.text = dateFormatter.string(from: evento.date!)
            cell.imageView?.tintColor = hexStringToUIColor(hex: "#ECB390")
            cell.imageView?.image = image
            
            loadData()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped me")
    }

    override func updateModel(at indexPath: IndexPath){
        if let evento = self.eventsArray?[indexPath.row] {
            do {
                try self.realm.write({
                    self.realm.delete(evento)
                })
            } catch {
                print("Error deleting event, \(error)")
            }
            loadData()
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
    
    //MARK: - DATA MANIPULATION METHODS
    func loadCategory() {
        //autoupdate categories, fetch all objects and reaload tableView
        eventsArray = realm.objects(Evento.self).sorted(byKeyPath: "date", ascending: true)

        //Datasource methods
        tableView.reloadData()
    }
}




