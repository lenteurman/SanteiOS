//
//  CreatePatientViewController.swift
//  Sante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//
// https://pastebin.com/8tzqs6XR

import UIKit

class CreatePatientViewController: UIViewController {

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var switchbutton: UISwitch!
    @IBOutlet weak var female: UILabel!
    @IBOutlet weak var male: UILabel!
    @IBOutlet weak var form: UILabel!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var Save: UIButton!
    
    weak var delegate: CreatePatientDelegate?
    let apiPersonUrl = "http://10.1.0.100:3000/persons"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        progressBar.progress = 0
    }

    @IBAction func saveAndBack(_ sender: Any) {
        //let name = lastName.text
        //let forename = firstName.text
        //let gender: String
        /*if switchbutton.isOn {
            gender = "Female"
        }
        else {
            gender = "Male"
        }*/
        
        
        //ce que j'envoie au server
        var json = [String:String]()
        json["surname"] = self.firstName.text ?? "Unknown"
        json["lastname"] = self.lastName.text ?? "Unknown"
        json["pictureUrl"] = "https://s-media-cache-ak0.pinimg.com/originals/e2/76/a8/e276a89e61d13d94f93250fc47827f09.jpg"
        
        // la request json
        var request = URLRequest(url: URL(string:apiPersonUrl)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            //si réponse du serveur
            if let data = data {
                
                // on parcourt
                let jsonDict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
                guard let dict = jsonDict as? [String : Any] else {
                    return
                }
                
                // on récupère les données
                let patient = PatientData(entity: PatientData.entity(), insertInto: self.persistentContainer.viewContext)//self.managedObjectContext
                patient.name = dict["lastname"] as? String
                patient.forename = dict["surname"] as? String
                patient.pictureUrl = dict["pictureUrl"] as? String
                patient.serverID = Int64(dict["id"] as? Int ?? 0)
                
                    
                // On envoie notre nouveau patient
                self.delegate?.createPatient(patient: patient)
                //self.delegate?.didCreatePerson(person: person)
                //self.dismiss(animated: true, completion: nil)
            
                //Thread pour progress bar
                var value: Float = 0
                
                DispatchQueue.global(qos:.userInitiated).async {
                    while (value < 1) {
                        Thread.sleep(forTimeInterval: 0.1)
                        
                        value += 0.01
                        DispatchQueue.main.async {
                            self.progressBar.progress += 0.01
                        }
                    }
                    
                    DispatchQueue.main.async {
                        //Fermer la fenêtre
                        self.dismiss(animated: true, completion: nil)
                    }
                }

                
            }
            
        }
        
        task.resume()
        
        /*guard delegate != nil else {
            print("Patient non enregistré")
            return
        }*/
        
        //let patient = Patient(name: name!, forename: forename!, gender: gender)
        //let patient = PatientData(entity: PatientData.entity(), insertInto: persistentContainer.viewContext)
        //patient.gender = gender
        //patient.name = name
        //patient.forename = forename
        // Appelle la fonction implémentée par le delegate
        //delegate?.createPatient(patient: patient)
        
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol CreatePatientDelegate: AnyObject {
    func createPatient(patient: PatientData)
}
