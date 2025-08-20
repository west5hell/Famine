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
    @State private var isPickerPresented = false

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
                        .onChange(of: selectedItems) { oldValue, newValue in
                            Task {
                                selectedImages = []
                                for item in newValue {
                                    if let data =
                                        try? await item.loadTransferable(
                                            type: Data.self
                                        ), let uiImage = UIImage(data: data)
                                    {
                                        selectedImages.append(
                                            Image(uiImage: uiImage)
                                        )
                                    }
                                }
                            }
                        }
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))])
                        {
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
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("dismiss", systemImage: "chevron.down") {
                        dismiss()
                    }
                }
                
                if !selectedImages.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add", systemImage: "plus") {
                            
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    PhotosView()
}
