//
//  ViewController.swift
//  Project 5
//
//  Created by Andrew Emad on 05/07/2022.
//

import UIKit

class ViewController: UITableViewController {

    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readData()
        initializeUI()
        startGame()
    }
    
    func readData(){
        /*if let resourcePath = Bundle.main.path(forResource: "start", ofType: "txt"){
            if let fileData = try? String(contentsOfFile: resourcePath) {
                allWords = fileData.components(separatedBy: "\n")
            }
        }*/
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let words = try? String(contentsOf: startWordsUrl){
                allWords = words.components(separatedBy: "\n")
            }
        } else {
            allWords = ["silkworm"]
        }
    
    }
    
    func initializeUI(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(userInput))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
    }
    
    @objc func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll()
        tableView.reloadData()
    }

    @objc func userInput(){
        let ac = UIAlertController(title: "Input a word", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default){ [weak self , weak ac] _ in
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer: answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(answer : String){
        let lowerAnswer = answer.lowercased()
        if validateAnswer(answer: lowerAnswer){
            usedWords.insert(lowerAnswer, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    func validateAnswer(answer : String) -> Bool {
        var errorTitle : String
        var errorHappened : Bool = false
        if answer.isEmpty {
            errorTitle = "Can't use empty word as an anagram"
            errorHappened = true
        }else if answer == title! || answer.count < 3 {
            errorTitle = "Can't use the same base word or a word with less than 3 letters"
            errorHappened = true
        }else {
            if isOriginal(word: answer){
                if isPossible(word: answer){
                    if isReal(word: answer){
                        return true
                    }else {
                        errorHappened = true
                        errorTitle = "Word isn't real english word"
                    }
                }else {
                    errorHappened = true
                    errorTitle = "Word isn't anagram from \(self.title ?? "")"
                }
            }else {
                errorHappened = true
                errorTitle = "Word is used before"
            }
        }
        
        if errorHappened {
            makeErrorAlert(errorTitle: errorTitle)
        }
        return false
    }
    func makeErrorAlert(errorTitle : String){
        let alert = UIAlertController(title: errorTitle, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    func isOriginal(word : String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isPossible(word : String) -> Bool {
        if var baseWord = self.title?.lowercased() {
            for char in word {
                guard let index = baseWord.firstIndex(of: char) else {return false}
                baseWord.remove(at: index)
            }
            return true
        }
        return false
    }
    
    func isReal(word : String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    

}

