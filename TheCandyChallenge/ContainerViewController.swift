import UIKit

class ContainerViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var pageIndex = 1
    private var pageViewController: UIPageViewController?
    
    lazy var _controllers : [UIViewController] = {
        let progressView = self.storyboard?.instantiateViewControllerWithIdentifier("ProgressViewController") as! ProgressViewController
        let dayView = self.storyboard?.instantiateViewControllerWithIdentifier("DayViewController") as! DayViewController
        let settingsView = self.storyboard?.instantiateViewControllerWithIdentifier("FormViewController") as! SettingsViewController
        return [dayView, progressView, settingsView]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Bootstrap notifcation system
        if Notification.get() == nil {
            let not = Notification(earlyDay: false, lateDay: false)
            not.save()
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = pageViewController {
            return
        }
        
        // add check for has Challenge!
        if (!UserService.hasSignedUp()) {
            self.goToView(Constants.VIEWS.WelcomeView.rawValue)
        } else {
            if let challenge = Challenge.get() {
                checkNotForfeinted(challenge)
                self.createPageViewController()
                return
            }
            
            ChallengeService.sharedInstance.hasChallenge { (challenge) -> Void in
                if challenge == nil {
                    let challenge = ChallengeService.sharedInstance.createChallenge()
                    self.performSegueWithIdentifier("goToChooseEnemies", sender: nil)
                } else {
                    self.createPageViewController()
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToChallengeOver" {
            let vc = segue.destinationViewController as! ChallengeOverViewController
            vc.challenge = sender as! Challenge
        }
    }
    
    private func checkNotForfeinted(challenge: Challenge) {
        if challenge.isForfeinted() {
            performSegueWithIdentifier("goToChallengeOver", sender: challenge)
        }
    }
    
    private func createPageViewController() {
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageController") as! UIPageViewController
        pageController.dataSource = self
        
        let firstController = _controllers[pageIndex]
        let startingViewControllers: NSArray = [firstController]
        pageController.setViewControllers(startingViewControllers as [AnyObject], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }

    func goToViewNotification(notification: NSNotification) {
        let key = notification.userInfo?["key"] as! Int
        goToView(key)
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if viewController.isEqual(_controllers[1]) { return _controllers[0] }
        if viewController.isEqual(_controllers[2]) { return _controllers[1] }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if viewController.isEqual(_controllers[0]) { return _controllers[1] }
        if viewController.isEqual(_controllers[1]) { return _controllers[2] }
        return nil
    }
    
    func goToView(key: Int) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        switch key {
        case Constants.VIEWS.InviteFriendsView.rawValue:
            let vc: InviteFriendsViewController = sb.instantiateViewControllerWithIdentifier("InviteFriends")
                as! InviteFriendsViewController
            self.presentViewController(vc, animated: true, completion: nil)
        case Constants.VIEWS.ProgressView.rawValue:
            let vc: ProgressViewController = sb.instantiateViewControllerWithIdentifier("progress")
                as! ProgressViewController
            self.presentViewController(vc, animated: false, completion: nil)
        case Constants.VIEWS.WelcomeView.rawValue:
            let vc = sb.instantiateViewControllerWithIdentifier("welcome") as! WelcomeViewController
            self.presentViewController(vc, animated: true, completion: nil)
        default:
            println("No known key")
        }
    }
}