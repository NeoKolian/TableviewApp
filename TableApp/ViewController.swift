//
//  ViewController.swift
//  TableApp
//
//  Created by Nikolay Pochekuev on 11.04.2024.
//

import UIKit

class ViewController: UIViewController {

    var data: [CellModel] = (1...30).map { CellModel(number: $0) }
    var dataSource: UITableViewDiffableDataSource<Int, CellModel>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    @objc func shuffle() {
        var snapshot = dataSource.snapshot()
        let shuffledData = data.shuffled()
        snapshot.deleteAllItems()
        snapshot.appendSections([0])
        snapshot.appendItems(shuffledData)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "\(TableViewCell.self)")
        tableView.rowHeight = 40
        return tableView
    }()
}

private extension ViewController {
    func setup() {
        view.addSubview(tableView)
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Shuffle" , style: .plain, target: self, action: #selector(shuffle))
      
        title = "Table 🏓"
       
        tableView.layer.cornerRadius = 10
        tableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        tableView.delegate = self
        configureDataSource()

        makeConstraints()
    }
    
    func makeConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:  30),
            tableView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.bottomAnchor, multiplier: 0)
        ])
    }
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, CellModel>(tableView: tableView, cellProvider: { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(TableViewCell.self)", for: indexPath) as! TableViewCell
            cell.numberLabel.text = String(item.number)
            return cell
        })

        var snapshot = NSDiffableDataSourceSnapshot<Int, CellModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TableViewCell else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        if cell.isMarked != true {
            guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
            var snapshot = dataSource.snapshot()
            snapshot.moveItem(item, beforeItem: snapshot.itemIdentifiers[0])
            dataSource.apply(snapshot, animatingDifferences: true)
            cell.isMarked.toggle()
            cell.checkMarkImageView.isHidden.toggle()
        } else {
            cell.isMarked.toggle()
            cell.checkMarkImageView.isHidden.toggle()
        }
    }
}


struct CellModel: Hashable {
    let number: Int
}
