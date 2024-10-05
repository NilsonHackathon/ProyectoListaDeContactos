//
//  MainController.swift
//  ProyectoListaDeContactos
//
//  Created by User-UAM on 10/5/24.
//

import Foundation

final class MainController {
    private let coreDataStack = CoreDataStack(modelName: "ProyectoListaDeContactos")
    
    func getContacts() -> [ContactoDatos] {
        let fetchRequest = ContactoDatos.fetchRequest()
        
        do{
            let contact = try coreDataStack.context.fetch(fetchRequest)
            return contact
        }catch{
            print("Fatch error: \(error.localizedDescription)")
        }
        
        return []
    }
    
    func saveContacts(nombre: String, apellidos: String, numero: String){
        let newContacto = ContactoDatos(context: coreDataStack.context)
        
        newContacto.id = UUID().uuidString
        newContacto.nombre = nombre
        newContacto.apellidos = apellidos
        newContacto.numero = numero
        
        coreDataStack.save()
    }
}
