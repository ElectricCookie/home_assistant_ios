import ActivityKit
import Foundation
import Shared

/// Manages Live Activities triggered by push notifications (chronometer notifications)
@available(iOS 16.1, *)
final class LiveActivityManager {
    static let shared = LiveActivityManager()
    
    private init() {}
    
    /// Handles a push notification payload, starting/updating a Live Activity if it is a chronometer notification.
    /// - Parameters:
    ///   - userInfo: The push notification user info dictionary
    func handlePushNotification(userInfo: [AnyHashable: Any]) {
        guard
            let chronometer = userInfo["chronometer"] as? Bool,
            chronometer == true,
            let whenValue = userInfo["when"]
        else { return }
        
        let endTime = parseEndTime(whenValue)
        guard let endTime else {
            Current.Log.error("LiveActivityManager: could not parse 'when' value: \(whenValue)")
            return
        }
        
        // Get the title from APS alert
        let title: String? = (userInfo["aps"] as? [String: Any])
            .flatMap { $0["alert"] as? [String: Any] }
            .flatMap { $0["title"] as? String }
        let icon = userInfo["icon"] as? String
        let tag = userInfo["tag"] as? String
        
        let contentState = CountdownActivityAttributes.ContentState(
            endTime: endTime,
            title: title,
            icon: icon
        )
        
        Task {
            await startOrUpdate(
                activityId: tag ?? UUID().uuidString,
                contentState: contentState
            )
        }
    }
    
    /// Ends all running countdown Live Activities, or only the one matching the given tag.
    func endActivity(tag: String? = nil) {
        Task {
            for activity in Activity<CountdownActivityAttributes>.activities {
                if let tag, activity.attributes.activityId != tag {
                    continue
                }
                await activity.end(nil, dismissalPolicy: .immediate)
            }
        }
    }
    
    // MARK: - Private helpers
    
    private func startOrUpdate(
        activityId: String,
        contentState: CountdownActivityAttributes.ContentState
    ) async {
        // Check if an activity with this id already exists
        if let existing = Activity<CountdownActivityAttributes>.activities
            .first(where: { $0.attributes.activityId == activityId }) {
            await existing.update(
                ActivityContent(state: contentState, staleDate: contentState.endTime.addingTimeInterval(60))
            )
            Current.Log.info("LiveActivityManager: updated activity \(activityId)")
        } else {
            do {
                let attributes = CountdownActivityAttributes(activityId: activityId)
                let content = ActivityContent(
                    state: contentState,
                    staleDate: contentState.endTime.addingTimeInterval(60)
                )
                let activity = try Activity<CountdownActivityAttributes>.request(
                    attributes: attributes,
                    content: content,
                    pushType: nil
                )
                Current.Log.info("LiveActivityManager: started activity \(activity.id) for \(activityId)")
            } catch {
                Current.Log.error("LiveActivityManager: failed to start activity: \(error)")
            }
        }
    }
    
    private func parseEndTime(_ value: Any) -> Date? {
        if let interval = value as? TimeInterval {
            // Unix timestamp in seconds
            return Date(timeIntervalSince1970: interval)
        }
        
        if let intervalInt = value as? Int {
            // Unix timestamp in seconds
            return Date(timeIntervalSince1970: TimeInterval(intervalInt))
        }
        
        if let string = value as? String {
            // Try ISO8601
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = formatter.date(from: string) {
                return date
            }
            formatter.formatOptions = [.withInternetDateTime]
            if let date = formatter.date(from: string) {
                return date
            }
        }
        
        return nil
    }
}
