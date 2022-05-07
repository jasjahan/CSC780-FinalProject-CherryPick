//
//  Model.swift
//  CherryPick
//
//  Created by Jasmine Jahan on 5/6/22.
//

import UIKit
import CoreData



func pickAllFruit(){
    createFruit(name: "Strawberry", imageName: "strawberry")
    createFruit(name: "Grapes", imageName: "grapes")
    createFruit(name: "Orange", imageName: "orange")
    createFruit(name: "Apple", imageName: "apple")
    createFruit(name: "Cherry", imageName: "cherry")
    createFruit(name: "Bananas", imageName: "bananas")
}


func createFruit(name: String, imageName: String){
    
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{

      let fruit = Fruit(context: context)
        fruit.imageName = imageName
        fruit.name = name
        try? context.save()
    }
}


func getAllFruits()-> [Fruit]{
    
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
        if let fruitData = try? context.fetch(Fruit.fetchRequest()) as? [Fruit]{
            if let fruits = try? fruitData {
                if fruits.count == 0{
                    pickAllFruit()
                    return getAllFruits()
                }else{
                    return fruits
                }
            }
        }
    }
    return []
}

func getFruit(picked:Bool) -> [Fruit]{
    
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
        let fetchRequest = Fruit.fetchRequest() as NSFetchRequest<Fruit>
        
        if picked {
            fetchRequest.predicate = NSPredicate(format: "picked == true")
        } else{
            fetchRequest.predicate = NSPredicate(format: "picked == false")
        }
       
        if let fruits = try? context.fetch(fetchRequest){
                    return fruits
        }
    }
    return []
}
