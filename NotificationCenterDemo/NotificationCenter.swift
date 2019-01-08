import Foundation

public class NotificationCenter {
    private static let shared = NotificationCenter()

    private init() { }

    private struct Observation {
        weak var target: AnyObject?
        let action: (Any) -> Void
    }

    private var notificationObservations: [String: [Observation]] = [:]

    private let queue = DispatchQueue(label: "serial")

    public static func addObserver<Payload>(_ target: AnyObject, for notificationName: String, action: @escaping (Payload) -> Void) {
        let observation = Observation(target: target, action: {
            if let payload = $0 as? Payload {
                action(payload)
            } else {
                assertionFailure("Mismatched Payload")
            }
        })
        shared.queue.sync {
            var observations = shared.notificationObservations[notificationName] ?? []
            observations.append(observation)
            shared.notificationObservations[notificationName] = observations
        }
    }

    public static func postNotification<Payload>(name: String, payload: Payload) {
        shared.queue.sync {
            let validObservations = (shared.notificationObservations[name] ?? []).filter({ $0.target != nil })
            validObservations.forEach { $0.action(payload) }
            shared.notificationObservations[name] = validObservations
        }
    }
}
