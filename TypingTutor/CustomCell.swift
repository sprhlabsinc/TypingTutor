//
//  CustomCell.swift
//  TypingTutor
//
//  Created by Sergey Lukjanov on 4/24/17.
//  Copyright © 2017 JinHe Wang. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    @IBOutlet weak var speed1Txt: UILabel!
    @IBOutlet weak var name1Txt: UILabel!
    @IBOutlet weak var speedTxt: UILabel!
    @IBOutlet weak var nameTxt: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
