//
//  LEOReferralViewController.swift
//  Leo
//
//  Created by Adam Fanslau on 8/2/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import UIKit
import MessageUI

final class LEOReferralViewController :
    UIViewController,
    MFMailComposeViewControllerDelegate,
    MFMessageComposeViewControllerDelegate {

    let headerText = "Refer a friend"
    let bodyText = "Tell your friends about Leo and invite them to schedule a consult with us. When they sign up they will receive 3 months of membership for free"
    let emailSubject = "You should check out Leo + Flatiron Pediatrics"

    @IBOutlet weak var headerLabel: UILabel! {
        didSet {
            headerLabel.text = headerText
            headerLabel.font = UIFont.leo_ultraLight27()
            headerLabel.textColor = UIColor.leo_gray124()
        }
    }

    @IBOutlet weak var bodyLabel: UILabel! {
        didSet {
            bodyLabel.text = bodyText
            bodyLabel.font = UIFont.leo_regular15()
            bodyLabel.textColor = UIColor.leo_gray124()
            bodyLabel.numberOfLines = 0
        }
    }

    @IBOutlet weak var inviteButtonEmail: UIButton! {
        didSet {
            inviteButtonEmail.setTitle("INVITE BY EMAIL", forState: .Normal)
            styleButton(inviteButtonEmail)
        }
    }

    @IBOutlet weak var inviteButtonText: UIButton! {
        didSet {
            inviteButtonText.setTitle("INVITE BY TEXT MESSAGE", forState: .Normal)
            styleButton(inviteButtonText)
        }
    }

    override func viewWillAppear(animated: Bool) {
        setupNavigationBar()
    }


    // MARK: Data

    // NOTE: AF maybe this is overkill here. could just use let, but then it gets immediately initialized non-lazily
    private(set) lazy var referralURL: String = {

        let user = LEOUserService().getCurrentUser()
        guard let vendorID = user?.anonymousCustomerServiceID else {
            return ""
        }

        return "https://calendly.com/leoflatiron?utm_campaign=\(vendorID)"
    }()

    func messageBody() -> String {
        return "Schedule a consult to learn more about Leo + Flatiron Pediatrics! \(referralURL)"
    }

    func emailBody() -> String {
        return "We’re current members of Leo + Flatiron Pediatrics and it’s been a great experience so far.  On top of providing the highest quality clinical care (the team there has been amazing!) they have a ton of features that make managing my child’s care so much easier.  There is a mobile app where you can message the care team directly, schedule/reschedule appointments, and access your child’s health record.  You can also book same-day appointments, get prescriptions delivered, and even participate in appointments virtually. You can easily <strong><a href=\"\(referralURL)\">schedule a consult</a></strong> to learn more or <strong><a href=\"www.leohealth.com\">check out their website</a></strong>."
    }

    // MARK: Button Actions

    @IBAction func inviteButtonEmailAction() {

        // NOTE: leaving both options in here to come back and decide which is swiftier
        let vc: UIViewController
        if MFMailComposeViewController.canSendMail() {
            vc = configuredMailComposeViewController()
        } else {
            vc = LEOAlertHelper.alertWithTitle("Oops! We couldn't compose a new email",
                                          message: "Make sure your device is set up to send emails",
                                          handler: nil)
        }

        self.presentViewController(vc,
                                   animated: true,
                                   completion: nil)
    }

    @IBAction func inviteButtonTextAction() {

        // NOTE: leaving both options in here to come back and decide which is swiftier
        func composerOrAlert() -> UIViewController {
            if MFMessageComposeViewController.canSendText() {
                return configuredMessageComposeViewController()
            } else {
                return LEOAlertHelper.alertWithTitle("Oops! We couldn't compose a new message",
                                                   message: "Make sure your device is set up to send text messages",
                                                   handler: nil)
            }
        }

        self.presentViewController(composerOrAlert(),
                                   animated: true,
                                   completion: nil)
    }


    // MARK: MFMessageComposeViewController

    func configuredMessageComposeViewController() -> MFMessageComposeViewController {

        UINavigationBar.appearance().setBackgroundImage(nil, forBarMetrics: .Default)

        let messageComposerVC = MFMessageComposeViewController()
        messageComposerVC.messageComposeDelegate = self
        messageComposerVC.body = messageBody()

        return messageComposerVC
    }

    func messageComposeViewController(controller: MFMessageComposeViewController,
                                      didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }


    // MARK: MFMailComposeViewController

    func configuredMailComposeViewController() -> MFMailComposeViewController {

        UINavigationBar.appearance().setBackgroundImage(nil, forBarMetrics: .Default)

        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setSubject(emailSubject)
        mailComposerVC.setMessageBody(emailBody(), isHTML: true)

        return mailComposerVC
    }

    func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult,
                                                   error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }


    // MARK: Styling

    func styleButton(button: UIButton) {
        LEOStyleHelper.styleButton(button, forFeature: .Settings)
    }

    func setupNavigationBar() {

        navigationController?.navigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage.leo_imageWithColor(UIColor.leo_orangeRed()), forBarMetrics: .Default)
        LEOStyleHelper.styleBackButtonForViewController(self, forFeature: .Settings)
        LEOStyleHelper.styleViewController(self, navigationTitleText: headerText, forFeature: .Settings)
    }
}

