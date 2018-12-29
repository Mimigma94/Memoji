//
//  ViewController.swift
//  Memoji
//
//  Created by Selina Kröcker on 24.10.18.
//  Copyright © 2018 Selina Piper. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //--------------------------------------------------
    // MARK: - IBOutlets
    //--------------------------------------------------

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet var scoreLabels: [UILabel]!
    @IBOutlet var memoryButtons: [MemoryButton]!
    
    //--------------------------------------------------
    // MARK: - Properties
    //--------------------------------------------------
    
    let emojis = [
        "😃","😘","🤪","😱","🤫",
        "😈","😡","👾","🐹","🐷",
        "🦁","🐨","🐶","🐣","🐥",
        "🙈","🙉","🙊","🌞","🌝",
        "🍺","🍻","⚽️","🏀","🏈",
        "🎾","🎱","😇","😍","😳"
    ]
    
    var playArray = [String]()
    var openCards = [MemoryButton]()
    
    var currentPlayer = 0
    var scores = [0,0]
    
    var gameEnded = false
    //--------------------------------------------------
    // MARK: - Lifecicle
    //--------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabels = scoreLabels.sorted() {
            $0.tag < $1.tag
        }
        memoryButtons = memoryButtons.sorted() {
            $0.tag < $1.tag
        }
        for button in memoryButtons {
            button.setTitleColor(UIColor.clear, for: .normal)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.baselineAdjustment = .alignCenters
        }
        // zeile 48-51 : Emojis werden in den Buttons so groß wie möglich dargestellt
        selectRandomEmojis()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameEnded {
            dismiss(animated: true, completion: nil)
        }
    }

    //--------------------------------------------------
    // MARK: - IBActions
    //--------------------------------------------------
    
    @IBAction func memoryButtonHandler(_ sender: MemoryButton) {
        sender.isEnabled = false
        view.isUserInteractionEnabled = false
        flip(card: sender, show: sender.flipped)
        openCards.append(sender)
        checkOpenCards()
    }
    
    //--------------------------------------------------
    // MARK: - Methods
    //--------------------------------------------------
    
    func selectRandomEmojis() {
        var tempArray = emojis
        tempArray.shuffle()
        for _ in 0..<memoryButtons.count/2 {
            playArray.append(tempArray[0])
            playArray.append(tempArray.removeFirst())
        }
        playArray.shuffle()
        // So werden immer 2 Paar gezeigt s.o.
        for button in memoryButtons {
            button.setTitle(playArray[button.tag], for: .normal)
        }
        // die Tags wurde vorher im Storyboard eingefügt
    }
    
    func flip(card: MemoryButton, show: Bool) {
        UIView.animate(withDuration: 0.5) {
            if show {
                card.transform = CGAffineTransform(scaleX: 1, y: 1)
            } else {
                card.transform = CGAffineTransform(scaleX: -1, y: 1)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
            card.flipped = !card.flipped
        }
    }
    
    func checkOpenCards() {
        if openCards.count < 2 {
            view.isUserInteractionEnabled = true
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
            self.finishRound()
        }
    }
    
    func finishRound() {
        if openCards[0].titleLabel?.text == openCards[1].titleLabel?.text {
            for card in openCards{
                fadeRemove(card: card)
            }
            increaseScore()
        } else {
            for card in openCards {
                flip(card: card, show: card.flipped)
                card.isEnabled = true
            }
            switchPlayers()
        }
        view.isUserInteractionEnabled = true
        openCards.removeAll()
    }
    
    func fadeRemove(card: MemoryButton) {
        UIView.animate(withDuration: 0.5) {
            card.transform = CGAffineTransform(scaleX: -1.2, y: 1.2)
            card.alpha = 0.0
        }
    }
    
    func increaseScore() {
        scores[currentPlayer] += 1
        scoreLabels[currentPlayer].text = "\(scores[currentPlayer])"
        if scores.reduce(0, +) == memoryButtons.count/2 {
            endGame()
            // reduce bilden, durch das +, die SUMME aller Scores
            // Es werden in jeder Runde 2 Karten weggenommen und 1 Punkt vergeben
        }
    }
    
    func switchPlayers() {
        currentPlayer = currentPlayer == 0 ? 1 : 0
        infoLabel.text = "Player \(currentPlayer + 1)`s Turn"
    }
    
    func endGame() {
        gameEnded = true
        if scores[0] < scores[1] {
            infoLabel.text = "Player 2 Won!"
        } else if scores[0] > scores[1] {
            infoLabel.text = "Player 1 Won!"
        } else {
            infoLabel.text = "It's a draw!"
        }
    }
}

extension MutableCollection {
    mutating func shuffle() {
        if count < 2 {
            return
        }
        for i in indices.dropLast() {
            let difference = distance(from: i, to: endIndex)
            let j = index(i, offsetBy: numericCast(arc4random_uniform(numericCast(difference))))
            swapAt(i, j)
        }
    }
}





