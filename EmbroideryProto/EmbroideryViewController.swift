//
//  ViewController.swift
//  EmbroideryProto
//
//  Created by Mark Siffer on 1/14/17.
//  Copyright © 2017 Mark Siffer. All rights reserved.
//

import UIKit

class EmbroideryViewController: UIViewController {
    
    
    @IBOutlet weak var txtFile: UITextField!
    @IBOutlet weak var stitchView: StitchView! {
        didSet {
            stitchView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: stitchView,
                action: #selector(StitchView.changeScale(_:))
            ))
        }
    }
    
    
    func loadFile(_ theurl : URL) {
        BinaryHelper.load(url: theurl,
                          completion: {file in
                            var pattern : EmbPattern
                            let fileextension = String(file.filename).suffix(3).lowercased()
                            var reader : FormatProtocol? = nil
                            if fileextension == "exp"  {
                                reader = FormatExp()
                            } else if fileextension == "pcs" {
                                reader = FormatPcs()
                            } else if fileextension == "pec" {
                                reader = FormatPec()
                            } else if fileextension == "pes" {
                                reader = FormatPes()
                            }
                            if reader != nil {
                                pattern = (reader?.read(file: file))!
                            } else {
                                pattern = EmbPattern()
                            }
                            
                            DispatchQueue.main.async {
                                self.stitchView.setPattern(pattern)
                                self.stitchView.setNeedsDisplay()
                            }
        })
    }
    
    @IBAction func btnDraw(_ sender: UIButton) {
        loadFile(URL(string: self.txtFile.text!)!)
    }
}

