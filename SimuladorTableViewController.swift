//
//  SimuladorTableViewController.swift
//  simulador
//
//  Created by Chucho on 12/16/16.
//  Copyright © 2016 UNOi. All rights reserved.
//

import UIKit

class SimuladorTableViewController: UITableViewController {
    
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
    var nombreContacto: String = ""
    var correoContacto: String = ""
    var vendorId: Int = 0
    
    // VALORES QUE DESCUENTA CADA ELEMENTO
    var stepAula = 2
    var stepCart = 3
    var stepMaker = 18
    var stepProyecto = 2
    var stepTele = 20
    var stepAceleracion = 4
    var stepCertificacion = 12
    var stepDesarrollo = 20
    var stepCertEts = 1
    
    // VARIABLES AUXILIARES PARA DETECTAR INCREMENTO O DECREMENTO
    var tmpStepAula = 0
    var tmpStepCart = 0
    var tmpStepMaker = 0
    var tmpStepProyecto = 0
    var tmpStepTele = 0
    var tmpStepAceleracion = 0
    var tmpStepCertificacion = 0
    var tmpStepDesarrollo = 0
    var tmpStepCertEts = 0
    
    // VARIABLES GLOBALES DE SALTOS
    var totalPuntosOriginal: Int = 0
    var totalPuntos: Int = 0
    var totalPesos: Int = 0
    var totalPesosExt: Int = 0
    var totalAnios: Int = 0
    var totalParticipacion: Int = 0
    
    // VARIABLES PARA IMPORTES TOTALES
    var sdoAnios: Int = 0
    var sdoEfectivo: Int = 0
    var sdoParti: Int = 0
    var changeAnios: Bool = false
    var changePesos: Bool = false
    var changeParti: Bool = false
    
    var latitude = 0.00
    var longitude = 0.00
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var LblAula: UILabel!
    @IBOutlet weak var lblCart: UILabel!
    @IBOutlet weak var lblMaker: UILabel!
    @IBOutlet weak var lblProyecto: UILabel!
    @IBOutlet weak var lblTele: UILabel!
    @IBOutlet weak var lblAceleracion: UILabel!
    @IBOutlet weak var lblCertificacion: UILabel!
    @IBOutlet weak var lblDesarrollo: UILabel!
    @IBOutlet weak var lblCertEts: UILabel!
    @IBOutlet weak var txtSaldoPts: UITextField!
    @IBOutlet weak var txtSaldoPesos: UITextField!
    @IBOutlet weak var txtNombreEscuela: UILabel!
    
    @IBOutlet weak var loaderGuarda: UIActivityIndicatorView!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var lblExtension: UILabel!
    @IBOutlet weak var txtSaldoAnios: UITextField!
    @IBOutlet weak var lblSaldoPesos2: UILabel!
    @IBOutlet weak var txtSaldoPesos2: UITextField!
    @IBOutlet weak var btnMas: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        totalPuntosOriginal = totalPuntos
        txtSaldoPts.text = totalPuntos.description;
        //sliderTotalPuntos.maximumValue = Float(totalPuntos);
        
