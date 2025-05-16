//
//  EmailTextFieldStyle.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//
import SwiftUI

struct EmailTextFieldStyle: TextFieldStyle {
    
    let leftIcon: Image?
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        let labeledField = HStack {
            if let icon = leftIcon {
                icon
                    .foregroundStyle(Theme.Colors.textPrimary)
            }
            configuration
        }
        
        return labeledField
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

#Preview {
    TextField("Account", text: .constant(""))
        .textFieldStyle(
            EmailTextFieldStyle(leftIcon: Image(systemName: "person"))
        )
        .padding()
}
