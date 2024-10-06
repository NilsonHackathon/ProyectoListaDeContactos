//
//  AddContactViewController.swift
//  ProyectoListaDeContactos
//
//  Created by User-UAM on 10/5/24.
//

import UIKit

class AddContactViewController: UIViewController {
    
    private let controller: MainController

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    
    init(controller: MainController, nameTextField: UITextField, lastNameTextField: UITextField, numberTextField: UITextField, companyTextField: UITextField){
        self.controller = controller
        self.nameTextField = nameTextField
        self.lastNameTextField = lastNameTextField
        self.numberTextField = numberTextField
        self.companyTextField = companyTextField
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nuevo contacto"
    }

    @IBAction func onTapAddContactButton(_ sender: Any) {
        guard let nameText = nameTextField.text else {return}
        guard let lastNameText = lastNameTextField.text else {return}
        guard let numberText = numberTextField.text else {return}
        guard let companyText = companyTextField.text else {return}
        controller.saveContacts(nombre: nameText, apellidos: lastNameText, numero: numberText, empresa: companyText)
        
        navigationController?.popViewController(animated: true)
    }

}
