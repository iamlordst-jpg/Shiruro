import SwiftUI

private enum ShiruroTab: String, CaseIterable {
    case home = "Home"
    case search = "Search"
    case player = "Player"
    case library = "Library"

    var symbol: String {
        switch self {
        case .home: return "house.fill"
        case .search: return "magnifyingglass"
        case .player: return "play.rectangle.fill"
        case .library: return "bookmark.fill"
        }
    }
}

private struct TrackedAnime: Codable, Identifiable {
    var id = UUID()
    var title: String
    var episode: Int
    var note: String
    var updatedAt = Date()
}

struct ContentView: View {
    @StateObject private var browser = MiruroBrowser()
    @State private var selectedTab: ShiruroTab = .home
    @State private var searchText = ""
    @State private var searchMessage = "Search Miruro's catalogue"
    @State private var showingAddAnime = false
    @State private var newAnimeTitle = ""
    @State private var newEpisode = "1"
    @State private var selectedAnimeID: UUID?
    @State private var playerMessage = "Open an episode on Miruro, then use these controls."
    @AppStorage("shiruro.trackedAnime") private var trackedAnimeData = "[]"

    private var trackedAnime: [TrackedAnime] {
        guard let data = trackedAnimeData.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([TrackedAnime].self, from: data) else { return [] }
        return decoded.sorted { $0.updatedAt > $1.updatedAt }
    }

