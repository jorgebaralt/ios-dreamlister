//
//  ItemDetialsVCViewController.swift
//  DreamLister
//
//  Created by Jorge Baralt on 11/24/18.
//  Copyright © 2018 Jorge Baralt. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var detailsField: UITextField!
    @IBOutlet weak var thumImg: UIImageView!
    @IBOutlet weak var itemTypePicker: UIPickerView!
    
    var stores = [Store]()
    var itemTypes = [ItemType]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        storePicker.delegate = self
        storePicker.dataSource = self
        storePicker.tag = 0
        itemTypePicker.delegate = self
        itemTypePicker.dataSource = self
        itemTypePicker.tag = 1
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    
        // Do any additional setup after loading the view.
//        let store = Store(context: context)
//        store.name = "BestBuy"
//        let store2 = Store(context: context)
//        store2.name = "Tesla Elect"
//        let store3 = Store(context: context)
//        store3.name = "Target"
//        let store4 = Store(context: context)
//        store4.name = "Walmart"
//        let store5 = Store(context: context)
//        store5.name = "Amazon"
//        let store6 = Store(context: context)
//        store6.name = "K mart"
//
//
//        let itemType = ItemType(context:context)
//        itemType.type = "Electronics"
//        let itemType2 = ItemType(context:context)
//        itemType2.type = "Cars"
//        let itemType3 = ItemType(context:context)
//        itemType3.type = "Food"
//        let itemType4 = ItemType(context:context)
//        itemType4.type = "Laptops"
//        let itemType5 = ItemType(context:context)
//        itemType5.type = "Other"
//        ad.saveContext()
//
        getStores()
        getItemTypes()
        
        if(itemToEdit != nil){
            loadItemData()
        }
    }

    //load picker view data
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if pickerView.tag == 0{
            let store = stores[row]
            return store.name
        } else {
            let itemType = itemTypes[row]
            return itemType.type
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return stores.count
        } else {
            
            return itemTypes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //update when selected
    }
    
    func getStores(){
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do{
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        }catch{
            //handle error
        }
    }
    
    func getItemTypes(){
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        do{
            self.itemTypes = try context.fetch(fetchRequest)
            self.itemTypePicker.reloadAllComponents()
        } catch {
            //handle error
        }
        
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        let item = itemToEdit ?? Item(context:context)
        
        let picture = Image(context:context)
        picture.image = thumImg.image
        item.toImage = picture
        
        if let title = titleField.text{
            item.title = title
        }
        if let price = priceField.text{
            item.price = (price as NSString).doubleValue
        }
        if let details = detailsField.text{
            item.details = details
        }
        //save pickers
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        item.toItemType = itemTypes[itemTypePicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        
        //go back screen
        navigationController?.popViewController(animated: true)
        
    }
    
    func loadItemData(){
        if let item = itemToEdit{
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            //as uiImage, because in data model is set as transformable
            thumImg.image = item.toImage?.image as? UIImage
            
            //load item type picker
            if let itemType = item.toItemType {
                var index = 0
                repeat{
                    let i = itemTypes[index]
                    if i.type == itemType.type{
                        itemTypePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                }while(index < itemTypes.count)
            }
            
            //load store picker
            if let store = item.toStore{
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name{
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                    
                } while (index < stores.count)
            }
        }
        
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    //on button click
    @IBAction func addImage(_ sender: Any) {
        present(imagePicker,animated:true, completion: nil)
    }
    
    //handle image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            thumImg.image = img
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    

}
