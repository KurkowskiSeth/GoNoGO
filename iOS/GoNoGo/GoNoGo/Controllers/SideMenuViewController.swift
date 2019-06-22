//
//  SideMenuViewController.swift
//  GoNoGo
//
//  Created by Seth Kurkowski on 4/26/19.
//  Copyright © 2019 Seth Kurkowski. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    var delegate: SideMenuViewControllerDelegate!
    
    var menuItems = [
        "Upcoming Launches",
        "Viewing Locations",
        "Checklist"
    ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.reloadData()
    }
}

extension SideMenuViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        delegate.didSelect(indexPath.item)
    }
}

extension SideMenuViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print(indexPath.item)
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.item]
        return cell
    }
}

protocol SideMenuViewControllerDelegate
{
    func didSelect(_ item: Int)
}
