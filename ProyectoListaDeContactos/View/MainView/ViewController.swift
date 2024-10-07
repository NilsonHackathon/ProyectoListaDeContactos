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

class ViewController: UIViewController, AddContactDelegate, UISearchResultsUpdating {
    
    typealias DataSource = UITableViewDiffableDataSource<Section, ContactoDatos>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ContactoDatos>

    @IBOutlet weak var tableView: UITableView!
    
    private var contacts = [ContactoDatos]()
    
    private var filteredContacts = [ContactoDatos]()
    
    let controller = MainController()
    
    private var searchController: UISearchController!
    
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
        
        configureSearchController()
    }
    
    // Método para configurar el SearchController
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar contactos"
        
        // Agregar la barra de búsqueda en la barra de navegación
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func getData () {
        contacts =  controller.getContacts()
        applySnapshot()
    }
    
    func didUpdateContactList() {
        getData()  // Vuelve a cargar los datos de la tabla
        applySnapshot()
        tableView.reloadData() //Forzar que actualice las tablas, más para al momento de edit
    }
    
    private func cellRegistation(){
        tableView.register(UINib(nibName: "ContactoTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactoTableViewCell")
    }

    private func buttonConfiguration() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill.badge.plus"), style: .plain, target: self, action: #selector(addContact))
    }
    
    private func applySnapshot() {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.main])
        //snapshot.appendItems(contacts)
        
        // Verificamos si el searchController está activo y si la búsqueda tiene texto
        let currentContacts = (searchController?.isActive == true && !filteredContacts.isEmpty) ? filteredContacts : contacts
        
        // Si hay texto en la búsqueda pero no se encontraron contactos, muestra solo los filtrados.
        /*if searchController?.isActive == true && !filteredContacts.isEmpty {
            snapshot.appendItems(filteredContacts)
        } else {
            snapshot.appendItems(contacts)
        }*/
        
        snapshot.appendItems(currentContacts)
        
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    @objc func addContact(){
       /* controller.saveContacts(nombre: "Nilson", apellidos: "Saballos Arana", numero: "88051397", empresa: "UAM")
        getData()*/
        
        let addContactVC = AddContactViewController(controller: controller)
        addContactVC.delegate = self
        navigationController?.pushViewController(addContactVC, animated: true)
    }
    
    // Método del UISearchResultsUpdating para actualizar los resultados de búsqueda
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            filteredContacts = contacts
            applySnapshot()
            return
        }
        
        // Filtramos los contactos por nombre o apellido
        filteredContacts = contacts.filter { contacto in
            let nombre = contacto.nombre?.lowercased() ?? ""
            let apellidos = contacto.apellidos?.lowercased() ?? ""
            
            return nombre.contains(query.lowercased()) || apellidos.contains(query.lowercased())
        }
        
        // Aplicamos el snapshot con los contactos filtrados
        applySnapshot()
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
