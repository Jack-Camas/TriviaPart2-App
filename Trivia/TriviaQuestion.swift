//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import Foundation

struct TriviaResponse: Decodable {
	let results: [TriviaQuestion]
}

struct TriviaQuestion: Decodable {
	let category: String
	let question: String
	let type: String
	let correctAnswer: String
	let incorrectAnswers: [String]
	
	enum CodingKeys: String, CodingKey {
		case category
		case question
		case type
		case correctAnswer = "correct_answer"
		case incorrectAnswers = "incorrect_answers"
	}
}


