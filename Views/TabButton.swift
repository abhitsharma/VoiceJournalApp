//
//  TabButton.swift
//  VoiceJournalApp
//
//  Created by Abhit Sharma on 04/10/25.
//

import SwiftUI

struct TabButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let selectedColor: Color
    let unselectedColor: Color
    let action: () -> Void

    init(icon: String,
         title: String,
         isSelected: Bool,
         selectedColor: Color = Color.accentColor,
         unselectedColor: Color = Color.gray,
         action: @escaping () -> Void)
    {
        self.icon = icon
        self.title = title
        self.isSelected = isSelected
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .renderingMode(.template)
                    .symbolRenderingMode(.monochrome)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isSelected ? selectedColor : unselectedColor)
                    .scaleEffect(isSelected ? 1.12 : 1.0)
                    .frame(width: 28, height: 28)

                Text(title)
                    .font(.caption2)
                    .foregroundColor(isSelected ? selectedColor : unselectedColor)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(title))
    }
}

#Preview {
    TabButton(icon: "", title: "", isSelected: true, action: {})
}
