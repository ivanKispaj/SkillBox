//
//  ViewController.swift
//  M21_Homework
//
//  Created by Maxim Nikolaev on 15.02.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private var randomX: Int = 0
    private var randomY: Int = 0
    private var score: Int = 0
    private var timeSecond: Int = Constants.timeGame
    private var countFishes: Int = Constants.countFishes
    
    private lazy var timeGameLabel: UILabel =
    {
        let label = UILabel()
        label.text = String(timeSecond)
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.layer.opacity = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private lazy var scoreLabel: UILabel =
    {
        let label = UILabel()
        label.text = String(score)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var busket: UIView = {
        let image = UIImage(named: "Red_Basket")
        let imageview = UIImageView(image: image)
        imageview.contentMode = .scaleAspectFit
        var view = UIView()
        view.frame = CGRect( x: Int(self.view.safeAreaLayoutGuide.layoutFrame.maxX - 100), y: Int(self.view.safeAreaLayoutGuide.layoutFrame.minY + 50), width: 80, height: 80)
        
        view.addSubview(imageview)
        view.addSubview(scoreLabel)
        imageview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageview.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageview.heightAnchor.constraint(equalToConstant: 70),
            imageview.widthAnchor.constraint(equalTo: imageview.heightAnchor, multiplier: 1 / 1),
            scoreLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            scoreLabel.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor),
            scoreLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -10)
        ])
        return view
    }()
    
    private var fishes: [UIImageView] = []
    
    private var timer: DispatchSourceTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tap)
        
        let backImage = UIImage(named: "ocean") ?? UIImage()
        view.backgroundColor = UIColor(patternImage: backImage)
        view.addSubview(busket)
        view.addSubview(timeGameLabel)
        NSLayoutConstraint.activate([
            timeGameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            timeGameLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        setUpGameScene()
        
    }
    
    
    
    @objc func didTap(_ gesture: UITapGestureRecognizer) {
        
        if fishes.count > 0
        {
            
            var сaught: [Int] = []
            for fish in fishes
            {
                let tapLocation = gesture.location(in: fish.superview)
                if (fish.layer.presentation()?.frame.contains(tapLocation))! {
                    print("fish tapped!")
                    сaught.append(fish.tag)
                } else
                {
                    setRandomXY()
                    fish.movedRandom(x: randomX, y: randomY)
                    
                }
            }
            
            for tapCaught in сaught
            {
                if let indexDelete = self.fishes.firstIndex(where: {$0.tag == tapCaught})
                {
                    let fish = self.fishes.remove(at: indexDelete)
                    fishCatchedAnimation(fishСaught: fish)
                }
            }
            if fishes.isEmpty
            {
                timer?.cancel()
                timer = nil
                getAlertEndGame(text: "Congratulation!", message: "All the fish are caught. Do you want again?")
            }
        } else
        {
            timer?.cancel()
            timer = nil
            getAlertEndGame(text: "Congratulation!", message: "All the fish are caught. Do you want again?")
        }
        
    }
    
    func fishCatchedAnimation( fishСaught: UIImageView) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.4) {
            fishСaught.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            fishСaught.frame = self.busket.frame
            
        } completion: { res in
            if res{
                UIView.animate(withDuration: 0.5, delay: 1) {
                    fishСaught.removeFromSuperview()
                    self.score += 1
                    self.scoreLabel.text = String(self.score)
                }
            }
            
        }
        
    }
    
    private func setRandomXY()
    {
        randomX = Int.random(in: 0...Int(self.view.frame.maxX - 100))
        randomY = Int.random(in: Int(self.view.safeAreaLayoutGuide.layoutFrame.minY)...Int(self.view.safeAreaLayoutGuide.layoutFrame.maxY - 100))
        
        
    }
    
    private func getFish() -> UIImageView
    {
        let image = UIImage(named: "fish")
        let view = UIImageView(image: image)
        setRandomXY()
        view.frame = CGRect( x: randomX, y: randomY, width: 100, height: 100)
        view.contentMode = .scaleAspectFit
        return view
    }
    
    private func setUpGameScene()
    {
        
        score = 0
        timeSecond = Constants.timeGame
        scoreLabel.text = String(score)
        timeGameLabel.text = String(timeSecond)
        for numTag in 0...self.countFishes - 1
        {
            setRandomXY()
            let appendFish = getFish()
            appendFish.tag = numTag
            fishes.append(appendFish)
            view.addSubview(fishes[numTag])
        }
        setTimer()
        timer?.resume()
    }
    
    private func getAlertEndGame(text: String, message: String)
    {

        let alert = UIAlertController(title: text, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.setUpGameScene()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    
    private func setTimer()
    {
        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.schedule(deadline: .now(), repeating: 1.0)
        
        timer?.setEventHandler { [weak self] in
            if let self = self
            {
              
                self.timeSecond -= 1
                if self.timeSecond <= 0
                {
                    self.timer?.cancel()
                    self.timer = nil
                    for fish in fishes
                    {
                        fish.removeFromSuperview()
                        
                    }
                    fishes = []
                    self.getAlertEndGame(text: "Game Over!", message: "Time is out. Do you want again?")
                } else
                {
                    self.timeGameLabel.text = String(timeSecond)
                }
            }
            
        }
    }
    
    
}

extension UIImageView
{
    func movedRandom(x: Int, y: Int)
    {
        UIView.animate(withDuration: 0.3) {
            self.center = CGPoint(x: x, y: y)
        }
    }
}
