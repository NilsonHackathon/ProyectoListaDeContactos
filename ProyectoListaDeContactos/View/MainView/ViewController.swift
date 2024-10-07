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

class ViewController: UIViewController, AddContactDelegate {
    
    typealias DataSource = UITableViewDiffableDataSource<Section, ContactoDatos>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ContactoDatos>

    @IBOutlet weak var tableView: UITableView!
    
    private var contacts = [ContactoDatos]()
    
    let controller = MainController()
    
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
        
        tableView.delegate = self
        
        buttonConfiguration()
        
        cellRegistation()
        
        getData()
    }
    
    func getData () {
        contacts =  controller.getContacts()
        applySnapchot()
    }
    
    func didUpdateContactList() {
        getData()  // Vuelve a cargar los datos de la tabla
    }
    
    private func cellRegistation(){
        tableView.register(UINib(nibName: "ContactoTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactoTableViewCell")
    }

    private func buttonConfiguration() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill.badge.plus"), style: .plain, target: self, action: #selector(addContact))
    }
    
    private func applySnapchot() {
        var snapchot = Snapshot()
        
        snapchot.appendSections([.main])
        snapchot.appendItems(contacts)
        
        
        dataSource.apply(snapchot, animatingDifferences: false)
    }

    @objc func addContact(){
       /* controller.saveContacts(nombre: "Nilson", apellidos: "Saballos Arana", numero: "88051397", empresa: "UAM")
        getData()*/
        
        let addContactVC = AddContactViewController(controller: controller)
        addContactVC.delegate = self
        navigationController?.pushViewController(addContactVC, animated: true)
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deletedActions = UIContextualAction(style: .destructive, title: "Delete") {action, view, completion in
            if let selectedModel = self.dataSource.itemIdentifier(for: indexPath){
                self.controller.removeContact(nombre: selectedModel, apellido: selectedModel, numero: selectedModel, empresa: selectedModel)
                completion(true)
                self.getData()
            }
        }
        
        let editActions = UIContextualAction(style: .normal, title: "edit") {action, view, completion in
            if let selectedModel = self.dataSource.itemIdentifier(for: indexPath){
            // Aquí navegamos al controlador de edición, pasando el contacto existente
                let addContactVC = AddContactViewController(controller: self.controller)
                addContactVC.contactToEdit = selectedModel // Pasamos el contacto a editar
                self.navigationController?.pushViewController(addContactVC, animated: true)
                completion(true)
                addContactVC.delegate = self
            }
        }
        
        editActions.backgroundColor = .green
        
        let swipeAction = UISwipeActionsConfiguration(actions: [deletedActions, editActions])

        return swipeAction
    }
}
