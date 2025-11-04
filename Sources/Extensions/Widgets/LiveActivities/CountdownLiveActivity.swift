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
                        let icon = MaterialDesignIcons(named: iconName)
                        Image(uiImage: icon.image(
                            ofSize: CGSize(width: 24, height: 24),
                            color: .white
                        ))
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(timerInterval: Date.now...context.state.endTime, countsDown: true)
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
                    let icon = MaterialDesignIcons(named: iconName)
                    Image(uiImage: icon.image(
                        ofSize: CGSize(width: 16, height: 16),
                        color: .white
                    ))
                }
            } compactTrailing: {
                Text(timerInterval: Date.now...context.state.endTime, countsDown: true)
                    .font(.caption2)
                    .monospacedDigit()
            } minimal: {
                if let iconName = context.state.icon {
                    let icon = MaterialDesignIcons(named: iconName)
                    Image(uiImage: icon.image(
                        ofSize: CGSize(width: 16, height: 16),
                        color: .white
                    ))
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
                let icon = MaterialDesignIcons(named: iconName)
                Image(uiImage: icon.image(
                    ofSize: CGSize(width: 32, height: 32),
                    color: .white
                ))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                if let title = context.state.title {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                Text(timerInterval: Date.now...context.state.endTime, countsDown: true)
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
