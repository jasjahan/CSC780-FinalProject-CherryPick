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
    createFruit(name: "Avocado", imageName: "avocado")
    createFruit(name: "Carrot", imageName: "carrot")
    createFruit(name: "Pear", imageName: "pear")
    createFruit(name: "Watermelon", imageName: "watermelon")
    createFruit(name: "Pineapple", imageName: "pineapple")
    createFruit(name: "Cucumber", imageName: "cucumber")
    createFruit(name: "Coconut", imageName: "coconut")
    createFruit(name: "Berry", imageName: "berry")
    createFruit(name: "Papaya", imageName: "papaya")
    createFruit(name: "Pomegranate", imageName: "pomegranate")
    createFruit(name: "Dragon", imageName: "dragon-fruit")
    
}

// creating fruits using the coredata info

func createFruit(name: String, imageName: String){
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
        let fruit = Fruit(context: context)
        fruit.imageName = imageName
        fruit.name = name
        try? context.save()
    }
}


//fetch request to get coredata info about fruits
func getAllFruits() -> [Fruit]{
    
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
        //get all the objects from the coredata which are Fruit type using fetchrequest
        if let fruitData = try? context.fetch(Fruit.fetchRequest()) as? [Fruit]{
            if fruitData.count == 0{
                pickAllFruit()
                return getAllFruits()
            }else{
                return fruitData
            }
//            if let fruits = try? fruitData {
//                if fruits.count == 0{
//                    pickAllFruit()
//                    return getAllFruits()
//                }else{
//                    return fruits
//                }
//            }
        }
    }
    return []
}


func getFruit(picked:Bool) -> [Fruit]{
    
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
        
        // custom fetchRequest to differentiate picked and unpicked fruits using NSFetchRequest
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
