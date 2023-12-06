//
//  SceneDelegate.swift
//  TGLiveScan
//
//  Created by apple on 11/16/23.
//

import UIKit
let objSceneDelegate = SceneDelegate.sceneDelegateObject()

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var navigationController : UINavigationController?
    
    //MARK: - Shared object
    private static var sceneDelegateManager: SceneDelegate = {
        let manager = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        return manager!
    }()
    
    // MARK: - Accessors
    class func sceneDelegateObject() -> SceneDelegate {
        return sceneDelegateManager
    }


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        self.window?.overrideUserInterfaceStyle = .light
        self.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    func start() {
        let userDataModel = UserDefaultManager.share.getModelDataFromUserDefults(userData: GetScanEventResponse.self, key: .userAuthData)
        if (userDataModel?.info?.masterId?.isEmpty) ?? true {
            showLogin()
        } else {
            showDashboard()
        }
    }
    func showLogin() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "ScanEventNav") as? UINavigationController
        let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "ScanEventVC") as! ScanEventVC
        navigationController!.viewControllers = [rootViewController]
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    func showDashboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let navController = storyboard.instantiateViewController(withIdentifier: "DashboardNav") as? UINavigationController
        let navControllerTicketTypeVC = storyboard.instantiateViewController(withIdentifier: "ScanEventNav") as? UINavigationController
        let rootViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "ScannerVC") as! ScannerVC
        navController!.viewControllers = [rootViewController]
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
}
