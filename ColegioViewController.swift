//
//  ColegioViewController.swift
//  simulador
//
//  Created by Chucho on 11/22/16.
//  Copyright © 2016 UNOi. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ColegioViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var txtNoAlumnosKinder: UITextField!
    @IBOutlet weak var txtNoAlumnosPrimaria: UITextField!
    @IBOutlet weak var txtNoAlumnosSecundaria: UITextField!
    @IBOutlet weak var txtPuntos: UITextField!
    @IBOutlet weak var txtContacto: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtNombreEscuela: UILabel!
    
    // VARIABLES DE LA ESCUELA
    var idEscuela: String = ""
    var nombreEscuela: String = ""
    var cp: String = ""
    var colonia: String = ""
    var calle: String = ""
    var ciudad: String = ""
    var estado: String = ""
    var pais: String = ""
    var numero: String = ""
    var numAlumnos: String = ""
    var latitude = 0.00
    var longitude = 0.00
    var puntosOfrecer = 0
    var renovacionKinder = 0
    var renovacionPrimaria = 0
    var renovacionSecundaria = 0
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap);
        
        txtCorreo.delegate = self
        txtContacto.delegate = self
        txtNoAlumnosKinder.delegate = self
        txtNoAlumnosPrimaria.delegate = self
        txtNoAlumnosSecundaria.delegate = self
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        txtNoAlumnosKinder.text = renovacionKinder.description
        txtNoAlumnosPrimaria.text = renovacionPrimaria.description
        txtNoAlumnosSecundaria.text = renovacionSecundaria.description
        txtPuntos.text = puntosOfrecer.description
        txtNombreEscuela.text = nombreEscuela
        
        if puntosOfrecer == 0
        {
            print("Prospecto")
            txtNoAlumnosKinder.isEnabled = true
            txtNoAlumnosPrimaria.isEnabled = true
            txtNoAlumnosSecundaria.isEnabled = true
        } else {
            print("existente")
            txtNoAlumnosKinder.isEnabled = false
            txtNoAlumnosPrimaria.isEnabled = false
            txtNoAlumnosSecundaria.isEnabled = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.leftBarButtonItem = nil;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == txtContacto
        {
            txtCorreo.becomeFirstResponder()
        }
        if textField == txtCorreo
        {
            txtNoAlumnosKinder.becomeFirstResponder()
        }
        if textField == txtNoAlumnosKinder
        {
            txtNoAlumnosPrimaria.becomeFirstResponder()
        }
        if textField == txtNoAlumnosPrimaria
        {
            txtNoAlumnosSecundaria.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField != txtContacto){
            ScrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        ScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if txtPuntos.text == ""
        {
            let alertController = UIAlertController(title: "Alerta", message: "Captura la informacion solicitada", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var numAlumnosK = 0
        var numAlumnosP = 0
        var numAlumnosS = 0
        
        if txtNoAlumnosKinder.text != ""
        {
            numAlumnosK = Int(txtNoAlumnosKinder.text!)!
        }
        if txtNoAlumnosPrimaria.text != ""
        {
            numAlumnosP = Int(txtNoAlumnosPrimaria.text!)!
        }
        if txtNoAlumnosSecundaria.text != ""
        {
            numAlumnosS = Int(txtNoAlumnosSecundaria.text!)!
        }
        let numAlumnosTotal = numAlumnosK + numAlumnosP + numAlumnosS
        let numPuntos = (numAlumnosTotal) * 2;
        print(numPuntos)
        //txtPuntos.text = numPuntos.description;
        
        //let svc = segue.destination as! SimuladorViewController;
        let svc = segue.destination as! SimuladorTableViewController;
        
        svc.numAlumnos = numAlumnosTotal.description
        svc.totalPuntos = puntosOfrecer;
        svc.idEscuela = idEscuela
        svc.nombreEscuela = nombreEscuela
        svc.calle = calle
        svc.cp = cp
        svc.colonia = colonia
        svc.estado = estado
        svc.pais = pais
    }
    
    func updatePuntos()
    {
        var numAlumnosK = 0
        var numAlumnosP = 0
        var numAlumnosS = 0
        
        if txtNoAlumnosKinder.text != ""
        {
            numAlumnosK = Int(txtNoAlumnosKinder.text!)!
        }
        if txtNoAlumnosPrimaria.text != ""
        {
            numAlumnosP = Int(txtNoAlumnosPrimaria.text!)!
        }
        if txtNoAlumnosSecundaria.text != ""
        {
            numAlumnosS = Int(txtNoAlumnosSecundaria.text!)!
        }
        
        let numAlumnosTotal = numAlumnosK + numAlumnosP + numAlumnosS
        let numPuntos = (numAlumnosTotal) / 10
        txtPuntos.text = numPuntos.description;
        puntosOfrecer = numPuntos
        print("Puntos: " + txtPuntos.text!)
        //txtPuntos.text = puntosOfrecer.description
    }
    
    @IBAction func alumnosChanged(_ sender: UITextField) {
        if idEscuela == ""
        {
            updatePuntos()
        }
    }
    
    
    @IBAction func numAlumnosChanged(_ sender: UITextField) {
        //updatePuntos()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location11 = locations.first {
            //print("Found User's location: \(location11)")
            //print("Latitude: \(location11.coordinate.latitude) Longitude: \(location11.coordinate.longitude)")
            latitude = location11.coordinate.latitude
            longitude = location11.coordinate.longitude
            //startConnection()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
