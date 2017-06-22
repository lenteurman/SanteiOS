//
//  Patient.swift
//  Sante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit

extension PatientData {

    func getName() -> String {
        if UserDefaults.standard.value(forKey: "isNameFirst") as? Int == 0 {
            return self.name! + " " + self.forename!
        }
        else {
            return self.forename! + " " + self.name!
        }
    }
}
class Patient {
    var name: String
    var forename: String
    var gender: String
    
    init(name: String, forename: String, gender: String) {
        self.name = name
        self.forename = forename
        self.gender = gender
    }
    
    /*func getName() -> String{
        if UserDefaults.standard.value(forKey: "isNameFirst") != nil {
            if gender == "Male" {
                return "Mister " + self.name + " " + self.forename
            }
            else {
                return "Miss " + self.name + " " + self.forename
            }
        }
        else {
            if gender == "Male" {
                return "Mister " + self.forename + " " + self.name
            }
            else {
                return "Miss " + self.forename + " " + self.name
            }
        }
    }*/
}
