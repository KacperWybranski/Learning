//
//  ViewController.swift
//  macapp01
//
//  Created by test on 10/05/2020.
//  Copyright © 2020 test. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet var endMessageLabel: NSTextField!
    @IBOutlet var leftButton: NSButton!
    @IBOutlet var rightButton: NSButton!
    @IBOutlet var questionLabelText: NSTextFieldCell!
    @IBOutlet var endMessageLabelText: NSTextFieldCell!
    @IBOutlet var scoreLabelText: NSTextFieldCell!
    var score: Int = 0 {
        didSet {
            scoreLabelText.title = "Score: \(score)"
        }
    }
    
    var questionsFileLines = [String]()
    var allQuestions = [QuestionWithAnswers]()
    var correctAnswerTag = Int()
    let endTextsGood: [String] = ["Dobra odpowiedź! :)","Nieźle :O","Dobry jesteś :)","Oby tak dalej!"]
    let endTextsBad: [String] = ["Niestety nie udało się :(","Zła odpowiedź :(","Może następnym razem?","Niepoprawna odpowiedź!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        score = 0
        
        if let questionsFileURL = Bundle.main.url(forResource: "pytania", withExtension: ".txt") {
            if let questionsFile = try? String(contentsOf: questionsFileURL) {
                questionsFileLines = questionsFile.components(separatedBy: "\n")
                
                for line in questionsFileLines {
                    let components = line.components(separatedBy: "|")
                    
                    let correct = Int(components[3]) ?? 0
                    let question = QuestionWithAnswers(ask: components[0], a: components[1], b: components[2], correct: correct)
                    allQuestions += [question]
                }
            }
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [CGColor.init(red: 0.7, green: 0.7, blue: 0.4, alpha: 1),CGColor.init(red: 0.1, green: 0.9, blue: 0.8, alpha: 1)]
        view.layer = gradientLayer
        
        let buttonLayerLeft = CALayer()
        buttonLayerLeft.frame = leftButton.bounds
        buttonLayerLeft.backgroundColor = CGColor.init(red: 1, green: 0.3, blue: 0.4, alpha: 0.9)
        leftButton.layer = buttonLayerLeft
        leftButton.action = #selector(buttonTapped)
        
        let buttonLayerRight = CALayer()
        buttonLayerRight.frame = leftButton.bounds
        buttonLayerRight.backgroundColor = CGColor.init(red: 1, green: 0.3, blue: 0.4, alpha: 0.9)
        rightButton.layer = buttonLayerRight
        rightButton.action = #selector(buttonTapped)
        
        newGame()
    }
    
    func newGame() {
        guard let currentQuestion = allQuestions.randomElement() else { return }
        
        endMessageLabel.isHidden = true
        questionLabelText.title = currentQuestion.text
        leftButton.title = currentQuestion.answerA
        rightButton.title = currentQuestion.answerB
        correctAnswerTag = currentQuestion.correctAnswer
    }
    
    @objc func buttonTapped(_ sender: NSButton) {
        if sender.tag == correctAnswerTag {
            endMessageLabelText.title = endTextsGood.randomElement() ?? "Nice :)"
            score += 1
        } else {
            endMessageLabelText.title = endTextsBad.randomElement() ?? "Kiepsko :("
        }
        endMessageLabel.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.newGame()
        }
    }


}

