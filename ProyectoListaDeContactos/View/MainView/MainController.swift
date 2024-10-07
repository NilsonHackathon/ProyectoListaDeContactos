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
        /*print("Guardando apellidos: \(apellidos)") // Depuración*/
        
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
    
    func updateContact(contact: ContactoDatos) {
        do {
            // Actualizamos los datos del contacto ya existente
            if let existingContact = try coreDataStack.context.existingObject(with: contact.objectID) as? ContactoDatos {
                /*print("Actualizando apellidos: \(contact.apellidos)") // Depuración*/
                existingContact.nombre = contact.nombre
                existingContact.apellidos = contact.apellidos
                existingContact.numero = contact.numero
                existingContact.empresa = contact.empresa
                
                // Guardamos los cambios en Core Data
                coreDataStack.save()
            }
        } catch {
            print("Error actualizando el contacto: \(error.localizedDescription)")
        }
    }

}
