//
//  Functions.swift
//  GoNoGo
//
//  Created by Seth Kurkowski on 4/26/19.
//  Copyright © 2019 Seth Kurkowski. All rights reserved.
//

import UIKit

extension HomeViewController
{
    //  MARK: IBActions
    @IBAction func showSideMenu()
    {
        delegate?.toggleSideMenu()
    }
}
