//
//  ViewController.swift
//  GoNoGo
//
//  Created by Seth Kurkowski on 4/1/19.
//  Copyright © 2019 Seth Kurkowski. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController
{
    var hamburgerMenuBtn: UIButton!
    var delegate:         HomeViewControllerDelegate?
    
    let launches = UpcomingLaunches.shared
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return UIStatusBarStyle.lightContent
    }
    
    override func loadView()
    {
        super.loadView()
        //  Add hamburger menu button right side of screen
        hamburgerMenuBtn = UIButton(type: .system)
        hamburgerMenuBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hamburgerMenuBtn)
        
        hamburgerMenuBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24.0).isActive = true
        hamburgerMenuBtn.bottomAnchor .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,  constant: 0.0).isActive = true
        hamburgerMenuBtn.widthAnchor  .constraint(equalToConstant: 40.0).isActive = true
        hamburgerMenuBtn.heightAnchor .constraint(equalToConstant: 40.0).isActive = true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //  Finish UI Setup
        collectionView.backgroundColor  = .clear
        collectionView.decelerationRate = .fast
        
        hamburgerMenuBtn.addTarget(self, action: #selector(showSideMenu), for: .touchUpInside)
        hamburgerMenuBtn.setImage(UIImage(named: "baseline_menu_black_36pt"), for: .normal)
        hamburgerMenuBtn.backgroundColor     = .orange
        hamburgerMenuBtn.tintColor           = .white
        
        hamburgerMenuBtn.layer.masksToBounds = false
        hamburgerMenuBtn.layer.cornerRadius  = 20
        hamburgerMenuBtn.layer.borderWidth   = 5
        hamburgerMenuBtn.layer.borderColor   = UIColor.orange.cgColor
        
        hamburgerMenuBtn.layer.shadowColor   = UIColor( red: 0.0,  green: 0.0, blue: 0.0, alpha: 0.25).cgColor
        hamburgerMenuBtn.layer.shadowOffset  = CGSize(width: 0.0, height: 2.0)
        hamburgerMenuBtn.layer.shadowOpacity = 1.0
        hamburgerMenuBtn.layer.shadowRadius  = 0.0
        
        //  Get launches data
        launches.delegate = self
    }
}

protocol HomeViewControllerDelegate
{
    func toggleSideMenu()
}
