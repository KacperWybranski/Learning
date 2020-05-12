//
//  QuestionWithAnswers.swift
//  macapp01
//
//  Created by test on 12/05/2020.
//  Copyright © 2020 test. All rights reserved.
//

import Cocoa

class QuestionWithAnswers: NSObject {
    var text: String
    var answerA: String
    var answerB: String
    var correctAnswer: Int
    
    init(ask: String, a: String, b: String, correct: Int) {
        self.text = ask
        self.answerA = a
        self.answerB = b
        self.correctAnswer = correct
    }
}
