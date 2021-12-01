//
//  AboutView.swift
//  Calculator
//
//  Created by Marcin Obolewicz on 25/11/2021.
//

import SwiftUI

struct AboutView: View {
    enum Constants {
        static let aspectRatio: CGFloat = 1
    }
    var body: some View {
        Form {
            Image(asset: Asset.user)
                .resizable()
                .aspectRatio(Constants.aspectRatio, contentMode: .fill)
            Section(header: Text("About")) {
                FormDetailRow(title: "Author", detail: "Marcin")
                FormDetailRow(title: "Date", detail: "33.12.2021")
            }
            Section(header: Text("Summary")) {
                FormDetailRow(title: "App", detail: "Calculator")
                FormDetailRow(title: "Version", detail: "0.0")
            }
        }
    }
}

struct FormDetailRow: View {
    var title: String
    var detail: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(detail)
        }
    }
}
