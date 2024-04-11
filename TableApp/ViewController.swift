//
//  ViewController.swift
//  TableApp
//
//  Created by Nikolay Pochekuev on 11.04.2024.
//

import UIKit

class ViewController: UIViewController {

    var data: [Int] = Array(1...30)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @objc func shuffle() {
        data.shuffle()
        tableView.reloadData()
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
        tableView.dataSource = self
        

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
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: TableViewCell = tableView.cellForRow(at: indexPath) as! TableViewCell
        tableView.deselectRow(at: indexPath, animated: true)
        
        if cell.isMaked != true {
            UIView.transition(with: tableView, duration: 0.2, options: .transitionCrossDissolve, animations: { [weak self] in
                self?.tableView.moveRow(at: indexPath, to: [0,0])
            })
            cell.isMaked.toggle()
            cell.checkMarkImageView.isHidden.toggle()
        } else {
            cell.isMaked.toggle()
            cell.checkMarkImageView.isHidden.toggle()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(TableViewCell.self)", for: indexPath) as! TableViewCell
        cell.numberLabel.text = String(data[indexPath.row])
        return cell
    }
}
