//
//  ViewController.swift
//  ContactRealm
//
//  Created by Mike on 10/5/20.
//

import UIKit
import RealmSwift

class ContactItem: Object {
    @objc dynamic var name = ""
    @objc dynamic var keyNumber = ""
    
    convenience init(name: String, keyNumber: String) {
        self.init()
        self.name = name
        self.keyNumber = keyNumber
    }
}

let numbers = (1...5).compactMap(UnicodeScalar.init)

let alphabet = (UnicodeScalar("A").value...UnicodeScalar("Z").value).compactMap(UnicodeScalar.init)

class ViewController: UIViewController {
    //     let items = try! Realm().objects(ContactItem.self).sorted(byProperty: "name")
    let items = try! Realm().objects(ContactItem.self).sorted(byKeyPath: "name", ascending: true)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        let realm = try! Realm()
        let path = realm.configuration.fileURL?.path
        print("Path: \(path)")
        if realm.isEmpty {
            try! realm.write {
                realm.add(ContactItem(name: "Kelly", keyNumber: "0"))
                realm.add(ContactItem(name: "Ryan", keyNumber: "1"))
                realm.add(ContactItem(name: "Eryn", keyNumber:"2"))
                realm.add(ContactItem(name: "Cooper", keyNumber: "3"))
                realm.add(ContactItem(name: "Lucy", keyNumber:"4"))
                realm.add(ContactItem(name: "Kate", keyNumber: "5"))
                realm.add(ContactItem(name: "Art", keyNumber: "6"))
                realm.add(ContactItem(name: "Juno", keyNumber: "7"))
            }
        }
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    
    
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func items(forSection section: Int) -> Results<ContactItem> {
        return items.filter("name BEGINSWITH %@", alphabet[section].description)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return alphabet.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return alphabet[section].description
    }
    func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return items(forSection: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let contactinfo = items(forSection: indexPath.section)[indexPath.row]
        cell.textLabel?.text = contactinfo.name
        cell.detailTextLabel?.text = contactinfo.keyNumber
        return cell
    }
    
    
}

