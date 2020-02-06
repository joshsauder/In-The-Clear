//
//  StartView.swift
//  InTheClear
//
//  Created by Josh Sauder on 2/2/20.
//  Copyright © 2020 Josh Sauder. All rights reserved.
//

import Foundation
import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    
    @IBOutlet weak var TextView: UIView!
    @IBOutlet weak var ThirdPartyLabel: UILabel!
    @IBOutlet weak var LoginLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButton(button: LoginButton)
        createButton(button: RegisterButton)
        
        setupLabels()
    }
}
