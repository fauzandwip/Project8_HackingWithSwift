//
//  ViewController.swift
//  Project8
//
//  Created by Fauzan Dwi Prasetyo on 30/04/23.
//

import UIKit

class ViewController: UIViewController {
    
    var scoreLabel: UILabel!
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var level = 1
    var rightAnswer = 0
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        //        cluesLabel.backgroundColor = .orange
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        //        answersLabel.backgroundColor = .blue
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("Submit", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("Clear", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        //        buttonsView.backgroundColor = .green
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
            
            // pin the top of clues label to the bottom of the score label
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            // pin the leading edge of clues label to the leading edge of our layout margins, adding 100 for some space
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            // make the clues label 60% of the with of our layout margins, minus 100
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            // also pin the top of answers label to the bottom of the score label
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            // make the answers label stick to the trailing edge of our layout margins, minus 100
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            // make the answers label take up 40% of the available space, minus 100
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            // make the answers label match the height of the clues label
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        // values for width and height of each button
        let width = 150
        let height = 80
        
        // create 20 buttons 4x5 grid
        for row in 0..<4 {
            for col in 0..<5 {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.layer.borderColor = CGColor(red: 0, green: 0.8, blue: 1, alpha: 1)
                letterButton.layer.borderWidth = 1
                letterButton.layer.cornerRadius = 20
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                // set title from the button
                //                letterButton.setTitle("WWW", for: .normal)
                
                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                // add it to the buttons views
                buttonsView.addSubview(letterButton)
                
                // add to letterButtons array
                letterButtons.append(letterButton)
            }
        }
    }
    
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        print("trigerred")
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    // full word answer
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    // bit answer
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
            
            
            // configure the buttons and labels
            
            cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
            answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
            
            letterBits.shuffle()
            
            if letterBits.count == letterButtons.count {
                for i in 0..<letterButtons.count {
                    letterButtons[i].setTitle(letterBits[i], for: .normal)
                }
            }
        }
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        
        letterButtonAnimation(sender, alpha: 0)
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }
        
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
            
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            rightAnswer += 1
            
        } else {
            let ac = UIAlertController(title: "Wrong!", message: "Your answer \(answerText) is wrong, Try Again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: wrongAnswer))
            
            present(ac, animated: true)
        }
        
        if rightAnswer == 7 {
            if score >= 5 {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's GO!", style: .default, handler: levelUp))
                
                present(ac, animated: true)
            } else {
                let ac = UIAlertController(title: "Your Total Score: \(score)", message: "You need 5 score to go the next level", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Try Again", style: .default, handler: restart))
                
                present(ac, animated: true)
            }
        }
    }
    
    func wrongAnswer(action: UIAlertAction) {
        if score > 0 {
            score -= 1
        }
        
        clearTapped()
    }
    
    func restart(action: UIAlertAction) {
        reset()
    }
    
    func reset() {
        score = 0
        rightAnswer = 0
        
        currentAnswer.text = ""
        solutions.removeAll(keepingCapacity: true)
        
        loadLevel()
        
        for btn in letterButtons {
            letterButtonAnimation(btn, alpha: 1)
        }
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1

        reset()
    }
    
    @objc func clearTapped(_ sender: UIButton? = nil) {
        currentAnswer.text = ""
        
        for btn in activatedButtons {
            letterButtonAnimation(btn, alpha: 1)
        }
        
        activatedButtons.removeAll()
    }
    
    func letterButtonAnimation(_ btn: UIButton, alpha: Double) {
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            btn.alpha = alpha
        })
    }
    
}

