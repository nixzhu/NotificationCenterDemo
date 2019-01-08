import UIKit

class ViewController: UIViewController {

    struct Info {
        let text: String
    }

    class User {
        deinit {
            print("deinit")
        }

        func observeInfo() {
            NotificationCenter.addObserver(self, for: "info") { (payload: Info) in
                print("payload:", payload)
            }
        }
    }

    var user: User? = User()

    override func viewDidLoad() {
        super.viewDidLoad()

        user?.observeInfo()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            NotificationCenter.postNotification(name: "info", payload: Info(text: "Hello"))

            self.user = nil

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                NotificationCenter.postNotification(name: "info", payload: Info(text: "World"))
            }
        }
    }
}
