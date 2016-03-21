//
//  Region.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/20/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

enum Region: Int {
  case SFBay, LosAngeles, SanDiego, Sacramento, SanJoaquin, Other

  static let allRegions = [SFBay, LosAngeles, SanDiego, Sacramento, SanJoaquin, Other]
  static let regionNames = [
    SFBay: "SF Bay",
    LosAngeles: "Los Angeles",
    SanDiego: "San Diego",
    Sacramento: "Sacramento",
    SanJoaquin: "San Joaquin",
    Other: "Other"
  ]
  static let regionImages = [
    SFBay: "san_francisco",
    LosAngeles: "los_angeles",
    SanDiego: "san_diego",
    Sacramento: "sacramento",
    SanJoaquin: "san_joaquin",
    Other: "other"
  ]

  func name() -> String {
    return Region.regionNames[self]!
  }

  func image() -> UIImage {
    return UIImage(named: Region.regionImages[self]!)!
  }

  static func getRegion(city: String) -> Region {
    return cityToRegion[city] ?? Other
  }

  static let cityToRegion = [
    // SFBay
    "Alameda": SFBay, "Albany": SFBay, "American Canyon": SFBay, "Antoich": SFBay, "Atherton": SFBay, "Belmont": SFBay,
    "Belvedere": SFBay, "Benicia": SFBay, "Berkeley": SFBay, "Brentwood": SFBay, "Brisbane": SFBay, "Burlingame": SFBay,
    "Calistoga": SFBay, "Campbell": SFBay, "Clayton": SFBay, "Cloverdale": SFBay, "Colma": SFBay, "Concord": SFBay,
    "Corte Madera": SFBay, "Cotati": SFBay, "Cupertino": SFBay, "Daly City": SFBay, "Danville": SFBay, "Dixon": SFBay,
    "Dublin": SFBay, "East Palo Alto": SFBay, "El Cerrito": SFBay, "Emeryville": SFBay, "Fairfax": SFBay,
    "Fairfield": SFBay, "Foster City": SFBay, "Fremont": SFBay, "Gilroy": SFBay, "Half Moon Bay": SFBay,
    "Hayward": SFBay, "Healdsburg": SFBay, "Hercules": SFBay, "Hillsborough": SFBay, "Lafayette": SFBay,
    "Larkspur": SFBay, "Livermore": SFBay, "Los Altos": SFBay, "Los Altos Hills": SFBay, "Los Gatos": SFBay,
    "Martinez": SFBay, "Menlo Park": SFBay, "Mill Valley": SFBay, "Millbrae": SFBay, "Milpitas": SFBay,
    "Monte Sereno": SFBay, "Moraga": SFBay, "Morgan Hill": SFBay, "Mountain View": SFBay, "Napa": SFBay,
    "Newark": SFBay, "Novato": SFBay, "Oakland": SFBay, "Oakley": SFBay, "Orinda": SFBay, "Pacifica": SFBay,
    "Palo Alto": SFBay, "Petaluma": SFBay, "Piedmont": SFBay, "Pinole": SFBay, "Pittsburg": SFBay,
    "Pleasant Hill": SFBay, "Pleasanton": SFBay, "Portola Valley": SFBay, "Redwood City": SFBay, "Richmond": SFBay,
    "Rio Vista": SFBay, "Rohnert Park": SFBay, "Ross": SFBay, "St. Helena": SFBay, "San Anselmo": SFBay,
    "San Bruno": SFBay, "San Carlos": SFBay, "San Francisco": SFBay, "San Jose": SFBay, "San Leandro": SFBay,
    "San Mateo": SFBay, "San Pablo": SFBay, "San Rafael": SFBay, "San Ramon": SFBay, "Santa Clara": SFBay,
    "Saratoga": SFBay, "Sausalito": SFBay, "Sebastopol": SFBay, "Sonoma": SFBay, "South San Francisco": SFBay,
    "Suisun City": SFBay, "Sunnyvale": SFBay, "Tiburon": SFBay, "Union City": SFBay, "Vacaville": SFBay,
    "Vallejo": SFBay, "Walnut Creek": SFBay, "Windsor": SFBay, "Woodside": SFBay, "Yountville": SFBay

    // LosAngeles
  ]

}
