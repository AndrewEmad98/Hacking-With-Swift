//
//  ViewController.swift
//  Project 2
//
//  Created by Andrew Emad on 03/07/2022.
//

import UIKit

class ViewController: UIViewController {



    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var askedQuestions = 0
    var highScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.lightGray.cgColor
        
        button2.layer.borderWidth = 1
        button2.layer.borderColor = UIColor.lightGray.cgColor
        
        button3.layer.borderWidth = 1
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        let defaults = UserDefaults.standard
        highScore = defaults.integer(forKey: "highScore")

        askQuestion()
        
    }
    func askQuestion(alertAction : UIAlertAction! = nil){
        if askedQuestions == 10 {
            if score > highScore {
                highScore = score
                showAlert(title: "Congratulations!! You beat your previous highScore", message: "Your new High Score is \(highScore)", actionTitle: "Reset Game")
                saveNewHighScore()
            }else{
                showAlert(title: "Finished", message: "Your Final score is \(score)",actionTitle: "Reset Game")
            }
            askedQuestions = 0
            score = 0
        }

        
        countries.shuffle()
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        title = countries[correctAnswer].uppercased()
        rightBarButtonItem.title = "score : \(score)"
        askedQuestions += 1
    }

    @IBAction func flagPressed(_ sender: UIButton) {
        
        var title : String
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong it is a flag of \(countries[sender.tag])"
            score -= 1
        }
        let message = "Your Score is \(score)"
        showAlert(title: title, message: message , actionTitle: "Continue")
    }
    
    func showAlert(title : String , message : String , actionTitle : String) {
        let alert = UIAlertController(title: title, message: message , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: askQuestion))
        present(alert, animated: false)
    }
    
    func saveNewHighScore(){
        let defaults = UserDefaults.standard
        defaults.set(highScore, forKey: "highScore")
    }
}

