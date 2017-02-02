//
//  DetalleViewController.swift
//  simulador
//
//  Created by Chucho on 12/1/16.
//  Copyright © 2016 UNOi. All rights reserved.
//

import UIKit

class DetalleViewController: UIViewController {
    
    var miPropuesta: Propuesta = Propuesta()

    @IBOutlet weak var lblAula: UILabel!
    @IBOutlet weak var lblMaker: UILabel!
    @IBOutlet weak var lblAulamaker: UILabel!
    @IBOutlet weak var lblProyector: UILabel!
    @IBOutlet weak var lblImpresora3D: UILabel!
    @IBOutlet weak var lblIapdMini: UILabel!
    @IBOutlet weak var lblTelepresencia: UILabel!
    @IBOutlet weak var lblAceleracion: UILabel!
    @IBOutlet weak var lblCertificacion: UILabel!
    @IBOutlet weak var lblDesarrollo: UILabel!
    @IBOutlet weak var lblCertificacionETS: UILabel!
    @IBOutlet weak var lblSaldoPts: UILabel!
    @IBOutlet weak var lblTotalPagar: UILabel!
    @IBOutlet weak var lblExtensionAnios: UILabel!
    @IBOutlet weak var lblExtensionPesos: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        
        lblAula.text = miPropuesta.aulaDigital.description
        lblMaker.text = miPropuesta.makerCart.description
        lblAulamaker.text = miPropuesta.aulaMaker.description
        lblProyector.text = miPropuesta.proyector.description
        lblImpresora3D.text = miPropuesta.impresora3D.description
        lblIapdMini.text = miPropuesta.ipadMini.description
        lblTelepresencia.text = miPropuesta.telepresencia.description
        lblAceleracion.text = miPropuesta.aceleracon.description
        lblCertificacion.text = miPropuesta.certificacion.description
        lblDesarrollo.text = miPropuesta.desarrollo.description
        lblCertificacionETS.text = miPropuesta.certEts.description
        
        
        lblSaldoPts.text = miPropuesta.totalPuntos.description
        lblTotalPagar.text = numberFormatter.string(from: NSNumber(value: miPropuesta.totalPesos))
        lblExtensionAnios.text = miPropuesta.totalAnios.description
        lblExtensionPesos.text = numberFormatter.string(from: NSNumber(value: miPropuesta.totalPesosExt))
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
