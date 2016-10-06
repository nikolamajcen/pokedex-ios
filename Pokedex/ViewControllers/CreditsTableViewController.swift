//
//  CreditsTableViewController.swift
//  Pokedex
//
//  Created by Nikola Majcen on 09/08/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class CreditsTableViewController: UITableViewController {

    let credits = [
        "Artwork": [
            ["Any Old Icons",
                "Designed by TutsPlus and distributed by Flaticon",
                "http://www.flaticon.com/packs/any-old-icons"],
            ["Multimedia Collection",
                "Designed by Gregor Cesnar and distributed by Flaticon",
                "http://www.flaticon.com/packs/multimedia-collection"],
            ["Online Shop Icon Collection",
                "Designed by Becris and distributed by Flaticon",
                "http://www.flaticon.com/packs/online-shop-icon-collection"]
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return credits.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionName = Array(credits.keys).sorted()[section]
        return (credits[sectionName]?.count)!
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionNames = Array(credits.keys).sorted()
        return sectionNames[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreditCell", for: indexPath as IndexPath)
        let sectionTitle = Array(credits.keys).sorted()[indexPath.section]
        let creditsValues = credits[sectionTitle]![indexPath.row]
        
        cell.textLabel?.text = creditsValues[0]
        cell.detailTextLabel?.text = creditsValues[1]
        cell.accessibilityHint = creditsValues[2]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        let url = cell?.accessibilityHint
        UIApplication.shared.openURL(NSURL(string: url!)! as URL)
    }
}
