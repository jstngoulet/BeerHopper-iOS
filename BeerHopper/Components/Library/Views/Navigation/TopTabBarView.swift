//
//  TopTabBarView.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/17/25.
//

import SwiftUI

struct TopTabBarView: View {
    
    struct TabBarItem: Identifiable {
        var title: String
        var view: AnyView
        var icon: Image?
        var id: String
        
        init<V: View>(title: String, view: V, icon: Image? = nil, id: String) {
            self.title = title
            self.view = AnyView(view)
            self.icon = icon
            self.id = id
        }
    }
    
    @Binding
    private var selectedTab: Int
    
    //  Tabs should be passed in
    private let tabs: [TabBarItem]
    
    init(selected: Binding<Int>, tabs: [TabBarItem]) {
        self._selectedTab = selected
        self.tabs = tabs
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(tabs.indices, id: \.self) { idx in
                    
                    Button(action: {
                        selectedTab = idx
                    }) {
                        HStack {
                            if let icon = tabs[idx].icon {
                                icon
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 16, height: 16)
                            }
                            
                            Text(tabs[idx].title)
                                .fontWeight(.bold)
                        }.frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .foregroundStyle(
                        selectedTab == idx
                        ? Theme.Colors.primary
                        : Theme.Colors.secondary
                    )
                    .frame(maxWidth: .infinity)
                    .background(
                        selectedTab == idx
                        ? Theme.Colors.background
                        : Theme.Colors.paper
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            Divider()
            
            tabs[selectedTab].view
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
}

#Preview {
    
    struct PreviewWrapper: View {
        
        @State
        private var selectedTabIndex: Int = 0
        
        var body: some View {
            TopTabBarView(
                selected: $selectedTabIndex,
                tabs: [
                    TopTabBarView.TabBarItem(
                        title: "Tab 1",
                        view: Text("Tab 1"),
                        icon: Image(systemName: "house"),
                        id: "a"
                    ),
                    TopTabBarView.TabBarItem(
                        title: "Tab 2",
                        view: Text("Tab 2"),
                        icon: Image(systemName: "person"),
                        id: "b"
                    ),
                    TopTabBarView.TabBarItem(
                        title: "Tab 3",
                        view: Text("Tab 3"),
                        icon: Image(systemName: "lock"),
                        id: "c"
                    ),
                ]
            )
        }
    }
    
    return PreviewWrapper()
}
