import ActivityKit
import Shared
import SwiftUI
import WidgetKit

@available(iOS 16.1, *)
struct CountdownLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CountdownActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            CountdownLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here. Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    if let iconName = context.state.icon {
                        CountdownIconHelper.iconImage(named: iconName, size: 24)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.endTime, style: .timer)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 50)
                        .font(.caption2)
                        .monospacedDigit()
                }
                DynamicIslandExpandedRegion(.center) {
                    if let title = context.state.title {
                        Text(title)
                            .font(.caption)
                            .lineLimit(1)
                    }
                }
            } compactLeading: {
                if let iconName = context.state.icon {
                    CountdownIconHelper.iconImage(named: iconName, size: 16)
                }
            } compactTrailing: {
                Text(context.state.endTime, style: .timer)
                    .font(.caption2)
                    .monospacedDigit()
            } minimal: {
                if let iconName = context.state.icon {
                    CountdownIconHelper.iconImage(named: iconName, size: 16)
                }
            }
        }
    }
}

@available(iOS 16.1, *)
private struct CountdownLiveActivityView: View {
    let context: ActivityViewContext<CountdownActivityAttributes>
    
    var body: some View {
        HStack {
            if let iconName = context.state.icon {
                CountdownIconHelper.iconImage(named: iconName, size: 32)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                if let title = context.state.title {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                Text(context.state.endTime, style: .timer)
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .monospacedDigit()
            }
            
            Spacer()
        }
        .padding()
        .activityBackgroundTint(Color.black.opacity(0.3))
    }
}

@available(iOS 16.1, *)
private enum CountdownIconHelper {
    static func iconImage(named iconName: String, size: CGFloat) -> some View {
        let icon = MaterialDesignIcons(named: iconName)
        return Image(uiImage: icon.image(
            ofSize: CGSize(width: size, height: size),
            color: .white
        ))
    }
}

@available(iOS 16.1, *)
struct CountdownLiveActivity_Previews: PreviewProvider {
    static let attributes = CountdownActivityAttributes(activityId: "preview")
    static let contentState = CountdownActivityAttributes.ContentState(
        endTime: Date().addingTimeInterval(300),
        title: "Pizza Timer",
        icon: "mdi:timer"
    )
    
    static var previews: some View {
        Group {
            CountdownLiveActivityView(
                context: ActivityViewContext(
                    state: contentState,
                    attributes: attributes
                )
            )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Lock Screen")
        }
    }
}
