import UIKit

class ContainerViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var pageIndex = 0
    private var pageViewController: UIPageViewController?
    var challenge: PFObject?
    
    lazy var _controllers : [UIViewController] = {
        let progressView = self.storyboard?.instantiateViewControllerWithIdentifier("ProgressViewController") as! ProgressViewController
        let dayView = self.storyboard?.instantiateViewControllerWithIdentifier("DayViewController") as! DayViewController
        let formView = self.storyboard?.instantiateViewControllerWithIdentifier("FormViewController") as! FormViewController
        return [dayView, progressView, formView]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "goToViewNotification:", name: "NavigateToNewView", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!UserService.hasSignedUp()) {
            self.goToView(Constants.VIEWS.WelcomeView.rawValue)
        } else {
            ChallengeService.getMyChallenge({ (userChallenge) -> Void in
                print("Challenge: \(userChallenge)")
                self.createPageViewController()
            })
        }
    }
    
    private func createPageViewController() {
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageController") as! UIPageViewController
        pageController.dataSource = self
        
        let firstController = _controllers[0]
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
            print("No known key")
        }
    }
}