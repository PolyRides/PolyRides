//
//  Region.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/20/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

enum Region: Int {
  case CentralCoast, SFBay, LosAngeles, OrangeCounty, SanDiego, Sacramento, Other

  static let allRegions = [CentralCoast, SFBay, LosAngeles, OrangeCounty, SanDiego, Sacramento, Other]
  static let regionNames = [
    CentralCoast: "Central Coast",
    SFBay: "SF Bay",
    LosAngeles: "Los Angeles",
    OrangeCounty: "Orange County",
    SanDiego: "San Diego",
    Sacramento: "Sacramento",
    Other: "Other"
  ]
  static let regionImages = [
    SFBay: "san_francisco",
    LosAngeles: "los_angeles",
    CentralCoast: "central_coast",
    SanDiego: "san_diego",
    Sacramento: "sacramento",
    OrangeCounty: "orange_county",
    Other: "other"
  ]

  func name() -> String {
    return Region.regionNames[self]!
  }

  func referenceName() -> String {
    if self == CentralCoast {
      return "the \(name())"
    } else if self == SFBay {
      return "the \(name()) Area"
    } else {
      return name()
    }
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
    "Vallejo": SFBay, "Walnut Creek": SFBay, "Windsor": SFBay, "Woodside": SFBay, "Yountville": SFBay,

    // LosAngeles
    "Agoura Hills": LosAngeles, "Alhambra": LosAngeles, "Arcadia": LosAngeles, "Artesia": LosAngeles,
    "Avalon": LosAngeles, "Azusa": LosAngeles, "Baldwin Park": LosAngeles, "Bell": LosAngeles,
    "Bell Gardens": LosAngeles, "Bellflower": LosAngeles, "Beverly Hills": LosAngeles, "Bradbury": LosAngeles,
    "Burbank": LosAngeles, "Calabasas": LosAngeles, "Carson": LosAngeles, "Cerritos": LosAngeles,
    "Claremont": LosAngeles, "Commerce": LosAngeles, "Compton": LosAngeles, "Covina": LosAngeles, "Cudahy": LosAngeles,
    "Culver City": LosAngeles, "Diamond Bar": LosAngeles, "Downey": LosAngeles, "Duarte": LosAngeles,
    "El Monte": LosAngeles, "El Segundo": LosAngeles, "Gardena": LosAngeles, "Glendale": LosAngeles,
    "Glendora": LosAngeles, "Hawaiian Gardens": LosAngeles, "Hawthorne": LosAngeles, "Hermosa Beach": LosAngeles,
    "Hidden Hills": LosAngeles, "Huntington Park": LosAngeles, "Industry": LosAngeles, "Inglewood": LosAngeles,
    "Irwindale": LosAngeles, "La Cañada Flintridge": LosAngeles, "La Habra Heights": LosAngeles,
    "La Mirada": LosAngeles, "La Puente": LosAngeles, "La Verne": LosAngeles, "Lakewood": LosAngeles,
    "Lawndale": LosAngeles, "Lomita": LosAngeles, "Long Beach": LosAngeles, "Los Angeles": LosAngeles,
    "Lynwood": LosAngeles, "Malibu": LosAngeles, "Manhattan Beach": LosAngeles, "Maywood": LosAngeles,
    "Monrovia": LosAngeles, "Montebello": LosAngeles, "Monterey Park": LosAngeles, "Norwalk": LosAngeles,
    "Palmdale": LosAngeles, "Palos Verdes Estates": LosAngeles, "Paramount": LosAngeles, "Pasadena": LosAngeles,
    "Pico Rivera": LosAngeles, "Pomona": LosAngeles, "Rancho Palos Verdes": LosAngeles, "Redondo Beach": LosAngeles,
    "Rolling Hills": LosAngeles, "Rolling Hills Estates": LosAngeles, "Rosemead": LosAngeles, "": LosAngeles,
    "San Dimas": LosAngeles, "San Fernando": LosAngeles, "San Gabriel": LosAngeles, "San Marino": LosAngeles,
    "Santa Clarita": LosAngeles, "Santa Fe Springs": LosAngeles, "Santa Monica": LosAngeles, "Sierra Madre": LosAngeles,
    "Signal Hill": LosAngeles, "South El Monte": LosAngeles, "South Gate": LosAngeles, "South Pasadena": LosAngeles,
    "Temple City": LosAngeles, "Torrance": LosAngeles, "Vernon": LosAngeles, "Walnut": LosAngeles,
    "West Covina": LosAngeles, "West Hollywood": LosAngeles, "Westlake Village": LosAngeles, "Whittier": LosAngeles,

    // CentralCoast
    "Morro Bay": CentralCoast, "Arroyo Grande": CentralCoast, "Paso Robles": CentralCoast, "Pismo Beach": CentralCoast,
    "San Luis Obispo": CentralCoast, "Grover Beach": CentralCoast, "Avila Beach": CentralCoast,
    "Cambria": CentralCoast, "San Miguel": CentralCoast, "San Simeon": CentralCoast, "Santa Margarita": CentralCoast,
    "Nipomo": CentralCoast, "Cayucos": CentralCoast, "Harmony": CentralCoast, "Los Osos": CentralCoast,
    "Shandon": CentralCoast, "Templeton": CentralCoast,

    // SanDiego
    "Carlsbad": SanDiego,"Chula Vista": SanDiego, "Coronado": SanDiego, "Del Mar": SanDiego, "El Cajon": SanDiego,
    "Encinitas": SanDiego, "Escondido": SanDiego, "Imperial Beach": SanDiego, "La Mesa": SanDiego,
    "Lemon Grove": SanDiego, "National City": SanDiego, "Oceanside": SanDiego, "Poway": SanDiego, "San Diego": SanDiego,
    "San Marcos": SanDiego, "Santee": SanDiego, "Solana Beach": SanDiego, "Vista": SanDiego,

    // Sacramento
    "Citrus Heights": Sacramento, "Elk Grove": Sacramento, "Folsom": Sacramento, "Galt": Sacramento,
    "Isleton": Sacramento, "Rancho Cordova": Sacramento, "Sacramento": Sacramento, "Antelope": Sacramento,
    "Arden Arcade": Sacramento, "Carmichael": Sacramento, "Clay": Sacramento, "Courtland": Sacramento,
    "Elverta": Sacramento, "Fair Oaks": Sacramento, "Florin": Sacramento, "Foothill Farms": Sacramento,
    "Franklin": Sacramento, "Freeport": Sacramento, "Fruitridge Pocket": Sacramento, "Gold River": Sacramento,
    "Herald": Sacramento, "Hood": Sacramento, "La Riviera": Sacramento, "Lemon Hill": Sacramento, "Mather": Sacramento,
    "McClellan Park": Sacramento, "North Highlands": Sacramento, "Orangevale": Sacramento, "Parkway": Sacramento,
    "Rancho Murieta": Sacramento, "Rio Linda": Sacramento, "Rosemont": Sacramento, "Vineyard": Sacramento,
    "Walnut Grove": Sacramento, "Wilton": Sacramento, "Locke": Sacramento,

    // OrangeCounty
    "Orange": OrangeCounty, "Aliso Viejo": OrangeCounty, "Anaheim": OrangeCounty, "Brea": OrangeCounty,
    "Buena Park": OrangeCounty, "Costa Mesa": OrangeCounty, "Cypress": OrangeCounty, "Dana Point": OrangeCounty,
    "Fountain Valley": OrangeCounty, "Fullerton": OrangeCounty, "Garden Grove": OrangeCounty,
    "Huntington Beach": OrangeCounty, "Irvine": OrangeCounty, "La Habra": OrangeCounty, "La Palma": OrangeCounty,
    "Laguna Beach": OrangeCounty, "Laguna Hills": OrangeCounty, "Laguna Niguel": OrangeCounty,
    "Laguna Woods": OrangeCounty, "Lake Forest": OrangeCounty, "Los Alamitos": OrangeCounty,
    "Mission Viejo": OrangeCounty, "Newport Beach": OrangeCounty, "Placentia": OrangeCounty,
    "Rancho Santa Margarita": OrangeCounty, "San Clemente": OrangeCounty, "San Juan Capistrano": OrangeCounty,
    "Santa Ana": OrangeCounty, "Seal Beach": OrangeCounty, "Stanton": OrangeCounty, "Tustin": OrangeCounty,
    "Villa Park": OrangeCounty, "Westminster": OrangeCounty, "Yorba Linda": OrangeCounty, "Coto de Caza": OrangeCounty,
    "Emerald Bay": OrangeCounty, "Ladera Ranch": OrangeCounty, "Las Flores": OrangeCounty, "Midway City": OrangeCounty,
    "Modjeska Canyon": OrangeCounty, "North Tustin": OrangeCounty, "Cowan Heights": OrangeCounty,
    "Lemon Heights": OrangeCounty, "Red Hill": OrangeCounty, "Rancho Mission Viejo": OrangeCounty,
    "Rossmoor": OrangeCounty, "Olive": OrangeCounty, "Orange Park Acres": OrangeCounty, "Silverado": OrangeCounty,
    "Trabuco Canyon": OrangeCounty, "Orange County": OrangeCounty,
  ]

}
