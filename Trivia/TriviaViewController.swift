//
//  ViewController.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import UIKit

class TriviaViewController: UIViewController {
  
  @IBOutlet weak var currentQuestionNumberLabel: UILabel!
  @IBOutlet weak var questionContainerView: UIView!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var answerButton0: UIButton!
  @IBOutlet weak var answerButton1: UIButton!
  @IBOutlet weak var answerButton2: UIButton!
  @IBOutlet weak var answerButton3: UIButton!
  
  private var questions = [TriviaQuestion]()
  private var currQuestionIndex = 0
  private var numCorrectQuestions = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addGradient()
    questionContainerView.layer.cornerRadius = 8.0
    // TODO: FETCH TRIVIA QUESTIONS HERE
	  handlerequest()
  }
	
	private func handlerequest() {
		TriviaQuestionService.shared.requestTrueFalse { result in
			switch result {
			case .success(let question):
				DispatchQueue.main.async {
					self.questions.append(contentsOf: question.results)
					self.questions.shuffle()
					self.updateQuestion(withQuestionIndex: 0)
				}
			case .failure(let error):
				print(error)
			}
		}
		
		TriviaQuestionService.shared.requestMultipleChoice { result in
			switch result {
			case .success(let question):
				DispatchQueue.main.async {
					self.questions.append(contentsOf: question.results)
					self.questions.shuffle()
					self.updateQuestion(withQuestionIndex: 0)
				}
			case .failure(let error):
				print(error)
			}
		}
	}
	
	func onlyAlphanumericChar(_ input: String) -> String {
		var allowCharSet = CharacterSet.alphanumerics
		allowCharSet.insert(charactersIn: " ")
		let filteredString = input.unicodeScalars.filter { allowCharSet.contains($0) }
		return String(filteredString)
	}
  
  private func updateQuestion(withQuestionIndex questionIndex: Int) {
    currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
    let question = questions[questionIndex]
	  
	  let filterQuestion = onlyAlphanumericChar(question.question)
	  let filterCorrectAns = onlyAlphanumericChar(question.correctAnswer)
	  let filterIncorrectAns = question.incorrectAnswers.map { onlyAlphanumericChar($0)
	  }
	  
    //questionLabel.text = question.question
    categoryLabel.text = question.category
	  questionLabel.text = filterQuestion
	  
	
    let answers = ([filterCorrectAns] + filterIncorrectAns).shuffled()
	  
	  if question.type == "boolean" {
		  
		  answerButton0.setTitle(answers[0], for: .normal)
		  answerButton1.setTitle(answers[1], for: .normal)
		  answerButton0.backgroundColor = .clear
		  answerButton1.backgroundColor = .clear
		  
		  answerButton2.isHidden = true
		  answerButton3.isHidden = true
		  
	  } else if question.type == "multiple" {
		  if answers.count > 0 {
			answerButton0.setTitle(answers[0], for: .normal)
			  answerButton0.backgroundColor = .clear
		  }
		  if answers.count > 1 {
			answerButton1.setTitle(answers[1], for: .normal)
			answerButton1.isHidden = false
			  answerButton1.backgroundColor = .clear
		  }
		  if answers.count > 2 {
			answerButton2.setTitle(answers[2], for: .normal)
			answerButton2.isHidden = false
			  answerButton2.backgroundColor = .clear
		  }
		  if answers.count > 3 {
			answerButton3.setTitle(answers[3], for: .normal)
			answerButton3.isHidden = false
			  answerButton3.backgroundColor = .clear
		  }
	  }
  }
  
  private func updateToNextQuestion(answer: String) {
    if isCorrectAnswer(answer) {
      numCorrectQuestions += 1
    }
    currQuestionIndex += 1
    guard currQuestionIndex < questions.count else {
      showFinalScore()
      return
    }
    updateQuestion(withQuestionIndex: currQuestionIndex)
  }
  
  private func isCorrectAnswer(_ answer: String) -> Bool {
    return answer == questions[currQuestionIndex].correctAnswer
  }
  
  private func showFinalScore() {
    let alertController = UIAlertController(title: "Game over!",
                                            message: "Final score: \(numCorrectQuestions)/\(questions.count)",
                                            preferredStyle: .alert)
    let resetAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
      currQuestionIndex = 0
      numCorrectQuestions = 0
		//Fetch a different set of question then user restarts
		handlerequest()
    }
    alertController.addAction(resetAction)
    present(alertController, animated: true, completion: nil)
  }
  
  private func addGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                            UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  @IBAction func didTapAnswerButton0(_ sender: UIButton) {
	  guard let text = sender.titleLabel?.text else { return }
	  
	  if isCorrectAnswer(text) {
		  sender.backgroundColor = .green
	  } else {
		  sender.backgroundColor = .red
	  }
	  
	  DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
		  self.updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
	  }
  }
  
  @IBAction func didTapAnswerButton1(_ sender: UIButton) {
	  guard let text = sender.titleLabel?.text else { return }
	  
	  if isCorrectAnswer(text) {
		  sender.backgroundColor = .green
	  } else {
		  sender.backgroundColor = .red
	  }
	  DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
		  self.updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
	  }
  }
  
  @IBAction func didTapAnswerButton2(_ sender: UIButton) {
	  guard let text = sender.titleLabel?.text else { return }
	  
	  if isCorrectAnswer(text) {
		  sender.backgroundColor = .green
	  } else {
		  sender.backgroundColor = .red
	  }
	  DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
		  self.updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
	  }
  }
  
  @IBAction func didTapAnswerButton3(_ sender: UIButton) {
	  guard let text = sender.titleLabel?.text else { return }
	  
	  if isCorrectAnswer(text) {
		  sender.backgroundColor = .green
	  } else {
		  sender.backgroundColor = .red
	  }
	  DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
		  self.updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
	  }
  }
}

