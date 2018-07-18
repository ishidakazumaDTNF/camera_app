//
//  ViewController.swift
//  camera_app
//
//  Created by 石田一馬 on 2018/02/09.
//  Copyright © 2018年 HAL. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    @IBOutlet weak var pictureImage: UIImageView!
    var originalImage: UIImage!
    
    var btncount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        let alertController = UIAlertController(title:"フォト",message:"選択してください", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title:"カメラ", style: .default, handler:{(action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let ipc = UIImagePickerController()
                ipc.sourceType = UIImagePickerControllerSourceType.camera;
                ipc.delegate = self
                self.present(ipc, animated: true,completion: nil)
            }
        })
        alertController.addAction(cameraAction)
        
        let photolibraryAction = UIAlertAction(title:"フォトライブラリ", style: .default, handler:{(action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let ipc = UIImagePickerController()
                ipc.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                ipc.delegate = self
                self.present(ipc, animated: true,completion: nil)
            }
        })
        alertController.addAction(photolibraryAction)

        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true , completion: nil)
    }

    //
    func imagePickerController(_ picker:UIImagePickerController,didFinishPickingMediaWithInfo info:[String : Any]){
        pictureImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        originalImage = pictureImage.image!
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func effectbtn(_ sender: Any) {
        var effectImage = originalImage
        
        let inputImage = CIImage(image: effectImage!)
        
        let rotate = effectImage?.imageOrientation
        
        let filterNames = [
            "CIPhotoEffectMono",
            "CIPhotoEffectChrome",
            "CIPhotoEffectFade",
            "CIPhotoEffectInstant",
            "CIPhotoEffectNoir",
            "CIPhotoEffectProcess",
            "CIPhotoEffectTonal",
            "CIPhotoEffectTransfer",
            "CISepiaTone"
        ]
        
        //引数で指定されたフィルタの種類を指定してCIFilterインスタンスを取得
        let effectFilter:CIFilter! = CIFilter(name: filterNames[btncount])

        btncount = btncount + 1
        
        if btncount == 8 {
            btncount = 0
        }
        
        //エフェクトパラメータを初期化
        effectFilter.setDefaults()
        //インスタンスにエフェクトする元画像を設定
        effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
        //エフェクト後のCIImage形式の画像を取り出す
        let outputImage:CIImage! = effectFilter.outputImage
        //CIContextのインスタンスを取得。画像を加工するための領域を確保
        let ciContext = CIContext(options: nil)
        //エフェクト後の画像をCIContext上に描画し、結果をcgImageとしてCGImage形式の画像 を取得
        let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent)
        //エフェクト後の画像をCGImage形式の画像からUIImage形式の画像に回転度を指定して変換
        effectImage = UIImage(cgImage: cgImage!, scale: 1.0, orientation:
            rotate!)
        
            pictureImage.image = effectImage

    }
    

    //↓保存押されてからの処理
    @IBAction func gopicture(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(pictureImage.image!, self,
        #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error == nil {
            let ac = UIAlertController(title: "保存しました", message: "フォトアルバムを確認してください", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "保存出来ませんでした", message: error?.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default,
                                       handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

