//
//  WebViewModel.swift
//  webview-swift-javascript-bridge
//
//  Created by admin on 8/4/24.
//

import Foundation
import Combine

class WebViewModel: ObservableObject {
  var currentUrl = PassthroughSubject<String, Never>()
}
