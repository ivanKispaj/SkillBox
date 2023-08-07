//
//  ViewController.swift
//  M21_Homework
//
//  Created by Maxim Nikolaev on 15.02.2022.
//

import UIKit

class ViewController: UIViewController {

    lazy var fish: UIImageView = {
        let image = UIImage(named: "fish")
        let view = UIImageView(image: image)
        view.frame = CGRect( x: 0, y: 0, width: 200, height: 200)
        view.contentMode = .scaleAspectFit
        return view
    }()
            
    var isFishCatched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tap)
        
        let backImage = UIImage(named: "ocean") ?? UIImage()
        view.backgroundColor = UIColor(patternImage: backImage)
        view.addSubview(fish)
        moveLeft()
    }
    
    func moveLeft() {
      if isFishCatched { return }
      
      UIView.animate(withDuration: 1.0,
                     delay: 2.0,
                     options: [.curveEaseInOut , .allowUserInteraction],
                     animations: {
                      self.fish.center = CGPoint(x: 150, y: 400)
      },
                     completion: { finished in
                      print("fish moved left!")
                      self.moveRight()
      })
    }
    
    
    func moveRight() {
        // Здесь должен быть ваш код
    }
    
    func moveTop() {
        // Здесь должен быть ваш код
    }
    
    func moveBottom() {
        // Здесь должен быть ваш код
    }
    
    @objc func didTap(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: fish.superview)
        if (fish.layer.presentation()?.frame.contains(tapLocation))! {
            print("fish tapped!")
            if isFishCatched { return }
            isFishCatched = true
            fishCatchedAnimation()
        }
    }
    
    func fishCatchedAnimation() {
    }
}

