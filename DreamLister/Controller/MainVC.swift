//
//  MainVC.swift
//  DreamLister
//
//  Created by Jorge Baralt on 11/23/18.
//  Copyright © 2018 Jorge Baralt. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var controller: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //modify top back button on navigation controller
        if let topItem = self.navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        }
        
//        generateTestData()
        attemptFetch()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: ItemCell, indexPath: IndexPath){
        //get the specific item from core data
        let item = controller.object(at: indexPath)
        //pass it to configure cell in the item cell
        cell.configureCell(item: item)
    }
    
    // when click on a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //check there are objects on the database > 0
        if let objs = controller.fetchedObjects , objs.count > 0{
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    //get ready to send item
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC"{
            if let destination = segue.destination as? ItemDetailsVC{
                if let item = sender as? Item{
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //get how many rows from controller
        if let sections = controller.sections{
            let sectionsInfo = sections[section]
            return sectionsInfo.numberOfObjects
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //get count of
        if let sections = controller.sections{
            return sections.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //fixed value
        return 150
    }
    
    //attemptingfetch request
    func attemptFetch(){
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        //for sorting
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        let priceSort = NSSortDescriptor(key:"price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        let itemTypeSort = NSSortDescriptor(key: "toItemType", ascending: false)
        //decide what to sort
        if segment.selectedSegmentIndex == 0 {
            fetchRequest.sortDescriptors = [dateSort]
        } else if segment.selectedSegmentIndex == 1 {
            fetchRequest.sortDescriptors = [priceSort]
        } else if segment.selectedSegmentIndex == 2 {
            fetchRequest.sortDescriptors = [titleSort]
        } else if segment.selectedSegmentIndex == 3 {
            fetchRequest.sortDescriptors = [itemTypeSort]
        }
        //create controller
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.controller = controller
        
        // now controller has control over what happens when we change data
        self.controller.delegate = self
        
        do{
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    //Listen to changes on segment
    @IBAction func segmentChange(_ sender: Any) {
        attemptFetch()
        tableView.reloadData()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //this will be good on extension, so we dont write it on every view controller
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type){
        case.insert:
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade )
            }
            break
        case .move:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade )
            }
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath{
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                //Update the cell data
                configureCell(cell: cell, indexPath: indexPath)
            }
            break
        }
    }
}

func generateTestData(){
    let item = Item(context: context)
    item.title = "Macbook pro"
    item.price = 2000
    item.details = "the new laptop is coming up. get ready, and buy it once it come available"
    
    let item2 = Item(context: context)
    item2.title = "Headpro"
    item2.price = 300
    item2.details = "theasdasdasdas da sdasd asd , and buyasd asd asd asd available"
    
    let item3 = Item(context: context)
    item3.title = "Something else"
    item3.price = 100
    item3.details = "tasd asd asd as asd asd ad a d"
    
    //save into device (database)
    ad.saveContext()
    
}
