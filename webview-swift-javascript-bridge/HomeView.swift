//
//  HomeView.swift
//  webview-swift-javascript-bridge
//
//  Created by admin on 8/3/24.
//

import SwiftUI

struct HomeView: View {
  @State private var showDetail = false
  @EnvironmentObject var webviewModel: WebViewModel

    var body: some View {
      VStack {
        Button {
          webviewModel.currentUrl.send("http://192.168.200.103:3000/content")
        } label: {
          Text("이벤트")
        }
      }
//        NavigationStack {
//          VStack {
//                      Text("홈 화면")
//                          .font(.largeTitle)
//                          .padding()
//
//                      Button(action: {
//                          showDetail = true
//                      }) {
//                          Text("상세 보기로 이동")
//                              .foregroundColor(.blue)
//                              .padding()
//                              .background(Color.gray.opacity(0.2))
//                              .cornerRadius(8)
//                      }
//                  }
//            .navigationTitle("홈")
//            .fullScreenCover(isPresented: $showDetail) {
//                         DetailView(title: "상세")
//                     }
//        }
    }
}

#Preview {
  HomeView().environmentObject(WebViewModel())
}
