//
//  ViewController.swift
//  CatchDilo
//
//  Created by Atakan Başaran on 21.09.2023.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var HighscoreLabel: UILabel!
    @IBOutlet weak var ButtonPlay: UIButton!
    
    
    
    var timer = Timer()
    var counter = 0
    var score = 0
    var ImageWidth = [CGFloat]() //Storing three different widths and heights for 3x3 random image generator
    var ImageHeight = [CGFloat]()
    var changePicsTimer = Timer()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ButtonPlay.isHidden = false
        let SavedScore = UserDefaults.standard.object(forKey: "Highscore")
        if let ScoreSave = SavedScore as? Int {
            HighscoreLabel.text = "Highscore: \(ScoreSave)"
        }
        
        counter = 10 //10sec play time
        TimeLabel.text = "Time: \(counter) s"
        ScoreLabel.text = "Score: \(score)"
    }
    
    func SetTimer() { //for play time
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LeftTime), userInfo: nil, repeats: true)
    }
    
    func SetTimer2() { //for random image generator
        changePicsTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(randomPics), userInfo: nil, repeats: true)
    }

  
    
    @objc func LeftTime() {
        
        TimeLabel.text = "Time: \(counter) s"
        counter -= 1
        
        if counter == -1 {
            timer.invalidate()
            changePicsTimer.invalidate()
            
            let SavedScore = UserDefaults.standard.object(forKey: "Highscore")
            if let ScoreSave = SavedScore as? Int {
                
                //Comparison to choose Highscore for saving
                if ScoreSave >= score {
                    UserDefaults.standard.setValue(ScoreSave, forKey: "Highscore")
                    HighscoreLabel.text = "Highscore: \(ScoreSave)"

                } else {
                    UserDefaults.standard.setValue(score, forKey: "Highscore")
                    HighscoreLabel.text = "Highscore: \(score)"
                }
            }
            
            GameOver()
        }
    }
    
    
    func GameOver() {
        
        let alert = UIAlertController(title: "Time's Up", message: "Do you want to play again?", preferredStyle: UIAlertController.Style.alert)
        let NoButton = UIAlertAction(title: "No", style: UIAlertAction.Style.default) { alert in
            self.ButtonPlay.isHidden = false
        }
        let YesButton = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { UIAlertAction in
            self.score = 0
            self.counter = 10
            self.TimeLabel.text = "Time: \(self.counter) s" //For instant changes in the labels after pressing yes button at the end of the game
            self.ScoreLabel.text = "Score: \(self.score)"
            self.ButtonPlay.isHidden = true
            self.SetTimer()
            self.SetTimer2()
        }
        
        alert.addAction(NoButton)
        alert.addAction(YesButton)
        present(alert, animated: true)
    }
    
    
     @objc func randomPics() {
        
        let width = view.frame.size.width
        let height = view.frame.size.height

        ImageWidth = [(width * 0.09), (width * 0.39), (width * 0.69)]
        ImageHeight = [(height * 0.25), (height * 0.43), (height * 0.61)]
         
        //Numbers were calculated roghly according to the Main View and left eqaul spacing among them
        
        
        
        let image = UIImageView(frame: CGRect(x: ImageWidth.randomElement()!, y: ImageHeight.randomElement()!, width: 100, height: 130))
        image.image = UIImage(named: "mcqueen")
        view.addSubview(image)
         
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            image.removeFromSuperview()
            //Removing images that added randomly in the same time with changePicsTimer to create movement feeling
         }

        image.isUserInteractionEnabled = true
        let GestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ClicktoScore))
        image.addGestureRecognizer(GestureRecognizer)
 
    }
    
    @objc func ClicktoScore() { //Increasing Score
        score += 1
        ScoreLabel.text = "Score: \(score)"

    }
    
    
    @IBAction func PlayButton(_ sender: Any) { //To play in the first opening or after choosing No button at the end of the game
        self.score = 0
        self.counter = 10
        self.TimeLabel.text = "Time: \(self.counter) s"
        self.ScoreLabel.text = "Score: \(self.score)"
        SetTimer()
        SetTimer2()
        ButtonPlay.isHidden = true
        
        //Same initilizations with yes button
    }
    
    
    


}

