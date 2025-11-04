# Live Activities

This directory contains Live Activity implementations for the Home Assistant iOS app.

## Countdown Live Activity

The countdown Live Activity displays a countdown timer that can be shown on the Lock Screen and in the Dynamic Island (on iPhone 14 Pro and later).

### Features

- **Lock Screen Display**: Shows a countdown timer with optional title and icon
- **Dynamic Island Support**: 
  - Expanded view: Icon, title, and countdown timer
  - Compact view: Icon and countdown time
  - Minimal view: Icon only
- **Material Design Icons**: Supports icons from the Material Design Icons library

### Usage

To start a countdown Live Activity:

```swift
let attributes = CountdownActivityAttributes(activityId: "unique-countdown-id")
let contentState = CountdownActivityAttributes.ContentState(
    endTime: Date().addingTimeInterval(300), // 5 minutes from now
    title: "Pizza Timer",
    icon: "mdi:timer"
)

let activity = try Activity<CountdownActivityAttributes>.request(
    attributes: attributes,
    contentState: contentState
)
```

To update the countdown:

```swift
let newContentState = CountdownActivityAttributes.ContentState(
    endTime: Date().addingTimeInterval(180), // 3 minutes from now
    title: "Updated Timer",
    icon: "mdi:timer"
)

await activity.update(using: newContentState)
```

To end the countdown:

```swift
await activity.end(dismissalPolicy: .immediate)
```

### Requirements

- iOS 16.1 or later
- ActivityKit framework

### Integration with Home Assistant

Live Activities can be triggered through:

1. Push notifications with Live Activity payloads
2. App Intents
3. Shortcuts

The notification system can be extended to support starting/updating/ending Live Activities based on server events.
