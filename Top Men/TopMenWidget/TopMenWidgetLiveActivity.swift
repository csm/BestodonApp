//
//  TopMenWidgetLiveActivity.swift
//  TopMenWidget
//
//  Created by Casey Marshall on 3/3/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TopMenWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TopMenWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TopMenWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TopMenWidgetAttributes {
    fileprivate static var preview: TopMenWidgetAttributes {
        TopMenWidgetAttributes(name: "World")
    }
}

extension TopMenWidgetAttributes.ContentState {
    fileprivate static var smiley: TopMenWidgetAttributes.ContentState {
        TopMenWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TopMenWidgetAttributes.ContentState {
         TopMenWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TopMenWidgetAttributes.preview) {
   TopMenWidgetLiveActivity()
} contentStates: {
    TopMenWidgetAttributes.ContentState.smiley
    TopMenWidgetAttributes.ContentState.starEyes
}
