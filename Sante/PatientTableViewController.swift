//
//  PatientTableViewController.swift
//  Sante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import CoreData

class PatientTableViewController: UITableViewController {

    var patients = [PatientData]()
    //regarde si il y a des changements et nous indique si on doit faire un reload
    var fetchedResultController: NSFetchedResultsController<PatientData>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let fetchRequest = NSFetchRequest<PatientData>(entityName: "PatientData")
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultController.delegate = self
        try! fetchedResultController.performFetch()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        //let truc = Patient(name: "TOTO", forename: "Titi", gender: "male")
        //let bidule = Patient(name: "TATA", forename: "Tutu", gender: "female")
        
        
        /*let johnData = PatientData(entity: PatientData.entity(), insertInto: persistentContainer.viewContext)
        johnData.forename = "John"
        johnData.name = "Doe"

        do {
            try persistentContainer.viewContext.save()
        } catch {
            print(error)
        }
        */
        
        
        //patients.append(johnData)
        
        //patients.append(truc)
        //patients.append(bidule)
        
        
        
        let buttonAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showCreateViewController))
        self.navigationItem.rightBarButtonItem = buttonAdd
        
        let buttonEdit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(showEditViewController))
        self.navigationItem.leftBarButtonItem = buttonEdit
        
        
        
        /*let fileUrl = Bundle.main.url(forResource: "names", withExtension: "plist")
        guard let url = fileUrl, let array = NSArray(contentsOfFile: url.path) else {
            return
        }
        
        for dict in array {
            if let dictionnary = dict as? [String:Any] {
                let firstName = dictionnary["name"] as? String ?? "Error"
                let lastName = dictionnary["lastname"] as? String ?? "Error"
                
                if let Gender = dictionnary["Gender"] as? String, Gender == "Male" {
                    self.patients.append(Patient(name: firstName, forename: lastName, gender: "Male"))
                }
                else {
                    self.patients.append(Patient(name: firstName, forename: lastName, gender: "Male"))
                }
            }
        }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //On récupère et on tri
        let fetchRequest = NSFetchRequest<PatientData>(entityName: "PatientData")
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            self.patients = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        //Refresh view
        self.tableView.reloadData()
    }

    //switch to create view
    func showCreateViewController() {
        
        let controller = CreatePatientViewController(nibName: "CreatePatientViewController", bundle: nil)
        
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    //switch to edit view
    func showEditViewController() {
        
        let controller = EditViewController(nibName: "EditViewController", bundle: nil)
        
        self.present(controller, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "patientCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = fetchedResultController.object(at: indexPath).getName()
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let detailController = segue.destination as? DetailViewController {
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            //Supp un Patient
            detailController.methodDelete = {
                let patient = self.fetchedResultController.object(at:selectedIndexPath)
                self.persistentContainer.viewContext.delete(patient)
                do {
                    try self.persistentContainer.viewContext.save()
                }catch {
                    print("error")
                }
                
                self.tableView.reloadData()
                
                //revenir en arrière
                self.navigationController?.popViewController(animated: true)
            }
            
           detailController.patient = fetchedResultController.object(at:selectedIndexPath)
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PatientTableViewController: CreatePatientDelegate{
    func createPatient(patient: PatientData) {

        //On sauvegarde
        do {
            try self.persistentContainer.viewContext.save()
        }catch {
            print("error")
        }

    }
}

extension PatientTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
}
