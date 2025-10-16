import SwiftUI
import Charts

struct StatsChartView: View {
    var warranties: [WarrantyItem]
    
    struct CategoryData: Identifiable {
        let id = UUID()
        let category: String
        let count: Int
    }
    
    var data: [CategoryData] {
        let grouped = Dictionary(grouping: warranties, by: { $0.category })
        return grouped.map { CategoryData(category: $0.key, count: $0.value.count) }
    }
    
    let topColor = Color(red: 162/255, green: 230/255, blue: 218/255)
    let bottomColor = Color(red: 42/255, green: 43/255, blue: 43/255)
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [topColor, bottomColor]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Warranty Statistics by Category")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top, 30)
                
                Chart(data) { item in
                    BarMark(
                        x: .value("Category", item.category),
                        y: .value("Count", item.count)
                    )
                    .foregroundStyle(.gray.gradient)
                }
                .frame(height: 300)
                .padding()
                
                Spacer()
                
                HStack {
                    Spacer()
                    NavigationLink(destination: HomeScreenView()) {
                        VStack {
                            Image(systemName: "house.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                            Text("Home")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                    }
                    Spacer()
                    
                    NavigationLink(destination: StatsChartView(warranties: warranties)) {
                        VStack {
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                            Text("Stats")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                    }
                    Spacer()
                    
                    NavigationLink(destination: ProfileScreenView()) {
                        VStack {
                            Image(systemName: "person")
                                .foregroundColor(.white.opacity(0.9))
                                .font(.system(size: 24))
                            Text("Profile")
                                .foregroundColor(.white.opacity(0.9))
                                .font(.caption)
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(Color.black.opacity(0.25))
                .cornerRadius(20)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .navigationTitle("Stats")
    }
 
    }


