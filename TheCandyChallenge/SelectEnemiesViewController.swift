import UIKit

class SelectEnemiesViewController: UIViewController {
    var challenge: Challenge!
    var fromWelcomeView: Bool?
    
    @IBOutlet weak var counterChockolade: UILabel!
    @IBOutlet weak var counterSoda: UILabel!
    
    @IBAction func didPressDone(sender: AnyObject) {
        ChallengeService.sharedInstance.updateChallengeWithEnemies(challenge)
        
        if fromWelcomeView == true {
            performSegueWithIdentifier("goToContainerView", sender: nil)
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func didPressDecreaseChockolade(sender: AnyObject) {
        if let enemy = getEnemy(Enemies.chocklade) {
            enemy.amount--
        }
        self.updateView()
    }

    @IBAction func didPressIncreaseChockolade(sender: AnyObject) {
        if let enemy = getEnemy(Enemies.chocklade) {
            enemy.amount++
        } else {
            createChockoladeEnemy()
        }
        self.updateView()
    }
    
    @IBAction func didPressIncreaseSoda(sender: AnyObject) {
        if let enemy = getEnemy(Enemies.soda) {
            enemy.amount++
        } else {
            createSodaEnemy()
        }
        self.updateView()
    }
    
    @IBAction func didPressDecreaseSoda(sender: AnyObject) {
        if let enemy = getEnemy(Enemies.soda) {
            enemy.amount--
        }
        self.updateView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let storedChallenge = Challenge.get() {
            self.challenge = storedChallenge
        }
        updateView()
    }
    
    private func updateView() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            for enemy in self.challenge.enemies {
                switch enemy.type {
                case Enemies.chocklade.rawValue:
                    self.setChockladeView(enemy)
                case Enemies.soda.rawValue:
                    self.setSodaView(enemy)
                default:
                    println("enemy not mapped out")
                }
            }
        })
    }
    
    private func getEnemy(type: Enemies) -> Enemy? {
        for enemy in self.challenge.enemies {
            if enemy.type == type.rawValue {
                return enemy
            }
        }
        return nil
    }
    
    private func createChockoladeEnemy() {
        challenge.enemies.append(Enemy(type: Enemies.chocklade.rawValue, date: NSDate(), amount: 1))
    }

    private func createSodaEnemy() {
        challenge.enemies.append(Enemy(type: Enemies.soda.rawValue, date: NSDate(), amount: 1))
    }
    
    private func setChockladeView(enemy: Enemy) {
        counterChockolade.text = "\(enemy.amount)"
    }
    
    private func setSodaView(enemy: Enemy) {
        counterSoda.text = "\(enemy.amount)"
    }
}
