//
//  ContentView.swift
//  echoed
//
//  Created by Guilherme Mota on 13/09/2024.
//

import SwiftUI

struct EchoListView: View {
    var body: some View {
        NavigationView {
            List {
                // Empty List
            }
            .navigationTitle("Echoed Notes")
        }
    }
}

struct EchoListView_Previews: PreviewProvider {
    static var previews: some View {
        EchoListView()
    }
}
