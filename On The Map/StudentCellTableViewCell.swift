//
//  StudentCellTableViewCell.swift
//  On The Map
//
// Copyright © 2019 AH Abdalah. All rights reserved.


import UIKit

class StudentCellTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var url: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
