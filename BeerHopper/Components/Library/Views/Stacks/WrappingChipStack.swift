//
//  WrappingChipStack.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/19/25.
//

import SwiftUI

struct WrappingChipStack: View {
    
    let configs: [ButtonConfig]
    
    var body: some View {
        SwiftUICustomTagListView(configs.map({ config in
            SwiftUICustomTagView {
                TextChip(buttonConfig: config)
            }
        }), horizontalSpace: 12, verticalSpace: 12)
    }
    
}


#Preview {
    WrappingChipStack(
        configs:  [
            ButtonConfig(
                id: UUID().uuidString,
                title: "Button 1",
                icon: Image(systemName: "lock"),
                action: {
                    print("Button 1")
                }
            ),
            ButtonConfig(
                id: UUID().uuidString,
                title: "Button 2",
                icon: nil,
                action: {
                    print("Button 2")
                }
            ),
            ButtonConfig(
                id: UUID().uuidString,
                title: "Button 3",
                icon: nil,
                action: {
                    print("Button 2")
                }
            ),
            ButtonConfig(
                id: UUID().uuidString,
                title: "Button 4",
                icon: nil,
                action: {
                    print("Button 2")
                }
            ),
            ButtonConfig(
                id: UUID().uuidString,
                title: "Button 5",
                icon: nil,
                action: {
                    print("Button 2")
                }
            )
        ]
    )
}
