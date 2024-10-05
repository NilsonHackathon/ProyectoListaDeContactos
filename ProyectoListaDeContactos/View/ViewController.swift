//
//  ViewController.swift
//  ProyectoListaDeContactos
//
//  Created by User-UAM on 10/4/24.
//

import UIKit

enum Section{
    case main
}

class ViewController: UIViewController {
    
    typealias DataSource = UITableViewDiffableDataSource<Section, ContactoDatos>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ContactoDatos>

    @IBOutlet weak var tableView: UITableView!
    
    private lazy var dataSource: DataSource = {
        let datasource = DataSource(tableView: tableView) { tableView, IndexPath, itemIdentifier in let cell = tableView.dequeueReusableCell(withIdentifier: "ContactoTableViewCell", for: IndexPath) as? ContactoTableViewCell
            
            cell?.nameLabel.text = itemIdentifier.nombre
            cell?.lastnameLabel.text = itemIdentifier.apellidos
            
            return cell
        }
        
        return datasource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Lista de contactos"
        
        buttonConfiguration()
        
        cellRegistation()
    }
    
    private func cellRegistation(){
        tableView.register(UINib(nibName: "ContactoTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactoTableViewCell")
    }

    private func buttonConfiguration() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill.badge.plus"), style: .plain, target: self, action: #selector(addNote))
    }
    
    @objc func addNote(){
        
    }
    
}

