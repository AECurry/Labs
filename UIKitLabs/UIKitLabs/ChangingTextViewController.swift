//
//  ChangingTextViewController.swift
//  FunWithUIKit
//
//  Created by AnnElaine on 1/22/26.
//

import UIKit

class ChangingTextViewController: UIViewController {
    
    @IBOutlet weak var notCoolLabel: UILabel!
    
    @IBOutlet weak var changingTextButtonTapped: UIButton!
    
    
    @IBOutlet weak var nextViewButton: UIButton!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
           
            notCoolLabel.text = "This is not a cool app"
            
            
            notCoolLabel.textAlignment = .center
            
          
        }
    
        @IBAction func changingTextButtonTapped(_ sender: UIButton) {
            notCoolLabel.text = "This is a cool app!"
            notCoolLabel.textAlignment = .center
        }
    }
