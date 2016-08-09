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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return credits.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CreditCell", forIndexPath: indexPath)
        cell.textLabel?.text = credits[indexPath.row][0]
        cell.detailTextLabel?.text = credits[indexPath.row][1]
        cell.accessibilityHint = credits[indexPath.row][2]
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let url = cell?.accessibilityHint
        UIApplication.sharedApplication().openURL(NSURL(string: url!)!)
    }
}