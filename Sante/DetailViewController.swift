//
//  DetailViewController.swift
//  Sante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var forename: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    var patient: PatientData!
    
    let apiPersonUrl = "http://10.1.0.100:3000/persons"
    
    var methodDelete: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        /*let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(showCreateViewController))
         self.navigationItem.rightBarButtonItem = button
         */
        
        self.title = patient.getName()
        self.name.text = patient.name
        self.forename.text = patient.forename
        self.gender.text = patient.gender
        self.avatar.image = UIImage(named: "")
        
        var urlRequest = URLRequest(url: URL(string: patient.pictureUrl!)!)
        urlRequest.httpMethod = "GET"
        
        
        //Pas besoin de le laisser dans un autre QoS
        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data, tesponse, error) in
            
            // par défault le fait dans un autre thread
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self.avatar.image = image
                }
            }
            
        }
        task.resume()
        
        
        let buttonDel = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(backTableViewController))
        self.navigationItem.rightBarButtonItem = buttonDel
        
    }
    
    func backTableViewController() {
        let idPersonnUrl: String = apiPersonUrl + "/" + String(patient.serverID)
        var urlRequest2 = URLRequest(url: URL(string: idPersonnUrl)!)
        urlRequest2.httpMethod = "DELETE"
        
        let task2 = URLSession.shared.dataTask(with: urlRequest2)
        
        task2.resume()
        self.methodDelete?()
        // revenir en arriere
        self.navigationController?.popViewController(animated: true)
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
