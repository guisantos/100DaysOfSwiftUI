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
    @State var sort = [NSSortDescriptor(key: "lastName", ascending: true)]
    
    @State var fullNameFilter = "U"
    @State var sortCountry = [NSSortDescriptor(key: "fullName", ascending: true), NSSortDescriptor(key: "shortName", ascending: true)]
    
    @State var predicate = Predicates.beginsWith
    
    var body: some View {
        VStack {
            FilteredList(filterKey: "fullName",
                         filterValue: fullNameFilter,
                         enumPredicate: predicate,
                         sort: sortCountry) { (country: Country) in
                            ForEach(country.candyArray, id: \.self) { candy in
                                VStack(alignment: .leading) {
                                    Text(candy.wrappedName)
                                        .font(.headline)
                                    
                                    Text(country.wrappedShortName)
                                        .foregroundColor(.secondary)
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
                
                let candy5 = Candy(context: self.moc)
                candy5.name = "Snickers"
                candy5.origin = Country(context: self.moc)
                candy5.origin?.shortName = "USA"
                candy5.origin?.fullName = "United States of America"
                
                let candy6 = Candy(context: self.moc)
                candy6.name = "Sockerbitar"
                candy6.origin = Country(context: self.moc)
                candy6.origin?.shortName = "SE"
                candy6.origin?.fullName = "Sweden"
                
                try? self.moc.save()
            }
            
            Spacer()
            
            HStack(spacing: 10) {
                Button("Begin with A") {
                    self.predicate = Predicates.beginsWith
                    self.fullNameFilter = "U"
                }
                
                Button("Begin with S") {
                    self.predicate = Predicates.beginsWith
                    self.fullNameFilter = "S"
                }
                
                Button("Contains N") {
                    self.predicate = Predicates.contains
                    self.fullNameFilter = "n"
                }
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
