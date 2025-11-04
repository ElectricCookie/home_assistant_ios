import Foundation
import Testing
@testable import Widgets

@available(iOS 16.1, *)
struct CountdownActivityAttributesTests {
    @Test func initializesWithActivityId() {
        let attributes = CountdownActivityAttributes(activityId: "test-countdown")
        #expect(attributes.activityId == "test-countdown")
    }
    
    @Test func contentStateInitializesWithEndTime() {
        let endTime = Date(timeIntervalSinceNow: 300)
        let contentState = CountdownActivityAttributes.ContentState(
            endTime: endTime,
            title: "Test Timer",
            icon: "mdi:timer"
        )
        
        #expect(contentState.endTime == endTime)
        #expect(contentState.title == "Test Timer")
        #expect(contentState.icon == "mdi:timer")
    }
    
    @Test func contentStateInitializesWithDefaultValues() {
        let endTime = Date(timeIntervalSinceNow: 60)
        let contentState = CountdownActivityAttributes.ContentState(endTime: endTime)
        
        #expect(contentState.endTime == endTime)
        #expect(contentState.title == nil)
        #expect(contentState.icon == nil)
    }
    
    @Test func contentStateIsHashable() {
        let endTime = Date(timeIntervalSinceNow: 300)
        let contentState1 = CountdownActivityAttributes.ContentState(
            endTime: endTime,
            title: "Timer",
            icon: "mdi:timer"
        )
        let contentState2 = CountdownActivityAttributes.ContentState(
            endTime: endTime,
            title: "Timer",
            icon: "mdi:timer"
        )
        
        #expect(contentState1.hashValue == contentState2.hashValue)
    }
}
