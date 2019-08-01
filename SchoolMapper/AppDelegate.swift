import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
    
    override init() {
        super.init()
        FirebaseApp.configure()
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //var vc = UIViewController()
        
        if shortcutItem.type == "com.jortberg.SchoolMapper.route" {
            //vc = storyboard.instantiateViewController(withIdentifier: "SourceDestViewController")
            
            //window!.rootViewController?.present(vc, animated: true, completion: nil)

        }
    }
    
    
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
        -> Bool {
            //FirebaseApp.configure()
            return true
    }
    
}
