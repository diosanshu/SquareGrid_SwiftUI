import SwiftUI

struct ContentView: View {
    @State private var selectedItems: Set<Int> = []
    @State private var itemsPerRow: Int = 2
    let spacing: CGFloat = 5
    @State private var scrollTarget: Int?

    var totalItems: Int {
        return 20 // Update with the actual total number of items in your data
    }

    struct GridItemViewModel: Identifiable {
        let id: Int
        let imageCount: Int
    }

    var gridItems: [GridItemViewModel] {
        return (1 ..< totalItems).map { i in
            GridItemViewModel(id: i, imageCount: (i % 3 == 0) ? 1 : 2) // Example condition for a single image row
        }
    }

    var body: some View {
        TabView {
            // First Tab - Your Existing Code
            NavigationView {
                GeometryReader { geometry in
                    VStack {
                        ScrollView {
                            ScrollViewReader { proxy in
                                LazyVGrid(columns: Array(repeating: GridItem(), count: itemsPerRow), spacing: spacing) {
                                    ForEach(gridItems) { item in
                                        VStack(spacing: 0) {
                                            if item.imageCount == 1 {
                                                singleImageRow(item: item, geometry: geometry)
                                            } else {
                                                doubleImageRow(item: item, geometry: geometry)
                                            }
                                        }
                                        .id(item.id) // Add an identifier to each item
                                    }
                                }
                                .onChange(of: scrollTarget) { target in
                                    if let target = target {
                                        withAnimation {
                                            proxy.scrollTo(target, anchor: .center)
                                        }
                                        scrollTarget = nil
                                    }
                                }
                            }
                            .onAppear {
                                // Do not call scrollToLastItem here
                            }
                        }
                        .padding(.top, 0)
                    }
                    .navigationBarItems(
                        leading: HStack {
                            Button(action: {
                                // Add your arrow-up action here
                                // For example, you can scroll to the top of the ScrollView
                                withAnimation {
                                    scrollTarget = 1
                                }
                            }) {
                                Image(systemName: "arrow.up.circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.blue)
                                    .padding()
                            }

                            Button(action: {
                                // Add your arrow-down action here
                                // For example, you can set the scroll target to the bottom
                                scrollTarget = totalItems - 1
                            }) {
                                Image(systemName: "arrow.down.circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.blue)
                                    .padding()
                            }
                        },
                        trailing: Picker("Items per Row", selection: $itemsPerRow) {
                            ForEach(1 ..< 6) { number in
                                Text("\(number)").tag(number)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    )
                }
            }
            .tabItem {
                Label("Categories", systemImage: "list.dash")
            }

            // Second Tab - Watch List
            NavigationView {
                // Add your watch list implementation here
                Text("Watch List")
                    .navigationBarTitle("Watch List")
            }
            .tabItem {
                Label("Watch List", systemImage: "star.fill")
            }
        }
    }

    private func itemSize(for screenWidth: CGFloat) -> CGFloat {
        let totalSpacing = CGFloat(itemsPerRow + 1) * spacing
        let availableWidth = screenWidth - totalSpacing
        let itemWidth = availableWidth / CGFloat(itemsPerRow)
        return itemWidth
    }

    private func toggleSelection(for item: Int) {
        if selectedItems.contains(item) {
            selectedItems.remove(item)
        } else {
            selectedItems.insert(item)
        }

        print("Toggled selection for item at index: \(item)")
    }

    @ViewBuilder
    private func singleImageRow(item: GridItemViewModel, geometry: GeometryProxy) -> some View {
        Button(action: {
            toggleSelection(for: item.id)
        }) {
            Text("\(item.id)")
                .frame(width: itemSize(for: geometry.size.width), height: itemSize(for: geometry.size.width))
                .background(Color.purple) // Add background color
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 2))
                .overlay(
                    selectedItems.contains(item.id) ?
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .foregroundColor(.blue)
                            .frame(width: 25, height: 25)
                            .padding(5)
                            .background(Color.white)
                            .clipShape(Circle())
                            .offset(x: itemSize(for: geometry.size.width) / 2 - 20, y: -itemSize(for: geometry.size.width) / 2 + 20)
                        : nil
                )
                .foregroundColor(.white) // Change font color to white
        }
    }

    @ViewBuilder
    private func doubleImageRow(item: GridItemViewModel, geometry: GeometryProxy) -> some View {
        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                ForEach(0 ..< item.imageCount) { index in
                    Button(action: {
                        toggleSelection(for: item.id + index)
                    }) {
                        Text("\(item.id + index)")
                            .frame(width: (itemSize(for: geometry.size.width) - spacing) / 2, height: itemSize(for: geometry.size.width) / 2)
                            .background(Color.pink) // Add background color
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 2))
                            .overlay(
                                selectedItems.contains(item.id + index) ?
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .foregroundColor(.blue)
                                        .frame(width: 25, height: 25)
                                        .padding(5)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .offset(x: (itemSize(for: geometry.size.width) - spacing) / 4 - 20, y: -itemSize(for: geometry.size.width) / 4 + 20)
                                    : nil
                            )
                            .foregroundColor(.white) // Change font color to white
                    }
                }
            }

            HStack(spacing: spacing) {
                ForEach(item.imageCount ..< item.imageCount * 2) { index in
                    Button(action: {
                        toggleSelection(for: item.id + index)
                    }) {
                        Text("\(item.id + index)")
                            .frame(width: (itemSize(for: geometry.size.width) - spacing) / 2, height: itemSize(for: geometry.size.width) / 2)
                            .background(Color.pink) // Add background color
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 2))
                            .overlay(
                                selectedItems.contains(item.id + index) ?
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .foregroundColor(.blue)
                                        .frame(width: 25, height: 25)
                                        .padding(5)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .offset(x: (itemSize(for: geometry.size.width) - spacing) / 4 - 20, y: -itemSize(for: geometry.size.width) / 4 + 20)
                                    : nil
                            )
                            .foregroundColor(.white) // Change font color to white
                    }
                }
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


