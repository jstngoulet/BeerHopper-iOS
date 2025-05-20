//
//  ZeroStateView.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/17/25.
//
import SwiftUI
import DesignSystem

final class ZeroStateViewModel: ObservableObject {
    
    @Published
    var image: Image?
    
    @Published
    var title: String?
    
    @Published
    var buttons: [ButtonConfig]?
    
    init(
        image: Image? = nil,
        title: String? = nil,
        buttons: [ButtonConfig]? = nil
    ) {
        self.image = image
        self.title = title
        self.buttons = buttons
    }
}

struct ZeroStateView: View {
    
    @StateObject
    private var viewModel: ZeroStateViewModel = ZeroStateViewModel()
    
    init(viewModel: ZeroStateViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            if let image = viewModel.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .padding(.bottom, 16)
            }
            
            if let title = viewModel.title {
                Text(title)
                    .font(Theme.Fonts.heading)
                    .fontWeight(.bold)
                    .foregroundStyle(Theme.Colors.textPrimary)
            }
            
            if let buttons = viewModel.buttons {
                Spacer()
                VStack {
                    ForEach(Array(buttons.enumerated()), id: \.element.id) { index, btnConfig in
                        let button = Button(action: {
                            btnConfig.action()
                        }) {
                            HStack {
                                if let icon = btnConfig.icon {
                                    icon
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 14, height: 14)
                                }
                                Text(btnConfig.title)
                            }
                        }
                            .padding(.vertical, 8)
                        
                        if index == buttons.count - 1 {
                            button.buttonStyle(PrimaryButtonStyle(isDisabled: false))
                        } else {
                            button.buttonStyle(SecondaryButtonStyle())
                        }
                        
                    }
                }
            } else {
                Spacer()
            }
            
        }.padding()
    }
    
}

#Preview("Default") {
    ZeroStateView(
        viewModel: ZeroStateViewModel(
            image: Image(systemName: "person"),
            title: "Title",
            buttons: [
                ButtonConfig(
                    id: "button-1",
                    title: "Button 1",
                    action: {
                        print("Button 1")
                    }
                ),
                ButtonConfig(
                    id: "button-2",
                    title: "Button 2",
                    icon: Image(systemName: "lock"),
                    action: {
                        print("Button 2")
                    }
                ),
            ]
        )
    )
}

#Preview("No Image, No Buttons") {
    ZeroStateView(
        viewModel: ZeroStateViewModel(
            image: nil,
            title: "Zero State",
            buttons: nil
        )
    )
}

#Preview("No Buttons") {
    ZeroStateView(
        viewModel: ZeroStateViewModel(
            image: Image("AppIcon-A"),
            title: "Zero State",
            buttons: nil
        )
    )
}

#Preview("Single Button") {
    ZeroStateView(
        viewModel: ZeroStateViewModel(
            image: Image(systemName: "lock"),
            title: "Zero State",
            buttons: [
                ButtonConfig(
                    id: "single-button",
                    title: "Single Action",
                    icon: Image(systemName: "lock"),
                    action: {
                        
                    }
                )
            ]
        )
    )
}
