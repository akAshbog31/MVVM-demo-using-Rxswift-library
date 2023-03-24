//
//  Generic+TblView.swift
//  GenericTableView
//
//  Created by mac on 11/11/22.
//

import UIKit

class ReusableTableView<Item, cell: UITableViewCell> : UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var identifire: String {
        return String(describing: cell.self)
    }
    var items:[Item]!
    var config: (Item, cell,_ index: Int) -> ()
    var selctedItem: (Item, _ index: Int) -> ()
    
    init(frame: CGRect, items: [Item], config: @escaping (Item, cell, _ index: Int) -> (), selctedItem: @escaping (Item, _ index: Int) -> ()) {
        self.items = items
        self.config = config
        self.selctedItem = selctedItem
        super.init(frame: frame, style: .plain)
        
        self.delegate = self
        self.dataSource = self
        self.register(UINib(nibName: identifire, bundle: nil), forCellReuseIdentifier: identifire)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifire, for: indexPath) as? cell else { return .init() }
        config(items[indexPath.row], cell, indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selctedItem(items[indexPath.row], indexPath.row)
    }
}
