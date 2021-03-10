/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main view controller for the AR experience.
*/
import UIKit
import ARKit
import ARVideoKit
import Photos
import SSZipArchive

class SCNViewController: UIViewController, ARSessionDelegate, ARSCNViewDelegate, RenderARDelegate, RecordARDelegate  {
    var fileName : String?
    var filePath : URL?
    var writer : JSONWriter?
    var gridcount : Int = 0
    var H : Int = 10
    var N : Int = 200
    var M : Int = 400
    var gridcounter: Int = 0
    var timer = Timer()
    var gridwriter : JSONWriter?
    var experimentSequence : [[CGFloat]] = [[]]
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var dot : UITextView = UITextView()
    //var dot : UIView?
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var recordBtn: UIButton!
    @IBOutlet var pauseBtn: UIButton!
    //@IBOutlet var gridview: UICollectionView!
    //@IBOutlet var testView: UIView!
    
    var dataSource: [String] = ["Ioannis", "Minos", "Marc"]
    //open var collectionView: UICollectionView!
    
    //var arses: ARSession!
    var recorder:RecordAR?
    //var stackView = GridView(rowSize:2, rowHeight: 140, verticalSpacing: 15, horizontalSpacing: 15)
    
    var contentControllers: [VirtualContentType: VirtualContentController] = [:]
    
    var selectedVirtualContent: VirtualContentType? {
        
            
            // Remove existing content when switching types.
            //contentControllers[oldValue]?.contentNode?.removeFromParentNode()
            
            // If there's an anchor already (switching content), get the content controller to place initial content.
            // Otherwise, the content controller will place it in `renderer(_:didAdd:for:)`.
            if let anchor = currentFaceAnchor, let node = sceneView.node(for: anchor),
                let newContent = selectedContentController.renderer(sceneView, nodeFor: anchor) {
                node.addChildNode(newContent)
            }
        return 0 as? VirtualContentType
        
    }
    var selectedContentController: VirtualContentController { return TransformVisualization()
        
    }
    var currentFaceAnchor: ARFaceAnchor?
    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
//        return dataSource.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
//        var cell = UICollectionViewCell()
//        if let nameCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell {
//            nameCell.configure(with: dataSource[indexPath.row])
//            cell = nameCell
//        }
//        return cell
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setToolbarHidden(true, animated: false)
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.session.delegate=self
        //arses.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        //sceneView.scene = scene
        //sceneView.scene.rootNode.scale = SCNVector3(0.2, 0.2, 0.2)
        //
        sceneView.automaticallyUpdatesLighting = true
        sceneView.autoenablesDefaultLighting = true
        
        self.experimentSequence = [[]]
        
        // Initialize ARVideoKit recorder


        recorder = RecordAR(ARSceneKit: sceneView)
        
        /*----👇---- ARVideoKit Configuration ----👇----*/
        
        // Set the recorder's delegate
        recorder?.delegate = self
        //print(recorder?.currentVideoPath)

        // Set the renderer's delegate
        recorder?.renderAR = self
        
        // Configure the renderer to perform additional image & video processing 👁
        recorder?.onlyRenderWhileRecording = false
        
        // Configure ARKit content mode. Default is .auto
        recorder?.contentMode = .aspectFill
        
        //record or photo add environment light rendering, Default is false
        recorder?.enableAdjustEnvironmentLighting = true
        
        // Set the UIViewController orientations
        recorder?.inputViewOrientations = [.landscapeLeft, .landscapeRight, .portrait]
        // Configure RecordAR to store media files in local app directory
        recorder?.deleteCacheWhenExported = false
        recorder?.enableAudio = true
        recorder?.fps = .fps30
        
        let countdown = UITextView()
        countdown.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        countdown.frame = CGRect(x: 0, y: 350, width: 414, height: 896)
        self.view.addSubview(countdown)
        countdown.textColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        countdown.font = UIFont(name: "Thonburi", size: 40)
        countdown.textAlignment = NSTextAlignment(CTTextAlignment.center)
        
