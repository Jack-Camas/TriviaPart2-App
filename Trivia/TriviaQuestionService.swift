//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Jack Camas on 10/10/23.
//

import Foundation
import UIKit


enum TriviaError: Error {
	case inValidUrl
	case clientError
	case serverError
	case decodeError
	case dataError
}

class TriviaQuestionService {
	
	static let shared = TriviaQuestionService()
	
	private var MultipleBaseURL = "https://opentdb.com/api.php?amount=5&category=15&difficulty=easy&type=multiple"
	private var TrueFalseBaseUrl = "https://opentdb.com/api.php?amount=5&category=15&difficulty=easy&type=boolean"
	
	
	func requestMultipleChoice(completion: @escaping (Result<TriviaResponse, TriviaError>) -> Void ) {
		request(endpoint: MultipleBaseURL, completion: completion)
	}
	
	func requestTrueFalse(completion: @escaping (Result<TriviaResponse, TriviaError>) -> Void) {
		request(endpoint: TrueFalseBaseUrl, completion: completion)
	}
	
	private func request(endpoint: String, completion: @escaping (Result<TriviaResponse,TriviaError>) -> Void) {
	
		guard let url = URL(string: endpoint) else {
			completion(.failure(.inValidUrl))
			return
		}
		
		let urlRequest = URLRequest(url: url)
		
		let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
			
			if let _ = error {
				completion(.failure(.clientError))
				return
			}
			
			guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
				completion(.failure(.serverError))
				return
			}
			
			guard let data = data else {
				completion(.failure(.dataError))
				return
			}
			
			//Handle decoding
			do {
				let data = try JSONDecoder().decode(TriviaResponse.self, from: data)
				completion(.success(data))
			} catch {
				completion(.failure(.decodeError))
			}
		}
		task.resume()
	}
}
