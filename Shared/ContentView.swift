//
//  ContentView.swift
//  Shared
//
//  Created by Patrick Van den Bergh on 26/03/2022.
//

import SwiftUI

struct ContentView: View {
    @State var code = ""
    @State var output = ""
    var body: some View {
        VStack {
            Button(action: {
                output = Lox.shared.run(code: code)
            }) { Text("Run") }
            GeometryReader { metrics in
                VStack {
                    #if os(macOS)
                    SloxEditor(text: $code)
                        .frame(height: metrics.size.height * 0.75)
                    #else
                    TextEditor(text: $code)
                        .frame(height: metrics.size.height * 0.75)
                        .font(.system(size: 14, design: .monospaced))
                    #endif
                    ScrollView {
                        Text(output)
                            .frame(width: metrics.size.width, alignment: .leading)
                            .font(.system(.body, design: .monospaced))
                    }
                    .frame(height: metrics.size.height * 0.25)
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
