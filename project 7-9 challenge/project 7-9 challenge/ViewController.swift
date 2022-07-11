//
//  ViewController.swift
//  project 7-9 challenge
//
//  Created by Andrew Emad on 11/07/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lifesLabel: UILabel!
    var words = ["RHYTHM"]
    var currentWord = "RHYTHM"
    @IBOutlet weak var guessLabel: UILabel!
    let guessCharacter = "?"
    var currentGuess = "" {
        didSet {
            guessLabel.text = currentGuess
        }
    }
    var lifes = 7 {
        didSet {
            lifesLabel.text = "lifes: \(lifes)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.loadWords()
        }
        
    }
    func loadWords(){
       if let url = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let fileWords = try? String(contentsOf: url){
                let data = fileWords.components(separatedBy: "\n")
                words += data
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.changeTheWord()
        }
    }
    func initializeUI(){
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(getTheGuess))
        navigationItem.rightBarButtonItem = rightBarButton
        
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeTheWord))
        navigationItem.leftBarButtonItem = leftBarButton
    
    }
    
    @objc func getTheGuess(){
        let alert = UIAlertController(title: "Put a character", message: "wrong input causes you one life", preferredStyle: .alert)
        alert.addTextField()
        let submit = UIAlertAction(title: "Submit", style: .default){ [weak self , weak alert] action in
            guard let text = alert?.textFields?[0].text else {return}
            self?.isPossibleCharacter(text)
        }
        alert.addAction(submit)
        present(alert, animated: true)
    }
    
    @objc func changeTheWord(){
        words.shuffle()
        currentWord = words[0].lowercased()
        title = "\(currentWord.count) letters"
        var pattern = ""
        for _ in 0..<currentWord.count {
            pattern += guessCharacter
        }
        currentGuess = pattern
    }

    func isPossibleCharacter(_ text : String){
        let checkText = text.lowercased()
        var flag = false
        if text.count == 1 {
            var pattern = Array(currentGuess)
            for (index,char) in currentWord.enumerated() {
                if checkText.first == char {
                    pattern[index] = char
                    flag = true
                }
            }
            if flag {
                currentGuess = String(pattern)
                checkTheGuess()
                return
            }
        }
        let alert = UIAlertController(title: "Wrong Guess", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        lifes -= 1
        loseAllLifes()
    }
    
    func checkTheGuess(){
        if !currentGuess.contains("?"){
            let alert = UIAlertController(title: "Congratulations!!", message: "Get a new Word To Guess", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default , handler: alertChangeWordHandler(action:)))
            present(alert, animated: true)
        }
    }
    func loseAllLifes(){
        if lifes == 0 {
            let alert = UIAlertController(title: "Sorry", message: "You Lose the Game", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: alertChangeWordHandler(action:)))
            present(alert, animated: true)
            lifes = 7
        }
    }
    
    func alertChangeWordHandler(action : UIAlertAction){
        changeTheWord()
    }
}

