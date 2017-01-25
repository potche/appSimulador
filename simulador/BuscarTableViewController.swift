//
//  BuscarTableViewController.swift
//  simulador
//
//  Created by Chucho on 11/22/16.
//  Copyright © 2016 UNOi. All rights reserved.
//

import UIKit

class BuscarTableViewController: UITableViewController, UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredTableDataString = [String]()
    var filteredTableData = [Escuela]()
    var tabledata = [Escuela]()
    var tabledataString = [String]()
    var selectedSchoolId: String = ""
    var selectedSchoolName: String = ""
    var selectedPuntos: Int = 0
    var selectedRenovacionKinder = 0
    var selectedRenovacionPrimaria = 0
    var selectedRenovacionSecundaria = 0
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = false
        tableView.tableHeaderView = searchController.searchBar
        tableView.delegate = self

        
        let total = appDelegate.getTotalSchools()
        if total > 0
        {
            tabledata = appDelegate.getSchools() as! [Escuela]
            self.tableView.reloadData()
            
        } else {
            
            let alertController = UIAlertController(title: "UNOi", message: "Descargando información", preferredStyle: UIAlertControllerStyle.alert)
            //alertController.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            loadJson{ (result) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    alertController.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.searchController.searchBar
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchController.searchBar.frame.height
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(searchController.isActive) {
            return filteredTableData.count
        }
        return tabledata.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // Configure the cell...
        cell.selectionStyle =  UITableViewCellSelectionStyle.none
        cell.textLabel?.textAlignment = NSTextAlignment.left
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
        
        if self.searchController.isActive {
            cell.textLabel?.text = filteredTableData[indexPath.row].nombre
            cell.detailTextLabel?.text = filteredTableData[indexPath.row].id
            // cell.textLabel?.text = filteredTableDataString[indexPath.row]
        } else {
            cell.textLabel?.text = tabledata[indexPath.row].nombre
            cell.detailTextLabel?.text = tabledata[indexPath.row].id
            // cell.textLabel?.text = tabledataString[indexPath.row]
        }

        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if self.searchController.isActive {
            selectedSchoolId = filteredTableData[indexPath.row].id
            selectedSchoolName = filteredTableData[indexPath.row].nombre
            selectedPuntos = filteredTableData[indexPath.row].puntosOfrecer
            selectedRenovacionKinder = filteredTableData[indexPath.row].renovacionKinder
            selectedRenovacionPrimaria = filteredTableData[indexPath.row].renovacionPrimaria
            selectedRenovacionSecundaria = filteredTableData[indexPath.row].renovacionSecundaria
        } else {
            selectedSchoolId = tabledata[indexPath.row].id
            selectedSchoolName = tabledata[indexPath.row].nombre
            selectedPuntos = tabledata[indexPath.row].puntosOfrecer
            selectedRenovacionKinder = tabledata[indexPath.row].renovacionKinder
            selectedRenovacionPrimaria = tabledata[indexPath.row].renovacionPrimaria
            selectedRenovacionSecundaria = tabledata[indexPath.row].renovacionSecundaria
        }
        
        self.searchController.searchBar.resignFirstResponder()
        performSegue(withIdentifier: "FromSearch", sender: self)
    }
 
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF.nombre CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (tabledata as NSArray).filtered(using: searchPredicate)
        
        filteredTableData = array as! [Escuela]
        self.tableView.reloadData()
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "FromSearch"
        {
            let svc = segue.destination as! ColegioViewController
            svc.idEscuela = selectedSchoolId
            svc.nombreEscuela = selectedSchoolName
            svc.puntosOfrecer = selectedPuntos
            svc.renovacionKinder = selectedRenovacionKinder
            svc.renovacionPrimaria = selectedRenovacionPrimaria
            svc.renovacionSecundaria = selectedRenovacionSecundaria
            
            print("SEND: " + selectedRenovacionKinder.description)
            print("SEND: " + selectedRenovacionPrimaria.description)
            print("SEND: " + selectedRenovacionSecundaria.description)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    func loadJson(completion: @escaping (_ result: NSArray?)->()){
        print("DESCARGANDO")
        // create post request
        
        // let url = NSURL(string: "https://ruta.unoi.com/api/v0/catalog/schools")!
        let url = NSURL(string: "https://ruta.unoi.com/api/v0/simCosts/colegioPuntos")!
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
                let mJson = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                
                print("DESCARGADO")
                
                if let resultObject = mJson as? [String: AnyObject]
                {
                    if let schoolsArray = resultObject["results"] as? NSArray
                    {
                        for i in 0 ..< (schoolsArray.count)
                        {
                            if let school = schoolsArray[i] as? NSDictionary
                            {
                                let schoolId = (school["colegioId"] as? Int)!
                                let schoolName: String = school["colegio"] as! String
                                let myData = school["data"] as AnyObject
                                let puntosOfrecer: Int = (myData["puntosOfrecer"] as? Int)!
                                let renovacionK: Int = (myData["renovacionK"] as? Int)!
                                let renovacionP: Int = (myData["renovacionP"] as? Int)!
                                let renovacionS: Int = (myData["renovacionS"] as? Int)!
                                let mEscuela = Escuela()
                                
                                mEscuela.id = schoolId.description
                                mEscuela.nombre = schoolName
                                mEscuela.puntosOfrecer = puntosOfrecer
                                mEscuela.renovacionKinder = renovacionK
                                mEscuela.renovacionPrimaria = renovacionP
                                mEscuela.renovacionSecundaria = renovacionS
                                self.tabledata.append(mEscuela)
                                self.tabledataString.append(schoolName)
                                
                                print("id: " + schoolId.description + " " + schoolName + ": K: " + renovacionK.description + ": P: " + renovacionP.description + ": S: " + renovacionS.description)
                                
                                self.appDelegate.storeSchool(schoolId: schoolId, schoolName: schoolName, puntosOfrecer: puntosOfrecer, data: "", renovacionKinder: renovacionK, renovacionPrimaria: renovacionP, renovacionSecundaria: renovacionS)
                            }
                        }
                        completion(schoolsArray)
                    }
                }
                
                
                
//                if let schoolsArray = mJson as? NSArray{
//                    
//                    for i in 0 ..< (schoolsArray.count)
//                    {
//                        if let school = schoolsArray[i] as? NSDictionary{
//                            if let schoolId = school["schoolid"] as? AnyObject{
//                                if let schoolName = school["school"] as? AnyObject{
//                                    var mySchool = schoolsArray[i] as? NSDictionary
//                                    var myId = mySchool?["schoolid"] as? Int
//                                    let mEscuela = Escuela()
//                                    mEscuela.id = schoolId as! String
//                                    mEscuela.nombre = schoolName as! String
//                                    self.tabledata.append(mEscuela)
//                                    self.tabledataString.append(schoolName as! String)
//                                    if myId == nil{
//                                        myId = 0
//                                    }
//                                    self.appDelegate.storeSchool(schoolId: myId!, schoolName: schoolName as! String)
//                                }
//                            }
//                        }
//                    }
//                    completion(schoolsArray)
//                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }

}
