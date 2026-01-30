//
//  ChangingPicturesViewController.swift
//  FunWithUIKit
//
//  Created by AnnElaine on 1/23/26.
//

import UIKit

class ChangingPicturesViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextImageButton: UIButton!
        let dancers = ["Dancer1", "Dancer2", "Dancer3", "Dancer4", "Dancer5", "Dancer6"]
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set content mode so image fills the square
        imageView.contentMode = .scaleAspectFill
        
        showDancer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupRoundedCorners()
    }
    
    func setupRoundedCorners() {
        // Use proportional corner radius
        let cornerRadius = min(imageView.frame.height, imageView.frame.width) * 0.1
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = true
        
        // Optional border
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.systemPurple.cgColor
    }
    
    func showDancer() {
        print("Showing dancer \(index): \(dancers[index])")
        
        if let image = UIImage(named: dancers[index]) {
            imageView.image = image
            print("✓ Image loaded")
        } else {
            print("✗ Image NOT found: \(dancers[index])")
            // Fallback
            imageView.image = UIImage(systemName: "photo")
        }
    }
    
    @IBAction func nextImageButton(_ sender: UIButton) {
        print("=== BUTTON TAPPED ===")
        
        // Change index
        index = (index + 1) % dancers.count
        
        // Update image
        showDancer()
        
        // Animation
        UIView.transition(with: imageView,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {},
                          completion: nil)
    }
}
