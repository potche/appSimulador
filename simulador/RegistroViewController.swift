//
//  RegistroViewController.swift
//  simulador
//
//  Created by Chucho on 11/9/16.
//  Copyright © 2016 UNOi. All rights reserved.
//

import UIKit


class RegistroViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtCalle: UITextField!
    @IBOutlet weak var txtCp: UITextField!
    @IBOutlet weak var txtColonia: UITextField!
    @IBOutlet weak var txtEdo: UITextField!
    @IBOutlet weak var txtPais: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var loaderCP: UIActivityIndicatorView!
    
    var coloniasArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loaderCP.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buscarCodigo(_ sender: Any) {
        let myCp = txtCp.text! as String
        if myCp.characters.count == 5
        {
            self.txtCp.isEnabled = false
            self.loaderCP.isHidden = false
            loadJson{ (result) in
                DispatchQueue.main.async {
                    self.loaderCP.isHidden = true
                    self.txtCp.isEnabled = true
                    self.txtColonia.text = result?.colonia
                    self.txtEdo.text = result?.estado
                    self.txtPais.text = result?.pais
                    self.pickerView.reloadAllComponents()
                    if self.coloniasArr.count == 1
                    {
                        self.txtColonia.text = self.coloniasArr[0]
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == txtNombre
        {
            txtCalle.becomeFirstResponder()
        }
        if textField == txtCalle
        {
            txtCp.becomeFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField != txtNombre){
            ScrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        ScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func buscaCP(_ sender: UITextField) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if txtNombre.text == "" || txtCalle.text == "" || txtCp.text == ""
        {
            let alertController = UIAlertController(title: "Falta información", message: "Debes llenar los campos marcados con un *", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            if segue.identifier == "GoNew"
            {
                let nmEscuela = txtNombre.text!
                let stEscuela = txtCalle.text!
                let cpEscuela = txtCp.text!
                let coEscuela = txtColonia.text!
                let edEscuela = txtEdo.text!
                let paEscuela = txtPais.text!
                
                let svc = segue.destination as! ColegioViewController
                svc.nombreEscuela = nmEscuela
                svc.calle = stEscuela
                svc.cp = cpEscuela
                svc.colonia = coEscuela
                svc.estado = edEscuela
                svc.pais = paEscuela
            }
        }
    }
    
    func loadJson(completion: @escaping (_ result: Escuela?)->()){
        print("DESCARGANDO")
        // create post request
        let url = NSURL(string: "https://ruta.unoi.com/api/v0/simCosts/cp/" + txtCp.text!)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
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
                
                print("DESCARGADO")
                
                self.coloniasArr.removeAll()
                if let mResults = mJson["results"] as? [String:AnyObject]
                {
                    if let mCp = mResults["cp"] as? String
                    {
                        if let mCols = mResults["colonias"] as? NSArray
                        {
                            for i in 0 ..< (mCols.count)
                            {
                                self.coloniasArr.append(mCols[i] as! String)
                            }
                            print("FINISHED DOWNLOAD")
                            let mEscuela = Escuela()
                            mEscuela.cp = mCp
                            // mEscuela.colonia = mCol
                            mEscuela.estado = mResults["estado"] as! String
                            mEscuela.pais = "México"
                            completion(mEscuela)
                        }
                    }
                }
                
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return coloniasArr.count;
    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return coloniasArr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label = view as! UILabel!
        if label == nil {
            label = UILabel()
        }
        
        let data = coloniasArr[row]
        let title = NSAttributedString(string: data, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightRegular)])
        label?.attributedText = title
        label?.textAlignment = .center
        return label!
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtColonia.text = coloniasArr[row]
    }

}
