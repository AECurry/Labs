//
//  ChangingPicturesViewController.swift
//  FunWithUIKit
//
//  Created by AnnElaine on 1/23/26.
//

import UIKit

class ChangingPicturesViewController: UIViewController {
    
    @IBOutlet weak var dancerImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    let dancers = ["Dancer1", "Dancer2", "Dancer3", "Dancer4", "Dancer5", "Dancer6"]
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRoundedCorners()
        showDancer()
    }
    func setupRoundedCorners() {
        dancerImageView.layer.cornerRadius = 24
        dancerImageView.clipsToBounds = true
        
        nextButton.layer.shadowColor = UIColor.black.cgColor
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        nextButton.layer.shadowOpacity = 0.3
        nextButton.layer.shadowRadius = 4
    }
    
    func showDancer() {
        dancerImageView.image = UIImage(named: dancers[index])
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        index = (index + 1) % dancers.count
        
        // Simple fade animation
        UIView.transition(with: dancerImageView,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: { self.showDancer() },
                          completion: nil)
    }
}
