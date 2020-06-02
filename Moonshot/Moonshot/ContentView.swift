//
//  ContentView.swift
//  Moonshot
//
//  Created by Guilherme Flores on 29/05/2020.
//  Copyright © 2020 i3pt. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    struct MissionAndAstronauts: Identifiable {
        let id: UUID
        let mission: Mission
        let crew: [Astronaut]
    }
    
    var austronauts = [Astronaut]()
    var missions = [Mission]()
    var missionsAndAstronauts = [MissionAndAstronauts]()
    
    @State private var viewCrew = false
    
    var body: some View {
        NavigationView {
            List(self.missionsAndAstronauts) { missionCrew in
                NavigationLink(destination: MissionView(mission: missionCrew.mission, astronauts: missionCrew.crew)) {
                    Image(missionCrew.mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    
                    VStack(alignment: .leading) {
                        Text(missionCrew.mission.displayName)
                            .font(.headline)
                        VStack(alignment: .leading) {
                            if self.viewCrew {
                                ForEach(missionCrew.crew) { member in
                                    Text(member.name)
                                }
                            } else {
                                Text(missionCrew.mission.formattedLaunchDate)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Moonshot")
            .navigationBarItems(leading: Button(self.viewCrew ? "Launch Date" : "Crew Members") {
                self.viewCrew.toggle()
            })
        }
    }
    
    init() {
        self.austronauts = Bundle.main.decode("astronauts.json")
        self.missions = Bundle.main.decode("missions.json")
        
        for mission in missions {
            var crew = [Astronaut]()
            for member in mission.crew {
                if let match = austronauts.first(where: { $0.id == member.name }) {
                    crew.append(match)
                }
            }
            missionsAndAstronauts.append(MissionAndAstronauts(id: UUID(),  mission: mission, crew: crew))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
