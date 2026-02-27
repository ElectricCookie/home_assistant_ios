#if os(iOS)
import ActivityKit
import Foundation

@available(iOS 16.1, *)
public struct CountdownActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        /// The end time for the countdown
        public var endTime: Date
        /// Optional title to display
        public var title: String?
        /// Optional icon name (Material Design Icon)
        public var icon: String?

        public init(endTime: Date, title: String? = nil, icon: String? = nil) {
            self.endTime = endTime
            self.title = title
            self.icon = icon
        }
    }

    /// Static identifier for the activity
    public var activityId: String

    public init(activityId: String) {
        self.activityId = activityId
    }
}
#endif
