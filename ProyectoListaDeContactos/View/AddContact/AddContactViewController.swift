//
//  AddContactViewController.swift
//  ProyectoListaDeContactos
//
//  Created by User-UAM on 10/5/24.
//

import UIKit

class AddContactViewController: UIViewController {
    
    private let controller: MainController
    // Editor de contactos.
    var contactToEdit: ContactoDatos?
    

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    
    init(controller: MainController){
        self.controller = controller
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Se cambia el titulo en dependencia de la función si es nuevo o editar contacto
        title = contactToEdit == nil ? "Nuevo contacto" : "Editar contacto"
        
        // Si estamos editando, cargamos los datos en los text fields
        if let contact = contactToEdit {
            nameTextField.text = contact.nombre
            lastNameTextField.text = contact.apellidos
            numberTextField.text = contact.numero
            companyTextField.text = contact.empresa
        }
    }

    @IBAction func onTapAddContactButton(_ sender: Any) {
        guard let nameText = nameTextField.text else {return}
        guard let lastNameText = lastNameTextField.text else {return}
        guard let numberText = numberTextField.text else {return}
        guard let companyText = companyTextField.text else {return}
        
        if let contactToEdit = contactToEdit {
            // Si estamos editando, sobrescribimos los datos del contacto existente
            contactToEdit.nombre = nameText
            contactToEdit.apellidos = lastNameText
            contactToEdit.numero = numberText
            contactToEdit.empresa = companyText
            controller.updateContact(contact: contactToEdit) // Aquí implementas el método de actualización
        } else {
            // Si es un nuevo contacto, lo creamos
            controller.saveContacts(nombre: nameText, apellidos: lastNameText, numero: numberText, empresa: companyText)
        }
        
        navigationController?.popViewController(animated: true)
    }

}
