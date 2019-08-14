//
//  ViewController.swift
//  LapApp
//
//  Created by Natalia Kazakova on 13/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    fileprivate let cellIdentifier = "lapCellIdentifier"
    fileprivate var isStarted: Bool = false
    fileprivate var dateStart: Date?
    fileprivate var dateStop: Date?
    fileprivate var fetchedResultsController: NSFetchedResultsController<Lap>?
    
    var backgroundContext: NSManagedObjectContext!
    var context: NSManagedObjectContext! {
        didSet {
            print("Context did set")
            setupFetchedResultsController(for: context)
            fetchData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObservers()
    }
}

//MARK: - Setup views
/***************************************************************/

extension ViewController {
    private func setupViews() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.beginRefreshing()
        addButton.isEnabled = false
    }
}

//MARK: - Add observers
/***************************************************************/

extension ViewController {
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(managedObjectContextDidSave(notification:)),
                                               name: NSNotification.Name.NSManagedObjectContextDidSave,
                                               object: nil)
    }
}

//MARK: - Selector methods
/***************************************************************/

extension ViewController {
    @objc func managedObjectContextDidSave(notification: Notification) {
        context.perform {
            self.context.mergeChanges(fromContextDidSave: notification)
        }
    }
}

//MARK: - Setup fetched results controller
/***************************************************************/

extension ViewController {
    func setupFetchedResultsController(for context: NSManagedObjectContext) {
        let sortDescriptor = NSSortDescriptor(key: "timeLap", ascending: true)
        let request: NSFetchRequest<Lap> = Lap.fetchRequest()
        request.sortDescriptors = [ sortDescriptor ]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController?.delegate = self
    }
}

//MARK: - Fetch data
/***************************************************************/

extension ViewController {
    func fetchData() {
        print("Fetch data")
        do {
            try fetchedResultsController?.performFetch()
            tableView.refreshControl?.endRefreshing()
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
}

//MARK: - NSFetchedResultsControllerDelegate
/***************************************************************/

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
}


//MARK: - Actions
/***************************************************************/

extension ViewController {
    @IBAction func addLap(_ sender: UIBarButtonItem) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            
            self.dateStop = Date()
            let lapInterval = self.dateStop!.timeIntervalSince(self.dateStart!)
            self.dateStart = self.dateStop
            
            let lap = Lap(context: self.backgroundContext)
            lap.timeLap = lapInterval.hourMinuteSecondMS
            
            print("Lap did add")
            self.backgroundContext.performAndWait {
                do {
                    try self.backgroundContext.save()
                    print("Context did save")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if isStarted {
            dateStop = Date()
            dateStart = nil
            title = "Результаты"
            sender.setTitle("Старт", for: .normal)
            addButton.isEnabled = false
        } else {
            dateStart = Date()
            dateStop = nil
            title = "Время пошло"
            sender.setTitle("Стоп", for: .normal)
            addButton.isEnabled = true
        }
        isStarted = !isStarted
    }
}


//MARK: - UITableViewDataSource
/***************************************************************/

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else {
            return 0
        }
        
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        guard let lap = fetchedResultsController?.object(at: indexPath) else {
                return cell
        }
        
        cell.textLabel?.text = lap.timeLap
        return cell
    }
}
