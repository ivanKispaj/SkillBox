//
//  ViewController.swift
//  HW_20
//
//  Created by Ivan Konishchev on 03.08.2023.
//

import UIKit
import SnapKit
import CoreData

protocol UpdateTableViewDelegate: AnyObject
{
    func updateTableData(indexPath: IndexPath?)
}


enum KeyUserDefaults
{
    static let sortedType = "SortedType"
}

class ViewController: UIViewController {
    
    private var tableView: UITableView = UITableView()
    private var sortedType: Bool = false
    private lazy var dateFormatter: DateFormatter =
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    private var persistenContainer = NSPersistentContainer(name: "ExecutorModel")
    
    private lazy var fetchResultController: NSFetchedResultsController<Executors> =
    {
        let fetchRequest = Executors.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: sortedType)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistenContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }()
    
    private lazy var stackLeftItem: UIStackView =
    {
       let stackView = UIStackView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(setSortedType))
        stackView.addGestureRecognizer(tap)
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var leftItemImageView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .blue
        return imageView
    }()
    
    private var executors: [Executors] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        sortedType = UserDefaults.standard.bool(forKey: KeyUserDefaults.sortedType)
        
        
        
        persistenContainer.loadPersistentStores { persistenStoryDescription, error in
            if let error = error{
                print("Unable to load persisten storyes")
                print("\(error), \(error.localizedDescription)")
            } else
            {
                self.getTableData()
                
            }
        }
        
        tableView.register(ExecuterCell.self, forCellReuseIdentifier: "ExecuterCell")
        tableView.delegate = self
        tableView.dataSource = self
        setView()
        self.navigationItem.title = "Executor"
        self.setLeftItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addingExecutor))
    }
    
    private func setView()
    {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        let lable = UILabel()
        
        lable.text = "Sort"
        lable.textColor = .black
        stackLeftItem.addArrangedSubview(lable)
        stackLeftItem.addArrangedSubview(leftItemImageView)
        setLeftItem()
        
    }
    
    @objc private func addingExecutor()
    {
        let new = Executors.init(entity: NSEntityDescription.entity(forEntityName: "Executors", in: persistenContainer.viewContext)!, insertInto: persistenContainer.viewContext)
        let addingVC = EditCreateController()
        addingVC.executor = new
        addingVC.title = "Create new Executor"
        addingVC.updateTableDelegate = self
        self.navigationController?.pushViewController(addingVC, animated: true)
    }
    
    @objc private func setSortedType()
    {
        sortedType.toggle()
        UserDefaults.standard.set(sortedType, forKey: KeyUserDefaults.sortedType)
        let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: sortedType)
        fetchResultController.fetchRequest.sortDescriptors = [sortDescriptor]
        try? fetchResultController.managedObjectContext.save()
        getTableData()
        tableView.reloadData()
        self.setLeftItem()
    }
    
    private func getTableData()
    {
        do {
            executors = try fetchResultController.managedObjectContext.fetch(fetchResultController.fetchRequest)
            
        } catch
        {
            executors = []
        }
    }
}

//MARK: - TableView delegate and Datasourse
extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return executors.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExecuterCell", for: indexPath)  as? ExecuterCell else
        {
            preconditionFailure("Table cell dont init");
        }
        let executor = executors[indexPath.row]
        if let date = executor.date
        {
            cell.setupData(executor: executor, date: dateFormatter.string(from: date))
        } else
        {
            cell.setupData(executor: executor, date: "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let executor = self.executors[indexPath.row]
        let editVC = EditCreateController()
        editVC.executor = executor
        editVC.title = executor.firstName ?? "Create new Executor"
        editVC.indexPath = indexPath
        editVC.updateTableDelegate = self
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let executor = executors[indexPath.row]
            persistenContainer.viewContext.delete(executor)
            try? persistenContainer.viewContext.save()
            getTableData()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

//MARK: - Update Table View Delegate
extension ViewController: UpdateTableViewDelegate
{
    func updateTableData(indexPath: IndexPath? = nil) {
        
        if let indexPath = indexPath
        {
            if let cell: ExecuterCell = tableView.cellForRow(at: indexPath) as? ExecuterCell
            {
                
                let executor = executors[indexPath.row]
                cell.setupData(executor: executor, date: executor.date != nil ?  dateFormatter.string(from: executor.date!) : "" )
            } else
            {
                preconditionFailure("Failure table cell get!")
            }
        } else
        {
            getTableData()
            tableView.reloadData()
        }
    }
}


extension ViewController
{
    func setLeftItem() {

        let image = sortedType == true ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
        leftItemImageView.image = image
         //navigationItem.leftBarButtonItem = UIBarButtonItem(title: title, image: image, target: self, action: #selector(setSortedType))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: stackLeftItem)
     }
}
