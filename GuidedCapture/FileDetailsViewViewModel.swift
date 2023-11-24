//
//  FileDetailsViewViewModel.swift
//  GuidedCapture
//
//  Created by #include tech. on 24/11/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

class FilesViewViewModel: ObservableObject {
    @Published var files: [URL] = []
    
    func fetchFiles() {
        do {
            guard let newFolder = rootFolder() else {
                return
            }

            let fileManager = FileManager.default
            let rootFiles = try fileManager.contentsOfDirectory(at: newFolder, includingPropertiesForKeys: nil)

            let modelFiles = rootFiles
                .flatMap { folder -> [URL] in
                    do {
                        let files = try fileManager.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil)
                        return files.filter { $0.lastPathComponent == "Models" }
                    } catch {
                        print("Error fetching files in folder \(folder): \(error.localizedDescription)")
                        return []
                    }
                }
                .flatMap { modelFile -> [URL] in
                    do {
                        return try fileManager.contentsOfDirectory(at: modelFile, includingPropertiesForKeys: nil)
                    } catch {
                        print("Error fetching models in folder \(modelFile): \(error.localizedDescription)")
                        return []
                    }
                }

            self.files.append(contentsOf: modelFiles)

        } catch {
            print("Error fetching files: \(error.localizedDescription)")
        }
    }
    
    func rootFolder() -> URL? {
        guard let documentsFolder =
                try? FileManager.default.url(for: .documentDirectory,
                                             in: .userDomainMask,
                                             appropriateFor: nil, create: false) else {
            return nil
        }
        return documentsFolder.appendingPathComponent("Scans/", isDirectory: true)
    }
}
