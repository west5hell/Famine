//
//  PhotosView.swift
//  Famine
//
//  Created by Pongt Chia on 19/8/25.
//

import PhotosUI
import SwiftUI

struct PhotosView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [Image] = []

    var body: some View {
        NavigationStack {
            Group {
                if selectedImages.isEmpty {
                    ContentUnavailableView(
                        label: {
                            Label(
                                "No Photos",
                                systemImage: "photo.on.rectangle.angled"
                            )
                        },
                        description: {
                            Text("You don't have any photos yet.")
                        },
                        actions: {
                            photoPicker(label: "Select Photos")
                        }
                    )
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                            ForEach(selectedImages.indices, id: \.self) { index in
                                selectedImages[index]
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 8)
                                    )
                            }
                        }
                        .padding()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Dismiss", systemImage: "chevron.down")
                    }
                }
                
                if !selectedImages.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        photoPicker(label: "Add Images", systemImage: "plus")
                    }
                }
            }
        }
    }

    // MARK: - Shared PhotosPicker builder
    private func photoPicker(label: String, systemImage: String? = nil) -> some View {
        PhotosPicker(selection: $selectedItems, matching: .images) {
            if let systemImage {
                Label(label, systemImage: systemImage)
            } else {
                Text(label)
            }
        }
        .onChange(of: selectedItems) { _, newItems in
            Task {
                selectedImages = await loadImages(from: newItems)
            }
        }
    }

    // MARK: - Image loader
    @MainActor
    private func loadImages(from items: [PhotosPickerItem]) async -> [Image] {
        var images: [Image] = []
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                images.append(Image(uiImage: uiImage))
            }
        }
        return images
    }
}

#Preview {
    PhotosView()
}
