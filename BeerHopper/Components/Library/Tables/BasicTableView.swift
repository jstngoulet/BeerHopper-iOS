//
//  BasicTableView.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/19/25.
//

import SwiftUI

final class BasicTableViewViewModel: ObservableObject {
    
    @Published
    private(set) var tableRows: [[String]]
    
    init(tableRows: [[String]]) {
        self.tableRows = tableRows
    }
    
}

struct BasicTableView: View {
    
    @ObservedObject
    private var viewModel: BasicTableViewViewModel
    
    init(viewModel: BasicTableViewViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            ForEach(Array(viewModel.tableRows.enumerated()), id: \.element) { rowIndex, row in
                HStack {
                    ForEach(Array(row.enumerated()), id: \.element) { colIndex, text in
                        Text(text)
                            .frame(
                                maxWidth: .infinity,
                                alignment: colIndex == 0 ? .trailing : .leading
                            )
                            .font(
                                rowIndex == 0
                                ? Theme.Fonts.body.bold()
                                : colIndex == 0
                                    ? Theme.Fonts.captionBold
                                    : Theme.Fonts.caption
                            )
                            .padding(.vertical, 8)
                            .padding(.horizontal, 8)
                            .foregroundStyle(
                                rowIndex == 0
                                ? Theme.Colors.paper
                                : Theme.Colors.textPrimary
                            )
                    }
                }
                .frame(maxWidth: .infinity)
                .background(
                    rowIndex == 0
                    ? Theme.Colors.primary
                    : rowIndex % 2 == 0
                        ? Theme.Colors.background
                        : Theme.Colors.background.opacity(0.5)
                )
                .clipShape(
                   rowIndex == 0
                   ? AnyShape(TopRoundedRectangle(radius: 8))
                   : AnyShape(Rectangle())
                )
            }
        }
    }
    
}



#Preview {
    BasicTableView(
        viewModel: BasicTableViewViewModel(
            tableRows: [
                ["Header 1", "Header 2"],
                ["A1", "B1"],
                ["A2", "B2"]
            ]
        )
    )
}