        var secondsRemaining = 10
            
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if secondsRemaining > 0 {
                print ("\(secondsRemaining) seconds")
                countdown.text = (String(secondsRemaining))
                secondsRemaining -= 1
            } else {
                countdown.textColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0)
                Timer.invalidate()
                self.view.addSubview(self.dot)
                self.scheduledTimerWithTimeInterval()
                self.record()
            }
        }
        //sleep(500)
        
        //self.view.willRemoveSubview(countdown)
        let screenSize: CGRect = UIScreen.main.bounds
        
        print(screenSize.height)
        //896.0
        //414.0
        print(screenSize.width)
        
        
        
        self.recordBtn.alpha = 0
        self.pauseBtn.alpha = 0
        
        
        
        
        //self.dot.addConstraint(T##constraint: NSLayoutConstraint##NSLayoutConstraint)
        
        //self.dot.frame.origin.y = 400
        
        let matrix = gridmatrix(a: 24, b: 12, c:100)
        
        
        
        matrix.calcCoords()
        matrix.grid = matrix.generateMatrix()
        prepareExperimentSequence(matrix : matrix)
        matrix.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        
        self.dot.frame = CGRect(x: matrix.mcoords[1]/4, y: matrix.ncoords[1]/4, width: matrix.mcoords[1]/2, height:matrix.ncoords[1]/2)
        //self.dot.text = ("•")
        //self.dot.textColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        //self.dot.font = UIFont(name: "Thonburi", size: 10)
        //self.dot.textAlignment = NSTextAlignment(CTTextAlignment.center)
        self.dot.backgroundColor = UIColor (red: 1, green: 0, blue: 0, alpha: 1)
        self.dot.alpha = 1
        self.dot.layer.cornerRadius = self.dot.frame.size.width/2
        
        

        self.view.addSubview(matrix)
        //self.filldots(matrix: matrix)
        //self.view.addSubview(path)
        
        
   
        
    }
    
    func prepareExperimentSequence(matrix : gridmatrix){
        
        for item in matrix.grid{
            for i in item {
                self.experimentSequence.append(i)
            }
        }
        
        self.experimentSequence.shuffle()
        
        
    }
    
    @objc func updateDotPosition(){
        let screenSize: CGRect = UIScreen.main.bounds
            
            if (gridcounter < 10){
        let a = experimentSequence.removeLast()
                
                if let first = a.first, let last = a.last {
                    self.slidedot(a: first, b: last)
                }
            
                
        
                gridcounter += 1
                
        print(a)
            }
        
        else{
            //print("end of experiment")
            self.record()
        }
        
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(SCNViewController.updateDotPosition), userInfo: nil, repeats: true)
    }

    func showdot( a: CGFloat, b: CGFloat){

        //print("hola")
        UIView.animate(withDuration: 0, delay: 0, options:[], animations: {
            self.dot.transform = CGAffineTransform(translationX: b, y: a)
            //let dotframe = [[dot.layer.presentationLayer] frame]
            //var currentFrame = self.dot.layer.presentation()?.frame
            //print(currentFrame)
            }, completion: nil)
        
        registerDot(x: a, y: b, radius: 0.5)
        //self.dot.frame.origin.x = b

    }
    
    func showletter(a: CGFloat, b: CGFloat){
        //self.dot.text = ("6")
        //self.dot.text = ("•")
        let randomInt = Int.random(in: 1...200)
        if randomInt < 10{
            self.dot.text = (String(randomInt))
        }
        else{
            self.dot.text = ("•")
        }
        UIView.animate(withDuration: 0, delay: 2, options:[], animations: {
            //self.dot.attributedText
            //let dotframe = [[dot.layer.presentationLayer] frame]
            
            //var currentFrame = self.dot.layer.presentation()?.frame
            //print(currentFrame)
            }, completion: nil)
        
        
    }
    
    func filldots(matrix: gridmatrix){
        for item in self.experimentSequence{
            self.experimentSequence.removeLast()
            let d = UIView()
            d.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0)
            d.frame = CGRect(x: matrix.mcoords[1]/4, y: matrix.ncoords[1]/4, width: matrix.mcoords[1]/2, height:matrix.ncoords[1]/2)
            d.backgroundColor = UIColor (red: 1, green: 0, blue: 0, alpha: 1)
            d.alpha = 1
            d.layer.cornerRadius = d.frame.size.width/2
            self.view.addSubview(d)
        }
        
        
    }
    
    
    func fadeTo(a: CGFloat, b: CGFloat){
        UIView.animate(withDuration: 1, delay: 0, options:[], animations: {
                self.dot.alpha = 0
            
            
            }, completion: nil)
        self.showdot(a:a, b:b)
        UIView.animate(withDuration: 1, delay: 0, options:[], animations: {
                self.dot.alpha = 1
            self.showdot(a:a, b:b)
            
            }, completion: nil)
    }
    
    func slidedot( a: CGFloat, b: CGFloat){

        //print("hola")
        UIView.animate(withDuration: 1, delay: 1, options:[], animations: {
            self.dot.transform = CGAffineTransform(translationX: b, y: a)
            //let dotframe = [[dot.layer.presentationLayer] frame]
            var currentFrame = self.dot.layer.presentation()?.frame
            print(currentFrame)
            }, completion: nil)
        
        registerDot(x: a, y: b, radius: 0.5)
        self.showletter(a:a, b:b)
        //self.dot.frame.origin.x = b

    }
    
    var contentNode: SCNNode?
    
    // Load multiple copies of the axis origin visualization for the transforms this class visualizes.
    var rightEyeNode = SCNReferenceNode()
    lazy var leftEyeNode = SCNReferenceNode()
    lazy var lookAt = SCNReferenceNode()
    
    /// - Tag: ARNodeTracking
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        // This class adds AR content only for face anchors.
        guard anchor is ARFaceAnchor else { return nil }
        
        // Load an asset from the app bundle to provide visual content for the anchor.
        contentNode = SCNReferenceNode()
        
        // Add content for eye tracking in iOS 12.
        self.addEyeTransformNodes()
        
        // Provide the qnode to ARKit for keeping in sync with the face anchor.
        return contentNode
    }
    
    let commsManager = CommsManager()
    
    func zipfiles() {
        
        
        
        DispatchQueue.global(qos: .utility).async{
            
        
        
        let urlmp2 = self.recorder?.getVideoPath()
        let urlmp3 = (urlmp2?.lastPathComponent)!
        let urlmp4 = String(urlmp3)
        let urlmp = self.getDocumentsDirectory().appendingPathComponent(urlmp4)//"2020-12-03@13-05-27GMT+01:00ARVideo.mp4")
            
            self.commsManager.addElement(elementURL: urlmp)
            
            //wait(DispatchSemaphore)
            //let s = self.recorder?.getSemaphore()
            //s!.wait()
//            while(self.recorder?.status != .readyToRecord){
//            print("haha")
//        }
            
            //self.commsManager.sendElement(elementURL: urlmp)
       // self.appDelegate.fTSensingSession.FTMW.sendRequestVideo(fileURL: urlmp)

        }
        DispatchQueue.global(qos: .utility).async{
            
        //let urlcsv =  self.appDelegate.fTSensingSession.zipData()
        let fileManager = FileManager()
            let currentWorkingPath = self.getDocumentsDirectory()
        var sourceURL = URL(fileURLWithPath: currentWorkingPath.absoluteString)
        var fn = self.fileName!
        fn.append("_AR")
        sourceURL.appendPathComponent(fn)
        sourceURL.appendPathExtension("json")
        var destinationURL = URL(fileURLWithPath: currentWorkingPath.absoluteString)
        destinationURL.appendPathComponent(fn)
        destinationURL.appendPathExtension("zip")
            let urlcsv =  self.appDelegate.fTSensingSession.zipData()
            
                self.commsManager.addElement(elementURL: urlcsv)
                self.commsManager.sendElement(elementURL: urlcsv)
                
            self.commsManager.addElement(elementURL: urlcsv)
            self.commsManager.addElement(elementURL: destinationURL)
        do {
            try fileManager.zipItem(at: sourceURL, to: destinationURL)
        } catch {
            print("Creation of ZIP archive failed with error:\(error)")
        }
            
           // self.commsManager.sendElement(elementURL: destinationURL)
            //self.commsManager.sendElement(elementURL: urlcsv)
        //self.appDelegate.fTSensingSession.FTMW.sendRequestJson(fileURL: destinationURL)
        //self.appDelegate.fTSensingSession.FTMW.sendRequestRequest(fileURL: urlcsv)
        }
        
        
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard #available(iOS 12.0, *), let faceAnchor = anchor as? ARFaceAnchor
            else { return }
        
            self.rightEyeNode.simdTransform = faceAnchor.rightEyeTransform
            self.leftEyeNode.simdTransform = faceAnchor.leftEyeTransform
            self.lookAt.simdPosition = faceAnchor.lookAtPoint
        //print(faceAnchor.rightEyeTransform)
        //print(faceAnchor.lookAtPoint)
        let exampleDict: [String: Any?] = [
            "TimeIntervalSince1970" : Date().timeIntervalSince1970,
            "RightEyeTransform" : faceAnchor.rightEyeTransform.debugDescription,         // type: String
            "LeftEyeTeansform" : faceAnchor.leftEyeTransform.debugDescription,             // type: Bool
            "LookAtPoint" : faceAnchor.lookAtPoint.debugDescription,              // type: Int
            "blender" : faceAnchor.blendShapes.debugDescription,    // type: e.g. struct Person: Codable {...}
            //"geometry" : faceAnchor.geometry.textureCoordinates.debugDescription,   // type: e.g. class Human: NSObject, NSCoding {...}
            ]
        
        if let jsonString = JSONStringEncoder().encode(exampleDict) {
                self.writer?.write(jsonString)
            } else {
                // Failed creating JSON string.
                // ...
            }
            //self.registerDot(x:1, y: 1, radius: 1)
        
        self.gridcount+=1
        if self.gridcount / 90 == 1{
            
            changedotposition()
            self.gridcount = 0
            
        }
        
        
    }
    
    func changedotposition(){
        
    }
    
    func addEyeTransformNodes() {
        guard #available(iOS 12.0, *), let anchorNode = contentNode else { return }
        
        // Scale down the coordinate axis visualizations for eyes.
        rightEyeNode.simdPivot = float4x4(diagonal: SIMD4<Float>(3, 3, 3, 1))
        leftEyeNode.simdPivot = float4x4(diagonal: SIMD4<Float>(3, 3, 3, 1))
        //lookAt.simdWorldPosition =  float3()
        //print(rightEyeNode.simdPivot)
        anchorNode.addChildNode(rightEyeNode)
        anchorNode.addChildNode(leftEyeNode)
        //anchorNode.addChildNode(lookAt)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        //let configuration = ARWorldTrackingConfiguration()
        let configuration2 = ARFaceTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration2)
        
        // Prepare the recorder with sessions configuration
        recorder?.prepare(configuration2)
        
        
        
    }
    
    func session(_ arses: ARSession, didUpdate frame: ARFrame) {
        
        //let faceAnchors = frame.anchors.compactMap { $0 as? ARFaceAnchor }
        //sceneView.session.add(anchor: ARFaceAnchor)
        //print("hola")
        
    }
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
//        currentFaceAnchor = faceAnchor
//
//        // If this is the first time with this anchor, get the controller to create content.
//        // Otherwise (switching content), will change content when setting `selectedVirtualContent`.
//        if node.childNodes.isEmpty, let contentNode = selectedContentController.renderer(renderer, nodeFor: faceAnchor) {
//            node.addChildNode(contentNode)
//        }
//
//       // print(selectedContentController.rightEyeNode.simdPivot)
//    }
    

    

    
    
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        //anchors.compactMap { $0 as? ARFaceAnchor }.forEach { headPreview?.update(with: $0) }
    }
    
    func update(with faceAnchor: ARFaceAnchor){
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Pause the view's session
        sceneView.session.pause()
        
        if recorder?.status == .recording {
            recorder?.stopAndExport()
        }
        recorder?.onlyRenderWhileRecording = true
        recorder?.prepare(ARFaceTrackingConfiguration())
        
        // Switch off the orientation lock for UIViewControllers with AR Scenes
        recorder?.rest()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Hide Status Bar
    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - Exported UIAlert present method
    func exportMessage(success: Bool, status:PHAuthorizationStatus) {
        if success {
            let alert = UIAlertController(title: "Exported", message: "Media exported to camera roll successfully!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Awesome", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if status == .denied || status == .restricted || status == .notDetermined {
            let errorView = UIAlertController(title: "😅", message: "Please allow access to the photo library in order to save this media file.", preferredStyle: .alert)
            let settingsBtn = UIAlertAction(title: "Open Settings", style: .cancel) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        })
                    } else {
                        UIApplication.shared.openURL(URL(string:UIApplication.openSettingsURLString)!)
                    }
                }
            }
            errorView.addAction(UIAlertAction(title: "Later", style: UIAlertAction.Style.default, handler: {
                (UIAlertAction)in
            }))
            errorView.addAction(settingsBtn)
            self.present(errorView, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Exporting Failed", message: "There was an error while exporting your media file.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - Button Action Methods
extension SCNViewController {
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func capture(_ sender: UIButton) {
        if sender.tag == 0 {
            //Photo
            if recorder?.status == .readyToRecord {
                let image = self.recorder?.photo()
                self.recorder?.export(UIImage: image) { saved, status in
                    if saved {
                        // Inform user photo has exported successfull
                        self.exportMessage(success: saved, status: status)
                    }
                }
            }
        }else if sender.tag == 1 {
            //Live Photo
            if recorder?.status == .readyToRecord {
                
                    self.recorder?.livePhoto(export: true) { ready, photo, status, saved in
                        /*
                         if ready {
                         // Do something with the `photo` (PHLivePhotoPlus)
                         }
                         */
                        
                        if saved {
                            // Inform user Live Photo has exported successfully
                            self.exportMessage(success: saved, status: status)
                        }
                    
                }
            }
        }else if sender.tag == 2 {
            //GIF
            if recorder?.status == .readyToRecord {
                recorder?.gif(forDuration: 3.0, export: true) { ready, gifPath, status, saved in
                    /*
                    if ready {
                        // Do something with the `gifPath`
                    }
                     */
                    
                    if saved {
                        // Inform user GIF image has exported successfully
                        self.exportMessage(success: saved, status: status)
                    }
                }
            }
        }
    }
    
    
    func registerDot(x: CGFloat, y: CGFloat, radius: CGFloat){
        let date = getDate()
        self.gridwriter?.write(x.description + "," + y.description + "," + radius.description + "," + date + "\n" )
        
    }
    
    func getDate() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy_MM_dd_hh_mm_ss"
        let now = df.string(from: Date())
        return now
    }
    
    func record(){
        
        
        
        if recorder?.status == .readyToRecord {
            
            
            

            appDelegate.fTSensingSession.enableSensor(sensorType: SKSensorType.DeviceMotion)
            
            if(appDelegate.fTSensingSession.isSensorAvailable(sensorType: SKSensorType.DeviceMotion))
            {
            
            }
            
            if appDelegate.fTSensingSession.start(sensorType:  SKSensorType.DeviceMotion){
            }
            self.fileName = getDate()
            var fnj = self.fileName
            let jn = "_AR.json"
            fnj?.append(jn)
            var gnf = self.fileName
            let cn = "_GRID.csv"
            gnf?.append(cn)
            
            self.filePath = getDocumentsDirectory()
            self.writer = JSONWriter.init(sensorType: "0", withHeader: "0", withFilename: fnj, inPath: self.filePath)
            self.gridwriter = JSONWriter.init(sensorType: "0", withHeader: "0", withFilename: gnf, inPath: self.filePath)
            
            //sender.setTitle("Stop", for: .normal)
            pauseBtn.setTitle("Pause", for: .normal)
            pauseBtn.isEnabled = true
            DispatchQueue.global(qos: .utility).async{
                self.recorder?.record()
            }
        }else if recorder?.status == .recording {
            //sender.setTitle("Record", for: .normal)
            pauseBtn.setTitle("Pause", for: .normal)
            pauseBtn.isEnabled = false
            writer?.close()
            gridwriter?.close()
            recorder?.stop() //{ path in
//                    self.recorder?.export(video: path) { saved, status in
//                        DispatchQueue.main.sync {
//                            self.exportMessage(success: saved, status: status)
//                        }
//                    }
//                }
            appDelegate.fTSensingSession.stopCSWriter()
            if appDelegate.fTSensingSession.stop(sensorType: SKSensorType.DeviceMotion){
            do{
                try appDelegate.fTSensingSession.sensingKit.deregister(SKSensorType.DeviceMotion)
                self.zipfiles()
                self.commsManager.sendFiles()
                
            }
            catch{
                
            }
                
                
        }
        }
    }
    
    
    @IBAction func record(_ sender: UIButton) {
        
        
        if sender.tag == 0 {
            
            self.record()
            
            
            
        }}}
            
            //Record
