//
//  UpcomingLaunchCell.swift
//  GoNoGo
//
//  Created by Seth Kurkowski on 4/1/19.
//  Copyright © 2019 Seth Kurkowski. All rights reserved.
//

import UIKit

class UpcomingLaunchCell: UICollectionViewCell
{
    static let reuseIdentifier = String(describing: UpcomingLaunchCell.self)
    
    @IBOutlet weak var         imageView: UIImageView!
    @IBOutlet weak var         imageCoverView: UIView!
    @IBOutlet private weak var missionLbl: UILabel!
    @IBOutlet private weak var lspAndRocketLbl: UILabel!
    @IBOutlet private weak var dateLbl: UILabel!
    @IBOutlet weak var         landing1Lbl: UILabel!
    @IBOutlet weak var         landing2Lbl: UILabel!
    @IBOutlet private weak var locationLbl: UILabel!
    @IBOutlet private weak var customerLbl: UILabel!
    
    var launch: Launch?
    {
        didSet
        {
            if let launch = launch
            {
                missionLbl.text           = launch.mission
                lspAndRocketLbl.text      = (launch.name ?? "Unknown") + " | " + launch.rocket
                dateLbl.text              = launch.netTime
                imageView.backgroundColor = launch.color
                locationLbl.text          = launch.location
                customerLbl.text          = launch.agency
//                if let image = launch.image
//                {
//                    imageView.image  = image
//                }
//                else
//                {
//                    imageView.image = nil
//                }
            }
        }
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes)
    {
        super.apply(layoutAttributes)
        
        //  These are the two convenience height constants that you've used previously.
        let standardHeight = UpcomingLaunchLayout.Cell.standardHeight
        let featuredHeight = UpcomingLaunchLayout.Cell.featuredHeight
        
        //  Calculate the delta of the cell as it's moving to figure out how much to adjust the alpha in the following step.
        let delta = 1 - (
            (featuredHeight - frame.height) / (featuredHeight - standardHeight)
        )
        
        //  Based on the range constants, update the cell's alpha based on the delta value.
        let minAlpha: CGFloat = 0.3
        let maxAlpha: CGFloat = 0.75
        imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
        
        let scale = max(delta, 0.5)
        missionLbl     .transform = CGAffineTransform(scaleX: scale, y: scale)
        lspAndRocketLbl.transform = CGAffineTransform(scaleX: scale, y: scale)
        dateLbl        .transform = CGAffineTransform(scaleX: scale, y: scale)
        locationLbl    .transform = CGAffineTransform(scaleX: scale, y: scale)
        customerLbl    .transform = CGAffineTransform(scaleX: scale, y: scale)
        
        dateLbl    .alpha = delta
        locationLbl.alpha = delta
        customerLbl.alpha = delta
    }
}
