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
    
    func saveContacts(nombre: String, apellidos: String, numero: String, empresa: String){
        let newContacto = ContactoDatos(context: coreDataStack.context)
        
        newContacto.id = UUID().uuidString
        newContacto.nombre = nombre
        newContacto.apellidos = apellidos
        newContacto.numero = numero
        newContacto.empresa = empresa
        
        coreDataStack.save()
    }
    
    func removeContact(nombre: ContactoDatos, apellido: ContactoDatos, numero: ContactoDatos, empresa: ContactoDatos){
        coreDataStack.context.delete(nombre)
        coreDataStack.context.delete(apellido)
        coreDataStack.context.delete(numero)
        coreDataStack.context.delete(empresa)
        coreDataStack.save()
    }
}
