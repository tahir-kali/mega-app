//  Tahir Rahimi 28/4/2023

import UIKit

// MARK: - AppDelegate

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: Internal

  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool
  {
    window = UIWindow(frame: UIScreen.main.bounds)
    let demoPickerViewController = DemoPickerViewController()
    let navigationController = UINavigationController(rootViewController: demoPickerViewController)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
    return true
  }

}

