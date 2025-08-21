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
    @State private var seenItemIDs = Set<String>()  // track duplicates

    var body: some View {
        NavigationStack {
            Group {
                if selectedImages.isEmpty {
                    ContentUnavailableView {
                        Label(
                            "No Photos",
                            systemImage: "photo.on.rectangle.angled"
                        )
                    } description: {
                        Text("You don't have any photos yet.")
                    } actions: {
                        PhotosPicker(
                            "Select Photos",
                            selection: $selectedItems,
                            matching: .images
                        )
                        .onChange(of: selectedItems, loadImages)
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))])
                        {
                            ForEach(selectedImages.indices, id: \.self) {
                                index in
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
                        PhotosPicker(
                            selection: $selectedItems,
                            matching: .images
                        ) {
                            Label("Add images", systemImage: "plus")
                        }
                        .onChange(of: selectedItems, loadImages)
                    }
                }
            }
        }
    }

    // MARK: - Helpers
    @MainActor
    private func loadImages(
        from oldItems: [PhotosPickerItem],
        to newItems: [PhotosPickerItem]
    ) {
        Task {
            var newImages: [Image] = []
            for item in newItems {
                if let data = try? await item.loadTransferable(type: Data.self),
                    let uiImage = UIImage(data: data)
                {
                    newImages.append(Image(uiImage: uiImage))
                }
            }
            selectedImages = newImages
        }
    }
}

#Preview {
    PhotosView()
}
