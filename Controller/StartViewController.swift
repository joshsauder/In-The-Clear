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
    @IBOutlet weak var ThirdPartyButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButton(button: LoginButton)
        createButton(button: ThirdPartyButton)
        createButton(button: RegisterButton)
    }
}
