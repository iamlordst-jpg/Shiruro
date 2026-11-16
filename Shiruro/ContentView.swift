import SwiftUI

struct ContentView: View {
    @StateObject private var browser = MiruroBrowser()
    @State private var isBrowsing = false

    private let background = Color(red: 0.035, green: 0.025, blue: 0.075)

    var body: some View {
        ZStack {
            background.ignoresSafeArea()
            VStack(spacing: 0) {
                header

                if isBrowsing {
                    MiruroWebView(browser: browser)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(background)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .padding(.horizontal, 7)
                        .padding(.bottom, 7)
                } else {
                    home
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var header: some View {
        HStack(spacing: 11) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.66, green: 0.42, blue: 1),
                                Color(red: 0.34, green: 0.18, blue: 0.78)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 38, height: 38)
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 1) {
                Text("Shiruro")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .tracking(-0.5)
                Text("ANIME, IN YOUR ORBIT")
                    .font(.system(size: 9, weight: .bold, design: .rounded))
                    .tracking(1.4)
                    .foregroundStyle(Color.white.opacity(0.48))
            }

            Spacer()

            if isBrowsing {
                Button {
                    browser.goBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 36, height: 36)
                        .background(.white.opacity(0.07), in: Circle())
                }
                .accessibilityLabel("Go back")

                Button {
                    browser.reload()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 36, height: 36)
                        .background(.white.opacity(0.07), in: Circle())
                }
                .accessibilityLabel("Reload Miruro")
            }
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 16)
        .padding(.top, 7)
        .padding(.bottom, 9)
        .background(Color(red: 0.055, green: 0.035, blue: 0.11))
    }

    private var home: some View {
        VStack(spacing: 18) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.purple.opacity(0.13))
                    .frame(width: 112, height: 112)
                Image(systemName: "sparkles.tv")
                    .font(.system(size: 43, weight: .medium))
                    .foregroundStyle(Color(red: 0.78, green: 0.62, blue: 1))
            }

            VStack(spacing: 8) {
                Text("Your anime, your orbit.")
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .tracking(-0.5)
                    .foregroundStyle(.white)
                Text("Explore anime and episodes with Miruro.")
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.55))
                    .multilineTextAlignment(.center)
            }

            Button {
                browser.loadHome()
                withAnimation(.easeOut(duration: 0.2)) {
                    isBrowsing = true
                }
            } label: {
                HStack(spacing: 9) {
                    Text("Explore Miruro")
                    Image(systemName: "arrow.up.right")
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 22)
                .padding(.vertical, 13)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 0.59, green: 0.38, blue: 0.98),
                            Color(red: 0.39, green: 0.22, blue: 0.82)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    in: Capsule()
                )
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(24)
    }
}
