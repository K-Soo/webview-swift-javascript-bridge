//
//  ViewModel.swift
//  webview-swift-javascript-bridge
//
//  Created by admin on 8/4/24.
//

import Foundation


import Combine

class ViewModel: ObservableObject {
  @Published var currentUrl: String = ""
}
