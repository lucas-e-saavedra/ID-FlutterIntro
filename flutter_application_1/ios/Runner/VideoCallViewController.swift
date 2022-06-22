//
//  VideoCallViewController.swift
//  Runner
//
//  Created by Lucas Saavedra on 22/06/2022.
//

import Foundation
import UIKit
import OpenTok

class VideoCallViewController: UIViewController, OTSessionDelegate, OTPublisherDelegate, OTSubscriberDelegate {
    @IBOutlet weak var oneTextArea: UITextView!
    @IBOutlet weak var otherView: UIView!
    private var mApiKey: String = ""
    private var mSessionId: String = ""
    private var mSessionToken: String = ""
    var session: OTSession?
    var publisher: OTPublisher?
    var subscriber: OTSubscriber?

    
    func setVideoCallValues(apikey: String?, sessionId: String?, sessionToken: String?) -> Void {
        mApiKey = apikey!
        mSessionId = sessionId!
        mSessionToken = sessionToken!
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()
       connectToAnOpenTokSession()
    }
    
    func AddText(oneText: String){
        oneTextArea.text = oneTextArea.text + "\n" + oneText
    }

    func connectToAnOpenTokSession() {
        AddText(oneText: "Apikey:" + mApiKey)
        AddText(oneText: "SessionId:" + mSessionId)
        session = OTSession(apiKey: mApiKey, sessionId: mSessionId, delegate: self)
        var error: OTError?
        session?.connect(withToken: mSessionToken, error: &error)
        if error != nil {
            AddText(oneText: "error!")
        }
    }

    // MARK: - OTSessionDelegate callbacks
    //extension ViewController: OTSessionDelegate {
        func sessionDidConnect(_ session: OTSession) {
            AddText(oneText: "The client connected to the OpenTok session.")

            let settings = OTPublisherSettings()
            settings.name = UIDevice.current.name
            guard let publisher = OTPublisher(delegate: self, settings: settings) else {
                return
            }

            var error: OTError?
            session.publish(publisher, error: &error)
            guard error == nil else {
                print(error!)
                return
            }

            guard let publisherView = publisher.view else {
                return
            }
            let screenBounds = UIScreen.main.bounds
            publisherView.frame = CGRect(x: screenBounds.width - 150 - 20, y: screenBounds.height - 150 - 20, width: 150, height: 150)
            view.addSubview(publisherView)
        }

       func sessionDidDisconnect(_ session: OTSession) {
           AddText(oneText: "The client disconnected from the OpenTok session.")
       }

       func session(_ session: OTSession, didFailWithError error: OTError) {
           AddText(oneText: "The client failed to connect to the OpenTok session: \(error).")
       }

       func session(_ session: OTSession, streamCreated stream: OTStream) {
           AddText(oneText: "session(_ session: OTSession, streamCreated stream: OTStream) ")
           subscriber = OTSubscriber(stream: stream, delegate: self)
           guard let subscriber = subscriber else {
               return
           }

           var error: OTError?
           session.subscribe(subscriber, error: &error)
           guard error == nil else {
               print(error!)
               return
           }
           guard let subscriberView = subscriber.view else {
               return
           }
           subscriberView.frame = CGRect(x: 0, y: 0, width: otherView.frame.width, height: otherView.frame.height)
           otherView.addSubview(subscriberView)
       }

       func session(_ session: OTSession, streamDestroyed stream: OTStream) {
           AddText(oneText: "A stream was destroyed in the session.")
       }
    //}
    
    // MARK: - OTPublisherDelegate callbacks
    //extension ViewController: OTPublisherDelegate {
       func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
           AddText(oneText: "The publisher failed: \(error)")
       }
    //}
    
    // MARK: - OTSubscriberDelegate callbacks
    //extension ViewController: OTSubscriberDelegate {
       public func subscriberDidConnect(toStream subscriber: OTSubscriberKit) {
           AddText(oneText: "The subscriber did connect to the stream.")
       }

       public func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
           AddText(oneText: "The subscriber failed to connect to the stream.")
       }
    //}

    

}
