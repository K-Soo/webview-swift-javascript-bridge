//
//  ContentView.swift
//  webview-swift-javascript-bridge
//
//  Created by admin on 2024/02/12.
//

import SwiftUI

struct ContentView: View {
  @State private var showLoading = false

    var body: some View {
      VStack {
//        Webview(url: URL(string: "http://192.168.35.172:3000")!, showLoading: $showLoading)
//          .overlay {
//            ProgressLoadingView()
//          }
        Webview(url: URL(string: "https://wala-land.com")!, showLoading: $showLoading)
          .overlay {
            ProgressLoadingView()
          }

      }
    }
}

#Preview {
    ContentView()
}
