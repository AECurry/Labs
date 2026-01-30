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
        
       
        changingTextButtonTapped.addTarget(self,        action: #selector(buttonTapped),
            for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        notCoolLabel.text = "This is a cool app!"
    }
}