    var body: some View {
        ZStack {
            Color(red: 0.035, green: 0.025, blue: 0.075).ignoresSafeArea()
            VStack(spacing: 0) {
                header
                Group {
                    switch selectedTab {
                    case .home: homeView
                    case .search: searchView
                    case .player: playerView
                    case .library: libraryView
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                Text("ANIME, IN YOUR ORBIT").font(.system(size: 9, weight: .bold, design: .rounded))
                    .tracking(1.4).foregroundStyle(Color.white.opacity(0.48))
            }
            Spacer()
            if selectedTab != .home && selectedTab != .library {
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
        .foregroundStyle(.white)
        .padding(.horizontal, 16)
        .padding(.top, 7)
        .padding(.bottom, 9)
        .background(Color(red: 0.055, green: 0.035, blue: 0.11))
    }

    private var homeView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ZStack(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 24).fill(
                        LinearGradient(colors: [Color(red: 0.30, green: 0.16, blue: 0.58), Color(red: 0.10, green: 0.07, blue: 0.23), Color(red: 0.055, green: 0.035, blue: 0.11)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    VStack(alignment: .leading, spacing: 12) {
                        Label("SHIRURO DISCOVER", systemImage: "sparkles")
                            .font(.system(size: 10, weight: .bold)).tracking(1.5).foregroundStyle(Color.purple.opacity(0.9))
                        Text("Find your next\nfavorite story.")
                            .font(.system(size: 29, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        Text("Browse anime and episodes with Miruro.")
                            .font(.system(size: 13)).foregroundStyle(.white.opacity(0.65))
                        Button {
                            browser.loadHome()
                            selectedTab = .search
                        } label: {
                            Label("Explore Miruro", systemImage: "arrow.up.right")
                                .font(.system(size: 13, weight: .semibold))
                                .padding(.horizontal, 16).padding(.vertical, 11)
                                .background(Color(red: 0.55, green: 0.34, blue: 0.95), in: Capsule())
                        }.padding(.top, 3)
                    }.padding(22)
                }
                .frame(maxWidth: .infinity, minHeight: 230, alignment: .leading)

                VStack(alignment: .leading, spacing: 12) {
                    sectionHeading("Discover", subtitle: "Jump to a section on Miruro")
                    discoveryCard("Latest Episodes", detail: "Recently updated shows", icon: "clock.fill") {
                        selectedTab = .search
                        browser.scrollToSection("latest episodes")
                    }
                    discoveryCard("Top Airing", detail: "Currently airing anime", icon: "flame.fill") {
                        selectedTab = .search
                        browser.scrollToSection("top airing")
                    }
                    discoveryCard("Upcoming", detail: "What's coming next", icon: "calendar") {
                        selectedTab = .search
                        browser.scrollToSection("upcoming")
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    sectionHeading("Continue tracking", subtitle: "Your latest episode progress")
                    if let latest = trackedAnime.first {
                        HStack(spacing: 12) {
                            Image(systemName: "bookmark.fill").font(.title2).foregroundStyle(Color.purple)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(latest.title).font(.system(size: 14, weight: .semibold))
                                Text("Episode \(latest.episode)").font(.system(size: 12)).foregroundStyle(.white.opacity(0.55))
                            }
                            Spacer()
                            Button("Open") { selectedTab = .library }
                                .font(.system(size: 12, weight: .semibold)).foregroundStyle(Color.purple.opacity(0.95))
                        }.padding(14).background(.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 16))
                    } else {
                        Text("Add a show in Library to track your episodes.")
                            .font(.system(size: 13)).foregroundStyle(.white.opacity(0.5))
                    }
                }
            }
            .padding(18)
            .padding(.bottom, 6)
        }
    }

    private func sectionHeading(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title).font(.system(size: 19, weight: .bold, design: .rounded))
            Text(subtitle).font(.system(size: 12)).foregroundStyle(.white.opacity(0.48))
        }
    }

    private func discoveryCard(_ title: String, detail: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 13) {
                Image(systemName: icon).font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color(red: 0.78, green: 0.62, blue: 1))
                    .frame(width: 40, height: 40).background(Color.purple.opacity(0.16), in: RoundedRectangle(cornerRadius: 12))
                VStack(alignment: .leading, spacing: 3) {
                    Text(title).font(.system(size: 14, weight: .semibold)).foregroundStyle(.white)
                    Text(detail).font(.system(size: 11)).foregroundStyle(.white.opacity(0.48))
                }
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 11, weight: .bold)).foregroundStyle(.white.opacity(0.35))
            }.padding(12).background(.white.opacity(0.045), in: RoundedRectangle(cornerRadius: 16))
        }.buttonStyle(.plain)
    }

    private var searchView: some View {
        VStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Search anime").font(.system(size: 22, weight: .bold, design: .rounded))
                HStack(spacing: 9) {
                    Image(systemName: "magnifyingglass").foregroundStyle(.white.opacity(0.45))
                    TextField("Search Miruro", text: $searchText)
                        .textInputAutocapitalization(.never).autocorrectionDisabled()
                        .submitLabel(.search).onSubmit(runSearch)
                    Button(action: runSearch) {
                        Image(systemName: "arrow.right.circle.fill").font(.system(size: 23))
                            .foregroundStyle(Color(red: 0.75, green: 0.55, blue: 1))
                    }.disabled(searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(13).background(.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 14))
                Text(searchMessage).font(.system(size: 11)).foregroundStyle(.white.opacity(0.48))
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)

            MiruroWebView(browser: browser)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 0.035, green: 0.025, blue: 0.075))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
        }
    }

    private var playerView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                Image(systemName: "play.rectangle.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color(red: 0.78, green: 0.62, blue: 1))
                VStack(alignment: .leading, spacing: 2) {
                    Text("SHIRURO PLAYER")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .tracking(1.4).foregroundStyle(.white.opacity(0.55))
                    Text("Now playing")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                }
                Spacer()
                Button { browser.focusPlayer() } label: {
                    Image(systemName: "arrow.down.to.line.compact")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 36, height: 36)
                        .background(.white.opacity(0.08), in: Circle())
                }.accessibilityLabel("Focus video player")
            }
            .foregroundStyle(.white).padding(.horizontal, 16).padding(.vertical, 12)
            MiruroWebView(browser: browser)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 0.035, green: 0.025, blue: 0.075))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
                .onAppear { browser.focusPlayer() }
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Playback").font(.system(size: 16, weight: .bold, design: .rounded))
                        Text(playerMessage).font(.system(size: 10)).foregroundStyle(.white.opacity(0.48)).lineLimit(2)
                    }
                    Spacer()
                    Button { browser.enterFullscreen() } label: {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                            .font(.system(size: 14, weight: .semibold))
                            .frame(width: 36, height: 36).background(.white.opacity(0.08), in: Circle())
                    }.accessibilityLabel("Enter fullscreen")
                }
                HStack(spacing: 0) {
                    playerButton("gobackward.10", title: "−10s") { browser.seek(by: -10) }
                    Spacer()
                    playerButton("playpause.fill", title: "Play / Pause") { browser.togglePlayback() }
                    Spacer()
                    playerButton("goforward.10", title: "+10s") { browser.seek(by: 10) }
                }
            }
            .padding(16).background(Color(red: 0.055, green: 0.035, blue: 0.11))
        }
    }

    private func playerButton(_ icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
            playerMessage = "Control sent to the video on the Miruro page."
        } label: {
            VStack(spacing: 5) {
                Image(systemName: icon).font(.system(size: 20, weight: .semibold))
                Text(title).font(.system(size: 10, weight: .medium))
            }.foregroundStyle(.white).frame(minWidth: 64)
        }.buttonStyle(.plain)
    }

    private var libraryView: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your library").font(.system(size: 25, weight: .bold, design: .rounded))
                    Text("\(trackedAnime.count) tracked titles").font(.system(size: 13)).foregroundStyle(.white.opacity(0.5))
                }
                Spacer()
                Button { showingAddAnime = true } label: {
                    Label("Track", systemImage: "plus").font(.system(size: 13, weight: .semibold))
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        .background(Color(red: 0.48, green: 0.29, blue: 0.9), in: Capsule())
                }
            }
            if trackedAnime.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "bookmark").font(.system(size: 38, weight: .light)).foregroundStyle(Color.purple)
                    Text("Your orbit is empty").font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("Track a title and the last episode you watched.")
                        .font(.system(size: 13)).foregroundStyle(.white.opacity(0.5)).multilineTextAlignment(.center)
                }.frame(maxWidth: .infinity)
                Spacer()
            } else {
                List {
                    ForEach(trackedAnime) { anime in
                        HStack(spacing: 10) {
                            Image(systemName: "play.rectangle.fill").foregroundStyle(Color.purple)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(anime.title).font(.system(size: 14, weight: .semibold))
                                Text("Episode \(anime.episode) · \(anime.note)")
                                    .font(.system(size: 11)).foregroundStyle(.white.opacity(0.48))
                            }
                            Spacer()
                            Button {
                                updateEpisode(anime, by: 1)
                            } label: {
                                Image(systemName: "plus.circle.fill").font(.system(size: 22)).foregroundStyle(Color.purple)
                            }.buttonStyle(.plain).accessibilityLabel("Mark next episode watched")
                        }.listRowBackground(Color.white.opacity(0.045))
                            .contentShape(Rectangle())
                            .onTapGesture { selectedAnimeID = anime.id }
                    }
                    .onDelete(perform: deleteAnime)
                }.listStyle(.plain).scrollContentBackground(.hidden)
                if let selected = trackedAnime.first(where: { $0.id == selectedAnimeID }) {
                    HStack {
                        Text("Selected: \(selected.title) · Episode \(selected.episode)")
                            .font(.system(size: 11)).foregroundStyle(.white.opacity(0.65))
                        Spacer()
                        Button("Open player") { selectedTab = .player }
                            .font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.purple)
                    }.padding(.horizontal, 4)
                }
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
        .padding(.bottom, 3)
        .background(Color(red: 0.055, green: 0.035, blue: 0.11))
        .overlay(alignment: .top) { Rectangle().fill(.white.opacity(0.08)).frame(height: 0.5) }
    }

    private var addAnimeSheet: some View {
        NavigationStack {
            Form {
                Section("Anime title") {
                    TextField("Enter a title", text: $newAnimeTitle).textInputAutocapitalization(.words)
                    TextField("Last watched episode", text: $newEpisode).keyboardType(.numberPad)
                }
                Section {
                    Text("Progress is stored locally on this device. It does not sync with a Miruro account.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Track anime").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { showingAddAnime = false } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { addAnime() }
                        .disabled(newAnimeTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }.preferredColorScheme(.dark)
    }

    private func runSearch() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return }
        searchMessage = "Sending search to Miruro…"
        browser.search(query) { success in
            searchMessage = success
                ? "Search submitted to Miruro. Results appear below."
                : "Couldn't locate Miruro's search field. Use the website search below."
        }
    }

    private func addAnime() {
        let title = newAnimeTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        var items = trackedAnime
        let episode = max(0, Int(newEpisode) ?? 1)
        items.insert(TrackedAnime(title: title, episode: episode, note: "Updated just now"), at: 0)
        save(items)
        selectedAnimeID = items.first?.id
        newAnimeTitle = ""
        newEpisode = "1"
        showingAddAnime = false
    }

    private func updateEpisode(_ anime: TrackedAnime, by amount: Int) {
        var items = trackedAnime
        guard let index = items.firstIndex(where: { $0.id == anime.id }) else { return }
        items[index].episode = max(0, items[index].episode + amount)
        items[index].note = "Updated just now"
        items[index].updatedAt = Date()
        save(items)
    }

    private func deleteAnime(at offsets: IndexSet) {
        var items = trackedAnime
        items.remove(atOffsets: offsets)
        save(items)
    }

    private func save(_ items: [TrackedAnime]) {
        if let data = try? JSONEncoder().encode(items),
           let json = String(data: data, encoding: .utf8) {
            trackedAnimeData = json
        }
    }
}
