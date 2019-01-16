//
//  ViewController.swift
//  EatHealthy
//
//  Created by Gouthami Reddy on 8/22/18.
//  Copyright © 2018 Gouthami Reddy. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate   {
    
   
    @IBOutlet weak var tableView: UITableView!
    var foodItems = [Food]()
    var moc:NSManagedObjectContext!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moc = appDelegate?.persistentContainer.viewContext
        self.tableView.dataSource = self
        loadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    func loadData() {
        let foodRequest:NSFetchRequest<Food> = Food.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "added", ascending: false)
        foodRequest.sortDescriptors = [sortDescriptor]
        
        do {
            try foodItems = moc.fetch(foodRequest)
            
        } catch {
            print("could not load data")
        }
        self.tableView.reloadData()
    }
    
    @IBAction func EatHealthy(_ sender: UIButton) {
     let foodItem = Food(context: moc)
        foodItem.added = Date()
        if sender.tag == 1 {
            foodItem.foodType  = "Fruit"
        } else {
            foodItem.foodType = "Vegetable"
            }
        appDelegate?.saveContext()
        loadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        let foodItem = foodItems[indexPath.row]
        let foodType = foodItem.foodType
        cell.textLabel?.text = foodType
        
      
       
        let foodDate = foodItem.added! as NSDate
      let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM d yyy, hh:mm"
        cell.detailTextLabel?.text = dateFormatter.string(from: foodDate as Date)

        
        if foodType == "Fruit" {
            cell.imageView?.image = UIImage(named: "apple")
            
        } else {
            cell.imageView?.image = UIImage(named: "salad")
        }
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

