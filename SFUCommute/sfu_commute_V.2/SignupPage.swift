//
//  File.swift
//  sfu_commute_V.2
//
//  Created by jyotsna jaswal on 2016-10-22.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import Foundation

import UIKit

import UIKit

class SignupPage: UIViewController {

    @IBOutlet weak var email: UITextField!

    @IBOutlet weak var password: UITextField!

    @IBOutlet weak var confirmPassword: UITextField!

    @IBOutlet weak var phoneNumber: UITextField!

    @IBOutlet weak var firstName: UITextField!

    @IBOutlet weak var lastName: UITextField!

    @IBOutlet weak var error: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        email.text = "email"
        password.text = "password"
        confirmPassword.text = "confirm password"
        phoneNumber.text = "phone number"
        firstName.text = "first name"
        lastName.text = "last name"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }


    @IBAction func register(_ sender: AnyObject) {
        //if (confirmPassword! != password!){
        //    error.text! = "passwords does not match"
        //}
        //else{
            func forData() {
                let emailText = String(email.text!)
                let passwordText  = String(password.text!)
                let firstNameText  = String(firstName.text!)
                let lastNameText = String(lastName.text!)
                if let url = URL(string: "http://54.69.64.180/signup") {
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    var postString = "{\"email\": \""
                    postString += emailText!
                    postString += "\", \"password\": \""
                    postString += passwordText!
                    postString += "\", \"firstname\" : \"" + firstNameText!
                    postString += "\", \"lastname\":\"" + lastNameText! + "\"}"
                    //request.httpMethod = postString
                    request.httpBody = postString.data(using: .utf8)
                    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-type")
                    print("I am making a request now:    ")
                    URLSession.shared.dataTask(with: request, completionHandler: { (data, response, body) in
                        let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        print(json)
                        //print(json["error"])
                        let dict = json as? NSDictionary
                        print("This is the error::::---------------")
                        print(dict?["error"])
                        //let responseString = String(data:data!, encoding: .utf8)
                        //print(responseString)
                        print(body)
                        print(response)
                    }).resume()
                }
            }
        forData()
        }

       // }

    @IBAction func cancel(_ sender: AnyObject) {
        let CurrentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
        self.navigationController?.pushViewController(CurrentViewController!, animated: true)
    }
}



/*

class SignupPage: UIViewController {

    @IBOutlet weak var email: UITextField!

    @IBOutlet weak var password: UITextField!

    @IBOutlet weak var confirmPassword: UITextField!

    @IBOutlet weak var phoneNumber: UITextField!

    @IBOutlet weak var firstName: UITextField!

    @IBOutlet weak var lastName: UITextField!

    var emailText = String()
    var passwordText = String()
    var confirmPasswordText = String()
    var phoneNumberText = String()
    var firstNameText = String()
    var lastNameText = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        //email.text = ""
        //password.text = ""
        //confirmPassword.text = ""
        //phoneNumber.text = ""
        //firstName.text = ""
        //lastName.text = ""
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func register(_ sender: AnyObject) {
        emailText = email.text!
        passwordText = password.text!
        //print(passwordText)
        confirmPasswordText = confirmPassword.text!
        phoneNumberText = phoneNumber.text!
        firstNameText = firstName.text!
        lastNameText = lastName.text!
        func forData() {
            if let url = URL(string: "http://54.69.64.180/signup") {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                let postString : String = "{\"email\": " + emailText + ", \"password\": " + passwordText + ", \"firstname\" : " + firstNameText + ", \"lastname\":" + lastNameText + "}"
                //request.httpMethod = postString
                request.httpBody = postString.data(using: .utf8)
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-type")
                URLSession.shared.dataTask(with: request, completionHandler: {data,resp,_ in
                    print(resp)
                }).resume()
            }
        }
        forData()
    }
   }

        /*var request = URLRequest(url: URL(string: "http://54.69.64.180/auth/signup")!)
        request.httpMethod = "POST"

        let postString = "{\"email\": emailText , \"password\": passwordText}"

        request.httpBody = postString.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        var connection = NSURLConnection(request: request, delegate: nil, startImmediately: true)

        var request = URLRequest(url: URL(string: "http://54.69.64.180/auth/signup")!)
        request.httpMethod = "POST"
        
        let postString = "{\"email\": emailText , \"password\": passwordText}"

        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }

            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
*/*/
