//
//  BikeStationRowView.swift
//  VeloMapWwa
//
//  Created by Dawid Czmyr on 19/05/2024.
//

import SwiftUI

struct BikeStationRowView: View {
    var station: Place

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(station.name)
                .font(.headline)
            Text("500m • Aleja Pokoju 16, Kraków") //TODO: Add real distance
                .font(.subheadline)
                .foregroundColor(.gray)

            HStack {
                Spacer()
                VStack {
                    Image(.bike)
                        .font(.title)
                    Text("\(station.bike)")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                    Text("Bikes available")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()
                    .frame(width: 70)
                VStack {
                    Image(.lock)
                        .font(.title)
                    Text("\(station.freeRacks)")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    Text("Places available")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .bottomShadow(color: .black, radius: 5, x: 0, y: 5)
    }
}

#Preview {
    BikeStationRowView(station: Place(id: 1,
                                      name: "047 Ofiar Dąbia",
                                      bike: 7,
                                      freeRacks: 20,
                                      lat: 50.0671,
                                      lng: 19.9450))
        .padding()
}
