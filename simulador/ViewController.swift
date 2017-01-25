//
//  ViewController.swift
//  simulador
//
//  Created by Chucho on 11/9/16.
//  Copyright © 2016 UNOi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var loaderLogin: UIActivityIndicatorView!
    @IBOutlet weak var btnLogin: UIButton!
    
    var txtAccess: Bool = false
    var myMessage: String = ""
    var personId: Int = 0
    var personName: String = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        txtAccess = false
        txtUser.isEnabled = true
        txtPass.isEnabled = true
        btnLogin.isHidden = false
        loaderLogin.isHidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        print(tap)
        view.addGestureRecognizer(tap);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if appDelegate.getTranscriptions() > 0
        {
            changeScreen()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if textField == txtUser{
            txtPass.becomeFirstResponder()
        }
        if textField == txtPass{
            btnLogin.becomeFirstResponder()
        }
        
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        ScrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        ScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func clickLogin(_ sender: UIButton) {
        
        // DESHABILITANDO CONTROLES
        txtUser.isEnabled = false
        txtPass.isEnabled = false
        btnLogin.isHidden = true
        loaderLogin.isHidden = false
        
        validaAcceso{ (result) in
            
            DispatchQueue.main.async {
                // HABILITANDO CONTROLES
                self.txtUser.isEnabled = true
                self.txtPass.isEnabled = true
                self.btnLogin.isHidden = false
                self.loaderLogin.isHidden = true
                
                if result == "ok" {
                    print("CAMBIANDO PANTALLA")
                    
                    
                    self.appDelegate.storeTranscription(personId: self.personId, personName: self.personName)
                    self.changeScreen()
                    
                } else {
                    print("ERROR")
                    let alertController = UIAlertController(title: "Acceso denegado", message: result, preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func validaAcceso(completion: @escaping (_ result: String?)->()){
        // prepare json data
        let user = txtUser.text
        let pass = txtPass.text
        
        let postString = "user=" + user! + "&password=" + pass!
        
        // create post request
        let url = NSURL(string: "https://ruta.unoi.com/api/v0/simCosts/Authentication")!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = postString.data(using: .utf8)
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            //let responseString = String(data: data, encoding: .utf8)
            
            do {
                let mJson = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                if let mStatus = mJson["status"] as? [String:AnyObject]
                {
                    if let mMessage = mStatus["message"] as? String
                    {
                        print("FINISHED DOWNLOAD")
                        print(mMessage)
                        
                        if mMessage == "ok"
                        {
                            self.personId = (mJson["results"]?["personId"] as? Int)!
                            self.personName = (mJson["results"]?["name"] as? String)!
                            print(self.personId)
                        }
                        completion(mMessage)
                    }
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
//    func logear(){
//        print("INICIANDO")
//        if self.myMessage == "ok" {
//            performSegue(withIdentifier: "IniciaSesion", sender: self)
//        } else {
//            
//            txtUser.isEnabled = true
//            txtPass.isEnabled = true
//            btnLogin.isHidden = false
//            loaderLogin.isHidden = true
//            
//            let alertController = UIAlertController(title: "Acceso denegado", message: myMessage, preferredStyle: UIAlertControllerStyle.alert)
//            alertController.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.default,handler: nil))
//            self.present(alertController, animated: true, completion: nil)
//        }
//    }
    
    func changeScreen()
    {
        //self.performSegue(withIdentifier: "IniciaSesion", sender: self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NavController")
        self.present(controller, animated: true, completion: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }

}