        print("ID: " + idEscuela)
        print("NOMBRE: " + nombreEscuela)
        txtNombreEscuela.text = nombreEscuela
        
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        btnMas.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        } else if section == 1 {
            return 9
        } else {
            return 2
        }
    }
    
    @IBAction func SteperAula(_ sender: UIStepper) {
        if tmpStepAula < Int(sender.value){
            totalPuntos = Int(totalPuntos - stepAula);
        } else {
            totalPuntos = Int(totalPuntos + stepAula);
        }
        tmpStepAula = Int(sender.value)
        LblAula.text = Int(sender.value).description;
        self.updateTotales()
    }
    
    @IBAction func SteperCart(_ sender: UIStepper) {
        if tmpStepCart < Int(sender.value){
            totalPuntos = Int(totalPuntos - stepCart);
        } else {
            totalPuntos = Int(totalPuntos + stepCart);
        }
        tmpStepCart = Int(sender.value)
        lblCart.text = Int(sender.value).description;
        self.updateTotales()
    }
    
    @IBAction func SteperMaker(_ sender: UIStepper) {
        if tmpStepMaker < Int(sender.value){
            totalPuntos = Int(totalPuntos - stepMaker);
        } else {
            totalPuntos = Int(totalPuntos + stepMaker);
        }
        tmpStepMaker = Int(sender.value)
        lblMaker.text = Int(sender.value).description;
        self.updateTotales()
    }
    
    @IBAction func SteperProyecto(_ sender: UIStepper) {
        if tmpStepProyecto < Int(sender.value){
            totalPuntos = Int(totalPuntos - stepProyecto);
        } else {
            totalPuntos = Int(totalPuntos + stepProyecto);
        }
        tmpStepProyecto = Int(sender.value)
        lblProyecto.text = Int(sender.value).description;
        self.updateTotales()
    }
    
    @IBAction func SteperTele(_ sender: UIStepper) {
        if tmpStepTele < Int(sender.value){
            totalPuntos = Int(totalPuntos - stepTele);
        } else {
            totalPuntos = Int(totalPuntos + stepTele);
        }
        tmpStepTele = Int(sender.value)
        lblTele.text = Int(sender.value).description;
        self.updateTotales()
    }
    
    @IBAction func SteperAceleracion(_ sender: UIStepper) {
        if tmpStepAceleracion < Int(sender.value){
            totalPuntos = Int(totalPuntos - stepAceleracion);
        } else {
            totalPuntos = Int(totalPuntos + stepAceleracion);
        }
        tmpStepAceleracion = Int(sender.value)
        lblAceleracion.text = Int(sender.value).description;
        self.updateTotales()
    }
    
    @IBAction func SteperCertificacion(_ sender: UIStepper) {
        if tmpStepCertificacion < Int(sender.value){
            totalPuntos = Int(totalPuntos - stepCertificacion);
        } else {
            totalPuntos = Int(totalPuntos + stepCertificacion);
        }
        tmpStepCertificacion = Int(sender.value)
        lblCertificacion.text = Int(sender.value).description;
        self.updateTotales()
    }
    
    @IBAction func SteperDesarrollo(_ sender: UIStepper) {
        if tmpStepDesarrollo < Int(sender.value){
            totalPuntos = Int(totalPuntos - stepDesarrollo);
        } else {
            totalPuntos = Int(totalPuntos + stepDesarrollo);
        }
        tmpStepDesarrollo = Int(sender.value)
        lblDesarrollo.text = Int(sender.value).description;
        txtSaldoPesos.text = (totalPuntos * 17500).description
        self.updateTotales()
    }
    
    @IBAction func StepperCertEts(_ sender: UIStepper) {
        if tmpStepCertEts < Int(sender.value){
            totalPuntos = Int(totalPuntos - stepCertEts);
        } else {
            totalPuntos = Int(totalPuntos + stepCertEts);
        }
        tmpStepCertEts = Int(sender.value)
        lblCertEts.text = Int(sender.value).description;
        txtSaldoPesos.text = (totalPuntos * 17500).description
        self.updateTotales()
    }
    
    func updateTotales()
    {
        // totalAnios = Int(ceil(Double(totalPuntos * -1) / Double(totalPuntosOriginal / 3)))
        
        totalAnios = 1
        
        if totalPuntos < 0 {
            totalPesos = abs(totalPuntos) * 17500
        } else {
            totalPesos = 0
            totalAnios = 0
        }
        
        //lblTotalPuntos.text = totalPuntos.description;
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let txtTotalFormateado = numberFormatter.string(from: NSNumber(value: totalPesos))
        
        txtSaldoPts.text = totalPuntos.description
        txtSaldoPesos.text = txtTotalFormateado!
        txtSaldoPesos2.text = txtTotalFormateado!
        txtSaldoAnios.text = totalAnios.description
        
        //txtSaldoParticipacion.text = "0"
        
        sdoEfectivo = totalPesos
        sdoAnios = totalAnios
        sdoParti = 0
        
        calculaImportes()
    }
    
    func calculaImportes()
    {
        
        txtSaldoAnios.text = "1"
        changeAnios = true
        
        if txtSaldoPesos.text == "" {
            sdoEfectivo = 0
        } else {
            sdoEfectivo = Int(txtSaldoPesos.text!.replacingOccurrences(of: ",", with: ""))!
        }
        
        if txtSaldoAnios.text == "" {
            sdoAnios = 0
        } else {
            sdoAnios = Int(txtSaldoAnios.text!)!
        }
        
        //        if txtSaldoParticipacion.text == "" {
        //            sdoParti = 0
        //        } else {
        //            sdoParti = Int(txtSaldoParticipacion.text!)!
        //        }
        
        let ptsAPagar = abs(totalPuntos)
        let ptsEfectivo = Int(Int(sdoEfectivo) / 17500)
        let ptsAnio = Int(Double(sdoAnios) * (Double(totalPuntosOriginal) / 3))
        let ptsParticipacion = Int(Int(sdoParti) / 17500)
        
        var ptsAcumulados = 0
        
        if changeAnios
        {
            ptsAcumulados = ptsAcumulados + ptsAnio
        }
        if changePesos
        {
            ptsAcumulados = ptsAcumulados + ptsEfectivo + ptsParticipacion
        }
        if changeParti
        {
            ptsAcumulados = ptsAcumulados + ptsEfectivo + ptsParticipacion
        }
        
        let ptsRestantes = ptsAPagar - ptsAcumulados
        
        print("ACUMULADOS : " + ptsAcumulados.description + " RESTANTES: " + ptsRestantes.description)
        
        if ptsRestantes < 0
        {
            //            let alertController = UIAlertController(title: "Error", message: "Importes no válidos", preferredStyle: UIAlertControllerStyle.alert)
            //            alertController.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.default,handler: nil))
            //            self.present(alertController, animated: true, completion: nil)
            //            updateTotales()
            if changeAnios
            {
                txtSaldoPesos2.text = 0.description
            }
            if changePesos || changeParti
            {
                txtSaldoAnios.text = 0.description
            }
        }
        else {
            
            // let tmpTotalAnios = Int(ceil(Double(ptsRestantes) / Double(totalPuntosOriginal / 3)))
            let tmpTotalAnios = 1
            let tmpTotalpesos: Int = ptsRestantes * 17500
            
            if changeAnios
            {
                // txtSaldoPesos2.text = tmpTotalpesos.description
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = NumberFormatter.Style.decimal
                txtSaldoPesos2.text = numberFormatter.string(from: NSNumber(value: tmpTotalpesos))
            }
            if changePesos || changeParti
            {
                txtSaldoAnios.text = tmpTotalAnios.description
            }
            
        }
        changePesos = false
        changeAnios = false
        changeParti = false
    }
    
    @IBAction func changePesos(_ sender: UITextField) {
        changePesos = true
        calculaImportes()
    }
    
    @IBAction func changeAnios(_ sender: UITextField) {
        changeAnios = true
        calculaImportes()
    }
    
    @IBAction func changeParticipacion(_ sender: UITextField) {
        changeParti = true
        calculaImportes()
    }
    
    @IBAction func clickGuardar(_ sender: UIButton) {
        // DESHABILITA BOTONES
        btnGuardar.isHidden = true
        loaderGuarda.isHidden = false
        guardaPropuesta{ (result) in
            DispatchQueue.main.async {
                // HABILITA BOTONES
                self.btnGuardar.isHidden = false
                self.loaderGuarda.isHidden = true
                
                let alertController = UIAlertController(
                    title: "UNOi",
                    message: result,
                    preferredStyle: UIAlertControllerStyle.alert)
                
                let closeAction = UIAlertAction(
                    title: "Cerrar",
                    style: UIAlertActionStyle.default,
                    handler: {(alert: UIAlertAction!) -> Void in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "NavController")
                        self.present(controller, animated: true, completion: nil)
                        
                })
                
                alertController.addAction(closeAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    func tapBlurButton(_ sender: UILongPressGestureRecognizer) {
        lblExtension.isHidden = false
        txtSaldoAnios.isHidden = false
        lblSaldoPesos2.isHidden = false
        txtSaldoPesos2.isHidden = false
    }

    func guardaPropuesta(completion: @escaping (_ result: String?)->()){
        let postString = "{"  +
            "\"escuela\":{  " +
            "\"idEscuela\": " + idEscuela + "," +
            "\"nombreEscuela\": \"" + nombreEscuela + "\"" +
            "}," +
            "\"direccion\":{  " +
            "\"cp\": \"" + cp + "\"," +
            "\"colonia\":\"" + colonia + "\"," +
            "\"calle\":\"" + calle + "\"," +
            "\"numero\":\"" + numero + "\"" +
            "}," +
            "\"contacto\":{" +
            "\"nombre\": \"" + nombreContacto + "\"," +
            "\"email\": \"" + correoContacto + "\"" +
            "}," +
            "\"items\":{  " +
            "\"aulaDigital\":" + tmpStepAula.description + "," +
            "\"makerCart\":" + tmpStepCart.description + "," +
            "\"aulaMaker\":" + tmpStepMaker.description + "," +
            "\"proyector\":" + tmpStepProyecto.description + "," +
            "\"telepresencia\":" + tmpStepTele.description + "," +
            "\"aceleracon\":" + tmpStepAceleracion.description + "," +
            "\"certificacion\":" + tmpStepCertificacion.description + "," +
            "\"desarrollo\":" + tmpStepDesarrollo.description + "" +
            "}," +
            "\"puntosTotales\":" + totalPuntosOriginal.description + "," +
            "\"puntosUsados\":150," +
            "\"puntosSaldo\":" + totalPuntos.description + "," +
            "\"totalPesos\":" + totalPesos.description + "," +
            "\"totalAños\":" + totalAnios.description + "," +
            "\"totalAportacion\":" + totalParticipacion.description + "," +
            "\"totalAlumnos\": " + numAlumnos.description + "," +
            "\"porcentajeParticipacion\":10," +
            "\"precioVenta\":500000.50," +
            "\"vendedorId\":\"" + vendorId.description + "\"" +
        "}"
        
        print(postString)
        
        if Int(idEscuela) == nil {
            idEscuela = "0"
        }
        
        if Int(cp) == nil {
            cp = "0"
        }
        
        print (totalAnios);
        
        appDelegate.storeProposal(
            vendedorId: vendorId
            , schoolId: Int(idEscuela)!
            , schoolName: nombreEscuela, cp: Int(cp)!
            , col: colonia
            , street: calle
            , streetNo: numero
            , contactName: nombreContacto
            , contactMail: correoContacto
            , aulaDigital: tmpStepAula
            , makerCart: tmpStepCart
            , aulaMaker: tmpStepMaker
            , proyector: tmpStepProyecto
            , telepresencia: tmpStepTele
            , aceleracon: tmpStepAceleracion
            , certificacion: tmpStepCertificacion
            , desarrollo: tmpStepDesarrollo
            , totalPesos: Double(totalPesos)
            , totalAnios: totalAnios
            , totalPesosExt: Double(totalPesosExt)
            , totalPuntos: totalPuntos
        )
        
        
        //        // create post request
        //        let url = NSURL(string: "https://ruta.unoi.com/api/v0/simCosts/proposal")!
        //        let request = NSMutableURLRequest(url: url as URL)
        //        request.httpMethod = "POST"
        //
        //        // insert json data to the request
        //        request.httpBody = postString.data(using: .utf8)
        //
        //        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
        //            guard let data = data, error == nil else {
        //                // check for fundamental networking error
        //                print("error=\(error)")
        //                return
        //            }
        //
        //            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
        //                // check for http errors
        //                print("statusCode should be 200, but is \(httpStatus.statusCode)")
        //                print("response = \(response)")
        //            }
        //
        //            //let responseString = String(data: data, encoding: .utf8)
        //
        //            do {
        //                let mJson = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
        //                if let mStatus = mJson["status"] as? [String:AnyObject]
        //                {
        //                    if let mMessage = mStatus["message"] as? String
        //                    {
        completion("Se ha guardado la propuesta")
        //                    }
        //                }
        //            } catch let error as NSError {
        //                print(error.localizedDescription)
        //            }
        //        }
        //        
        //        task.resume()
    }
}
