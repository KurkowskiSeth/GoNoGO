//
//  UpcomingLaunches_TVC.swift
//  GoNoGo
//
//  Created by Seth Kurkowski on 1/2/19.
//  Copyright © 2019 Seth Kurkowski. All rights reserved.
//

import UIKit

private let REUSE_INDENTIFIER = "launch_cell"
private let API_URL = "https://launchlibrary.net/1.4/launch?next=50&mode=verbose"

class UpcomingLaunches_TVC: UITableViewController {
    
    var mDataModel: DataModel? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.estimatedRowHeight = 115
//        tableView.rowHeight = UITableView.automaticDimension
        
        pullFromApi()
    }
    
    // MARK: - API Handling
    
    func pullFromApi() {
        guard let url = URL(string: API_URL) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {print("Data Return Error"); return}
            do {
                let decoder = JSONDecoder()
                self.mDataModel = try decoder.decode(DataModel.self, from: data)
                
            } catch {
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            }.resume()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataModel = mDataModel else {return 0}
        return dataModel.launches.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: REUSE_INDENTIFIER, for: indexPath) as! LaunchCell
        
        // Configure Cell
        guard let dataModel = mDataModel else {return cell}
        
        cell.nameLbl.text = dataModel.launches[indexPath.row].name
        cell.locationLbl.text = dataModel.launches[indexPath.row].location.name
        cell.countdownLbl.text = dataModel.launches[indexPath.row].windowstart
        
        // Add shadow to cell
//        cell.borderView.layer.shadowPath = UIBezierPath(rect: cell.borderView.bounds).cgPath
        cell.borderView.layer.shadowColor = UIColor.black.cgColor
        cell.borderView.layer.shadowOpacity = 1
        cell.borderView.layer.shadowOffset = CGSize.zero
        cell.borderView.layer.shadowRadius = 3

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