//            if recorder?.status == .readyToRecord {
//
//
//
//                appDelegate.fTSensingSession.enableSensor(sensorType: SKSensorType.DeviceMotion)
//
//                if(appDelegate.fTSensingSession.isSensorAvailable(sensorType: SKSensorType.DeviceMotion))
//                {
//
//                }
//
//                if appDelegate.fTSensingSession.start(sensorType:  SKSensorType.DeviceMotion){
//                }
//                self.fileName = getDate()
//                var fnj = self.fileName
//                let jn = "_AR.json"
//                fnj?.append(jn)
//                var gnf = self.fileName
//                let cn = "_GRID.csv"
//                gnf?.append(cn)
//
//                self.filePath = getDocumentsDirectory()
//                self.writer = JSONWriter.init(sensorType: "0", withHeader: "0", withFilename: fnj, inPath: self.filePath)
//                self.gridwriter = JSONWriter.init(sensorType: "0", withHeader: "0", withFilename: gnf, inPath: self.filePath)
//
//                sender.setTitle("Stop", for: .normal)
//                pauseBtn.setTitle("Pause", for: .normal)
//                pauseBtn.isEnabled = true
//                DispatchQueue.global(qos: .utility).async{
//                    self.recorder?.record()
//                }
//            }else if recorder?.status == .recording {
//                sender.setTitle("Record", for: .normal)
//                pauseBtn.setTitle("Pause", for: .normal)
//                pauseBtn.isEnabled = false
//                writer?.close()
//                gridwriter?.close()
//                recorder?.stop() //{ path in
////                    self.recorder?.export(video: path) { saved, status in
////                        DispatchQueue.main.sync {
////                            self.exportMessage(success: saved, status: status)
////                        }
////                    }
////                }
//                appDelegate.fTSensingSession.stopCSWriter()
//                if appDelegate.fTSensingSession.stop(sensorType: SKSensorType.DeviceMotion){
//                do{
//                    try appDelegate.fTSensingSession.sensingKit.deregister(SKSensorType.DeviceMotion)
//                    self.zipfiles()
//                    self.commsManager.sendFiles()
//
//                }
//                catch{
//
//                }
//
//
//            }
//            }
//            else if sender.tag == 1 {
//            //Record with duration
//            if recorder?.status == .readyToRecord {
//                }
//                sender.setTitle("Stop", for: .normal)
//                pauseBtn.setTitle("Pause", for: .normal)
//                pauseBtn.isEnabled = false
//                recordBtn.isEnabled = false
//
//                    self.recorder?.record(forDuration: 10) { path in
//                        self.recorder?.export(video: path) { saved, status in
//                            DispatchQueue.main.sync {
//                                sender.setTitle("w/Duration", for: .normal)
//                                self.pauseBtn.setTitle("Pause", for: .normal)
//                                self.pauseBtn.isEnabled = false
//                                self.recordBtn.isEnabled = true
//                                self.exportMessage(success: saved, status: status)
//                            }
//                        }
//                    }
//
//            }else if recorder?.status == .recording {
//                sender.setTitle("w/Duration", for: .normal)
//                pauseBtn.setTitle("Pause", for: .normal)
//                pauseBtn.isEnabled = false
//                recordBtn.isEnabled = true
//                recorder?.stop() //{ path in
////                    self.recorder?.export(video: path) { saved, status in
////                        DispatchQueue.main.sync {
////                            self.exportMessage(success: saved, status: status)
////                        }
////                    }
////                }
//
//
//                    //self.zipfiles()
//
//
//            }
//        }else if sender.tag == 2 {
//            //Pause
//            if recorder?.status == .paused {
//                sender.setTitle("Pause", for: .normal)
//                recorder?.record()
//            }else if recorder?.status == .recording {
//                sender.setTitle("Resume", for: .normal)
//                recorder?.pause()
//            }
//        }
//
//    }
   
