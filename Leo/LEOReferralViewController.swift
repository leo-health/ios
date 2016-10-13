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

    @IBOutlet weak var headerLabel: UILabel! {
        didSet {
            headerLabel.text = "Share the love!"
            headerLabel.font = UIFont.leo_ultraLight27()
            headerLabel.textColor = UIColor.leo_gray124()
        }
    }

    @IBOutlet weak var bodyLabel: UILabel! {
        didSet {
            bodyLabel.text
                = "Leo membership with Flatiron Pediatrics is $20/month per child. If your friend becomes a Leo member, they will get their first month free. Invite them to come to an Open House to meet the team and learn more. Thanks for spreading the word!"
            bodyLabel.font = UIFont.leo_regular15()
            bodyLabel.textColor = UIColor.leo_gray124()
            bodyLabel.numberOfLines = 0
        }
    }

    @IBOutlet weak var inviteButtonEmail: UIButton! {
        didSet {
            inviteButtonEmail.setTitle("INVITE BY EMAIL", for: UIControlState())
            styleButton(inviteButtonEmail)
        }
    }

    @IBOutlet weak var inviteButtonText: UIButton! {
        didSet {
            inviteButtonText.setTitle("INVITE BY TEXT MESSAGE", for: UIControlState())
            styleButton(inviteButtonText)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
    }


    // MARK: Data

    // NOTE: AF maybe this is overkill here. could just use let, but then it gets immediately initialized non-lazily
    fileprivate(set) lazy var referralURL: String = {

        let user = LEOUserService().getCurrentUser()
        guard let vendorID = user?.anonymousCustomerServiceID else {
            return ""
        }

        return "https://calendly.com/leoflatiron?utm_campaign=\(vendorID)"
    }()

    func messageBody() -> String {
        return "I love our pediatric practice, Leo + Flatiron Pediatrics! Come to an Open House \(referralURL)"
    }

    func emailBody() -> String {
        return "Hi,<br/><br/>We are members of Leo + Flatiron Pediatrics and love our experience. In addition to providing great clinical care they have a ton of features that make managing my family’s care so much easier. There is a mobile app where I can message the care team directly, schedule/reschedule appointments, and access my child’s health record.  I can also book same-day appointments, get prescriptions delivered for free, and even participate in appointments virtually.<br/><br/>Leo membership with Flatiron Pediatrics is $20/month per child.<br/><br/>To learn more, <strong><a href=\"www.leohealth.com\">check out their website</a></strong> and sign up for an Open House using the referral link below. If you decide to become a member you'll get your first month free!<br/><strong><a href=\"\(referralURL)\">\(referralURL)</a></strong>"
    }

    // MARK: Button Actions

    @IBAction func inviteButtonEmailAction() {

        // NOTE: leaving both options in here to come back and decide which is swiftier
        let vc: UIViewController
        if MFMailComposeViewController.canSendMail() {
            vc = configuredMailComposeViewController()
        } else {
            vc = LEOAlertHelper.alert(withTitle: "Oops! We couldn't compose a new email",
                                          message: "Make sure your device is set up to send emails",
                                          handler: nil)
        }

        self.present(vc,
                                   animated: true,
                                   completion: nil)
    }

    @IBAction func inviteButtonTextAction() {

        // NOTE: leaving both options in here to come back and decide which is swiftier
        func composerOrAlert() -> UIViewController {
            if MFMessageComposeViewController.canSendText() {
                return configuredMessageComposeViewController()
            } else {
                return LEOAlertHelper.alert(withTitle: "Oops! We couldn't compose a new message",
                                                   message: "Make sure your device is set up to send text messages",
                                                   handler: nil)
            }
        }

        self.present(composerOrAlert(),
                                   animated: true,
                                   completion: nil)
    }


    // MARK: MFMessageComposeViewController

    func configuredMessageComposeViewController() -> MFMessageComposeViewController {

        let messageComposerVC = MFMessageComposeViewController()
        messageComposerVC.messageComposeDelegate = self
        messageComposerVC.body = messageBody()

        return messageComposerVC
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }


    // MARK: MFMailComposeViewController

    func configuredMailComposeViewController() -> MFMailComposeViewController {

        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setSubject("Learn more about Leo + Flatiron Pediatrics")
        mailComposerVC.setMessageBody(emailBody(), isHTML: true)

        return mailComposerVC
    }

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                                                   error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }


    // MARK: Styling

    func styleButton(_ button: UIButton) {
        LEOStyleHelper.styleButton(button, for: .settings)
    }

    func setupNavigationBar() {

        navigationController?.isNavigationBarHidden = false

        LEOStyleHelper.styleNavigationBar(for: self, for: .settings, withTitleText: "Refer a friend", dismissal: false, backButton: true);
    }
}

