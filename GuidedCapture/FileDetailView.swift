//
//  FileDetailView.swift
//  GuidedCapture
//
//  Created by #include tech. on 23/11/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import SwiftUI

struct FilesView: View {
    @Binding var showFiles: Bool
    @StateObject private var vm = FilesViewViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Captured Models").foregroundColor(.secondary)
                    .font(.title2)
                    .bold()
                Spacer()
                Button(action: {
                    withAnimation {
                        showFiles  = false
                    }},
                       label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.init(white: 0.7, opacity: 0.5))
                        .font(.title)
                })
            }
            .padding([.top, .horizontal], 30)
            NavigationView {
                VStack {
                    List(vm.files, id: \.self) { fileURL in
                        NavigationLink {
                            ModelView(modelFile: fileURL, endCaptureCallback: {
                                // Handle the end capture callback if needed
                            })
                        } label: {
                            Text(fileURL.lastPathComponent)
                        }
                    }
                }
                .onAppear(perform: {
                    vm.fetchFiles()
                })
                .onDisappear {
                    vm.files.removeAll()
                }
            }
        }
    }
}
