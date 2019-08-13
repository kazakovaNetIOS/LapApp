//
//  ViewController.swift
//  LapApp
//
//  Created by Natalia Kazakova on 13/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let cellIdentifier = "lapCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

//MARK: - Actions
/***************************************************************/

extension ViewController {
    @IBAction func addLap(_ sender: UIBarButtonItem) {
    }
}


//MARK: - UITableViewDataSource
/***************************************************************/

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
