import Foundation
import UIKit

class LocalNotificationService {
    
    static func createUiLocalNotification(date: NSDate, title: String, body: String, category: String? = nil) {
        let notification = UILocalNotification()
        notification.alertBody = body
        notification.alertTitle = title
        notification.fireDate = date
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.category = category
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    static func registerForNotification() {
        let notificationSettings: UIUserNotificationSettings! = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        if (notificationSettings.types != UIUserNotificationType.None){
            return
        }
        
        let action1 = UIMutableUserNotificationAction()
        action1.activationMode = UIUserNotificationActivationMode.Background
        action1.title = "No candy for me"
        action1.identifier = notificationActionOneIdent
        action1.destructive = false
        action1.authenticationRequired = false
        
        let action2 = UIMutableUserNotificationAction()
        action2.activationMode = UIUserNotificationActivationMode.Background
        action2.title = "I failed today :("
        action2.identifier = notificationActionTwoIdent
        action2.destructive = true
        action2.authenticationRequired = false
        
        let actionCategory = UIMutableUserNotificationCategory()
        actionCategory.identifier = notificationCategoryIdent
        actionCategory.setActions([action2, action1], forContext: UIUserNotificationActionContext.Minimal)
        
        let categories: Set<UIUserNotificationCategory> = [actionCategory]
        let types = UIUserNotificationType.Alert | UIUserNotificationType.Sound
        let settings = UIUserNotificationSettings(forTypes: types, categories: categories)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
}