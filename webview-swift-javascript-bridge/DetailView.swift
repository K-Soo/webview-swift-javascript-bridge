//
//  DetailView.swift
//  webview-swift-javascript-bridge
//
//  Created by admin on 8/3/24.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) var dismiss
  var title: String

    var body: some View {
        NavigationStack {
            VStack {
                Text("상세 보기 화면")
                    .font(.largeTitle)
                    .padding()

                Button("닫기") {
                    dismiss()
                }
                .foregroundColor(.blue)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
            .navigationTitle("상세 보기")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
  DetailView(title: "디테일")
}
