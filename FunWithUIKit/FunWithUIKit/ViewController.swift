//
//  ViewController.swift
//  FunWithUIKit
//
//  Created by AnnElaine on 1/20/26.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var ButtonNotTapped: UIButton!
    @IBOutlet weak var TextLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TextLabel.textColor = .red
    }
    
    @IBAction func SliderChangeText(_ sender: UISlider) {
        if sender.value == 1.0 {
            TextLabel.text = "Full"
        } else if sender.value == 0.0 {
            TextLabel.text = "Zero"
        }
        
    }
    
    @IBAction func ButtonTapped(_ sender: UIButton) {
        TextLabel.text = "Button Tapped"
        TextLabel.textColor = .blue
    }
}

