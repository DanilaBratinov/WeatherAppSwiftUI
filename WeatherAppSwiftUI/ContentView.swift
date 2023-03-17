import SwiftUI

struct ContentView: View {
    @State private var temp = 0
    @State private var humidity = 0
    @State private var windSpeed = 0
    @State private var cityName = "MOSCOW"
    @State private var cityOvercast = "пасмурно"
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "mappin")
                    .imageScale(.large)
//                    .frame(width: 35, height: 35)
                
                TextField(text: $cityName) {}
                    .font(.title)
                    .fontWeight(.light)
                
                Spacer()
                
                Button(action: {fetchWeather(city: cityName)}) {
                    Circle()
                        .foregroundStyle(.cyan)
                        .frame(width: 50, height: 50)
                        .opacity(0.2)
                        .overlay {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                }
            }
            
            VStack {
                Image(systemName: "cloud.sun")
                    .resizable()
                    .frame(width: 270, height: 200)
                    .foregroundColor(.mint)
                Text("\(temp)°C")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(cityOvercast)
                    .fontWeight(.light)
            }
            .padding(.top, 75)
            
            Spacer()
            HStack {
                Image(systemName: "humidity")
                    .resizable()
                    .frame(width: 40, height: 30)
                VStack {
                    HStack {
                        Text("\(humidity)%")
                            .font(.title)
                            .fontWeight(.medium)
                            .padding(.leading, -30)
                    }
                    HStack {
                        Text("Влажность")
                    }
                }
                Spacer()
                HStack {
                    Image(systemName: "wind")
                        .resizable()
                        .frame(width: 40, height: 30)
                    VStack {
                        HStack {
                            Text("\(windSpeed)Km/h")
                                .font(.title)
                                .fontWeight(.medium)
                                .padding(.leading, -40)

                        }
                        HStack {
                            Text("Скорость ветра")
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ContentView {
    private func getURL(city: String) -> String {
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=28ede8c4626bcba101f47c928f53f1b9&units=metric&lang=ru"
        
        return url
    }
    private func fetchWeather(city: String) {
        NetworkManager.shared.fetch(Weather.self, from: getURL(city: city)) { result in
            switch result {
            case .success(let data):
                temp = Int(data.main?.temp ?? 0)
                cityOvercast = data.weather?.first?.description ?? ""
                humidity = data.main?.humidity ?? 0
                windSpeed = Int(data.wind?.speed ?? 0)
            case .failure(let error):
                print(error)
            }
        }
    }
}
