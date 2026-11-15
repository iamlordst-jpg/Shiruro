import SwiftUI

private enum ShiruroTab: String, CaseIterable {
    case home = "Home"
    case search = "Search"
    case library = "Library"
    var symbol: String {
        switch self {
        case .home: return "house.fill"
        case .search: return "magnifyingglass"
        case .library: return "bookmark.fill"
        }
    }
}

private struct SavedAnime: Codable, Identifiable {
    var id = UUID()
    var title: String
}

struct ContentView: View {
    @StateObject private var browser = MiruroBrowser()
    @State private var selectedTab: ShiruroTab = .home
    @State private var showingAddAnime = false
    @State private var newAnimeTitle = ""
    @AppStorage("shiruro.savedAnime") private var savedAnimeData = "[]"

    private var savedAnime: [SavedAnime] {
        guard let data = savedAnimeData.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([SavedAnime].self, from: data) else { return [] }
        return decoded
    }

    var body: some View {
        ZStack {
            Color(red: 0.035, green: 0.025, blue: 0.075).ignoresSafeArea()
            VStack(spacing: 0) {
                header
                if selectedTab == .library {
                    libraryView
                } else {
                    ZStack(alignment: .top) {
                        MiruroWebView(browser: browser).ignoresSafeArea(edges: .bottom)
                        if selectedTab == .search { searchHint }
                    }
                }
                tabBar
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingAddAnime) {
            addAnimeSheet.presentationDetents([.medium]).presentationDragIndicator(.visible)
        }
    }

    private var header: some View {
        HStack(spacing: 11) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(LinearGradient(colors: [Color(red: 0.66, green: 0.42, blue: 1), Color(red: 0.34, green: 0.18, blue: 0.78)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 38, height: 38)
                Image(systemName: "moon.stars.fill").font(.system(size: 19, weight: .semibold)).foregroundStyle(.white)
            }
            VStack(alignment: .leading, spacing: 1) {
                Text("Shiruro").font(.system(size: 20, weight: .bold, design: .rounded)).tracking(-0.5)
                Text(selectedTab == .library ? "YOUR COLLECTION" : "ANIME, IN YOUR ORBIT")
                    .font(.system(size: 9, weight: .bold, design: .rounded)).tracking(1.4)
                    .foregroundStyle(Color.white.opacity(0.48))
            }
            Spacer()
            if selectedTab != .library {
                Button { browser.goBack() } label: {
                    Image(systemName: "chevron.left").font(.system(size: 14, weight: .semibold))
                        .frame(width: 34, height: 34).background(.white.opacity(0.07), in: Circle())
                }.accessibilityLabel("Go back")
                Button { browser.reload() } label: {
                    Image(systemName: "arrow.clockwise").font(.system(size: 14, weight: .semibold))
                        .frame(width: 34, height: 34).background(.white.opacity(0.07), in: Circle())
                }.accessibilityLabel("Reload Miruro")
            }
        }
        .foregroundStyle(.white).padding(.horizontal, 16).padding(.top, 8).padding(.bottom, 11)
        .background(Color(red: 0.055, green: 0.035, blue: 0.11))
    }

    private var searchHint: some View {
        HStack(spacing: 8) {
            Image(systemName: "sparkle.magnifyingglass").foregroundStyle(Color(red: 0.78, green: 0.62, blue: 1))
            Text("Use Miruro's search on the page below").font(.system(size: 12, weight: .medium))
                .foregroundStyle(.white.opacity(0.8))
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 13).padding(.vertical, 10)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .padding(12).allowsHitTesting(false)
    }

    private var libraryView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your watchlist").font(.system(size: 25, weight: .bold, design: .rounded))
                    Text("\(savedAnime.count) saved titles").font(.system(size: 13)).foregroundStyle(.white.opacity(0.5))
                }
                Spacer()
                Button { showingAddAnime = true } label: {
                    Label("Add", systemImage: "plus").font(.system(size: 13, weight: .semibold))
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        .background(Color(red: 0.48, green: 0.29, blue: 0.9), in: Capsule())
                }
            }
            if savedAnime.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "bookmark").font(.system(size: 38, weight: .light)).foregroundStyle(Color.purple)
                    Text("Your orbit is empty").font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("Save titles here to keep your watchlist in one place.")
                        .font(.system(size: 13)).foregroundStyle(.white.opacity(0.5)).multilineTextAlignment(.center)
                }.frame(maxWidth: .infinity)
                Spacer()
            } else {
                List {
                    ForEach(savedAnime) { anime in
                        HStack(spacing: 12) {
                            Image(systemName: "play.rectangle.fill").foregroundStyle(Color(red: 0.72, green: 0.55, blue: 1))
                            Text(anime.title).font(.system(size: 15, weight: .medium))
                        }.listRowBackground(Color.white.opacity(0.045))
                    }.onDelete(perform: deleteAnime)
                }.listStyle(.plain).scrollContentBackground(.hidden)
            }
        }
        .padding(18).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(ShiruroTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.easeOut(duration: 0.16)) { selectedTab = tab }
                } label: {
                    VStack(spacing: 5) {
                        Image(systemName: tab.symbol).font(.system(size: 17, weight: .semibold))
                        Text(tab.rawValue).font(.system(size: 10, weight: .semibold))
                    }
                    .foregroundStyle(selectedTab == tab ? Color(red: 0.79, green: 0.65, blue: 1) : .white.opacity(0.42))
                    .frame(maxWidth: .infinity).padding(.top, 10).padding(.bottom, 7).contentShape(Rectangle())
                }.buttonStyle(.plain)
            }
        }
        .background(Color(red: 0.055, green: 0.035, blue: 0.11))
        .overlay(alignment: .top) { Rectangle().fill(.white.opacity(0.08)).frame(height: 0.5) }
    }

    private var addAnimeSheet: some View {
        NavigationStack {
            Form {
                Section("Anime title") {
                    TextField("Enter a title", text: $newAnimeTitle).textInputAutocapitalization(.words)
                }
                Section {
                    Text("This list is stored locally on this device. It does not sync with a Miruro account.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Add to watchlist").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { showingAddAnime = false } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { addAnime() }.disabled(newAnimeTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }.preferredColorScheme(.dark)
    }

    private func addAnime() {
        let title = newAnimeTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        var items = savedAnime
        items.insert(SavedAnime(title: title), at: 0)
        if let data = try? JSONEncoder().encode(items), let json = String(data: data, encoding: .utf8) {
            savedAnimeData = json
        }
        newAnimeTitle = ""
        showingAddAnime = false
    }

    private func deleteAnime(at offsets: IndexSet) {
        var items = savedAnime
        items.remove(atOffsets: offsets)
        if let data = try? JSONEncoder().encode(items), let json = String(data: data, encoding: .utf8) {
            savedAnimeData = json
        }
    }
}
