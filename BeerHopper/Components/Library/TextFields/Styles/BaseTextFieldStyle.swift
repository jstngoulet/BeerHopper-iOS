//
//  TextFieldStyle.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//

import SwiftUI


struct BaseTextFieldStyle: TextFieldStyle {
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.body)
            .foregroundStyle(Theme.Colors.textSecondary)
            .padding(14)
            .frame(maxWidth: .infinity)
            .background(Theme.Colors.paper)
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Theme.Colors.primary, lineWidth: 1)
            }
    }
}

#Preview("Base") {
    TextField("Type something...", text: .constant(""))
        .textFieldStyle(BaseTextFieldStyle())
        .padding()
}

#Preview("Image") {
    TextField(
        "Type something...",
        text: .constant("")
    )
    .textFieldStyle(
        BaseTextFieldStyle()
    )
    .padding()
}
