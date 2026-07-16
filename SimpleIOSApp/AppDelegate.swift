import UIKit
import TDLibKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Заводим мотор (инициализация TDLib)
        _ = TDLibClient.shared
        // Ставим API ключи (это как логин и пароль для двигателя)
        TDLibClient.shared.setApiId(apiId: 2040, apiHash: "b18441a1ff607e10a989891a5462e627")
        return true
    }

    // Остальное не трогаем, оно нужно для работы экранов
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