//        }}





//MARK: - ARVideoKit Delegate Methods
extension SCNViewController {
    func frame(didRender buffer: CVPixelBuffer, with time: CMTime, using rawBuffer: CVPixelBuffer) {
        // Do some image/video processing.
    }
    
    func recorder(didEndRecording path: URL, with noError: Bool) {
        if noError {
            // Do something with the video path.
        }
    }
    
    func recorder(didFailRecording error: Error?, and status: String) {
        // Inform user an error occurred while recording.
    }
    
    func recorder(willEnterBackground status: RecordARStatus) {
        // Use this method to pause or stop video recording. Check [applicationWillResignActive(_:)](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622950-applicationwillresignactive) for more information.
        if status == .recording {
            recorder?.stopAndExport()
        }
    }
}

extension SCNViewController {
        
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        currentFaceAnchor = faceAnchor
        
        // If this is the first time with this anchor, get the controller to create content.
        // Otherwise (switching content), will change content when setting `selectedVirtualContent`.
        if node.childNodes.isEmpty, let contentNode = selectedContentController.renderer(renderer, nodeFor: faceAnchor) {
            node.addChildNode(contentNode)
        }
        
       // print(selectedContentController.rightEyeNode.simdPivot)
    }
    
    /// - Tag: ARFaceGeometryUpdate

}
