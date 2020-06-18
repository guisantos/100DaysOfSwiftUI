//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Guilherme Flores on 18/06/2020.
//  Copyright © 2020 i3pt. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @State var lastNameFilter = "A"
    @FetchRequest(entity: Country.entity(), sortDescriptors: []) var countries: FetchedResults<Country>
    
    var body: some View {
        VStack {
            List {
                ForEach(countries, id: \.self) { country in
                    Section(header: Text(country.wrappedFullName)) {
                        ForEach(country.candyArray, id: \.self) { candy in
                            Text(candy.wrappedName)
                        }
                    }
                }
            }
            
            Button("Add") {
                let candy1 = Candy(context: self.moc)
                candy1.name = "Mars"
                candy1.origin = Country(context: self.moc)
                candy1.origin?.shortName = "UK"
                candy1.origin?.fullName = "United Kingdom"
                
                let candy2 = Candy(context: self.moc)
                candy2.name = "KitKat"
                candy2.origin = Country(context: self.moc)
                candy2.origin?.shortName = "UK"
                candy2.origin?.fullName = "United Kingdom"
                
                let candy3 = Candy(context: self.moc)
                candy3.name = "Twix"
                candy3.origin = Country(context: self.moc)
                candy3.origin?.shortName = "UK"
                candy3.origin?.fullName = "United Kingdom"
                
                let candy4 = Candy(context: self.moc)
                candy4.name = "Toblerone"
                candy4.origin = Country(context: self.moc)
                candy4.origin?.shortName = "CH"
                candy4.origin?.fullName = "Switzerland"
                
                try? self.moc.save()
            }
        }
        
//        VStack {
//            FilteredList(filterKey: "lastName", filterValue: lastNameFilter) { (singer: Singer) in
//                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
//            }
//
//            Button("Add Examples") {
//                let taylor = Singer(context: self.moc)
//                taylor.firstName = "Taylor"
//                taylor.lastName = "Swift"
//
//                let ed = Singer(context: self.moc)
//                ed.firstName = "Ed"
//                ed.lastName = "Sheeran"
//
//                let adele = Singer(context: self.moc)
//                adele.firstName = "Adele"
//                adele.lastName = "Adkins"
//
//                try? self.moc.save()
//            }
//
//            Button("Show A") {
//                self.lastNameFilter = "A"
//            }
//
//            Button("Show S") {
//                self.lastNameFilter = "S"
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
