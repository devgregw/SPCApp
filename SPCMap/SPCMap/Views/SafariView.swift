//
//  SafariView.swift
//  SPCMap
//
//  Created by Greg Whatley on 6/17/23.
//

import SafariServices
import SwiftUI

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Self.Context) -> SFSafariViewController {
        .init(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Self.Context) {
    }
}
