//
//  ViewController.swift
//  FunWithUIKit
//
//  Created by AnnElaine on 1/20/26.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var HelloLabel: UILabel!
    
    
    @IBOutlet weak var TapMeButton: UIButton!
    
    
    @IBOutlet weak var NextViewButton: UIButton!
    
    
    override func viewDidLoad() {
            
            super.viewDidLoad()
        
        HelloLabel.textColor = .red
    }
    
    @IBAction func SliderChangeText(_ sender: UISlider) {
        if sender.value >= 0.99 {  // Better float comparison
            HelloLabel.text = "Full"
        } else if sender.value <= 0.01 {
            HelloLabel.text = "Zero"
        }
    }
    
    
    @IBAction func TapMeButton(_ sender: UIButton) {
        HelloLabel.text = "Button Tapped"
        HelloLabel.textColor = .blue
    }
}
