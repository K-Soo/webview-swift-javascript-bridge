//
//  ProfileView.swift
//  webview-swift-javascript-bridge
//
//  Created by admin on 8/3/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("프로필 화면")
                    .font(.largeTitle)
                    .padding()

                NavigationLink(destination: DetailView(title: "프로필 상세 보기")) {
                    Text("상세 보기로 이동")
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            .navigationTitle("프로필")
        }
    }
}

#Preview {
    ProfileView()
}
