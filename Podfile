# Uncomment this line to define a global platform for your project

platform :ios, '8.3'

# ignore all warnings from all pods (we may choose to periodically re-evaluate this!)
inhibit_all_warnings!

#All pods are followed by their license type
target 'Leo' do

#Should be part of the app for certain for the medium term
pod 'CrittercismSDK', '5.5.0' #License needed?
pod 'Fabric' #non-standard license; see https://fabric.io/privacy
pod 'Crashlytics' #non-standard license; https://fabric.io/privacy
pod 'Localytics',  '~> 3.0' #License needed?
pod 'Stripe' #License needed?
pod 'JSQMessagesViewController' #MIT
pod 'libPusher', '~> 1.5' #MIT

#Good to have, but could rewrite; not worth it for now
pod 'AFNetworking' #MIT
pod 'SSKeychain' #MIT
pod 'DateTools' #MIT
pod 'CWStatusBarNotification', '~> 2.3.4' #MIT
pod 'MBProgressHUD' #MIT

#Should replace with our own implementations
pod 'UIImage-Resize' #MIT
pod 'TPKeyboardAvoiding' #Zlib
pod 'ActionSheetPicker-3.0', '~> 2.0.1' #BSD
pod 'RSKImageCropper' #MIT
pod 'GNZSlidingSegment', :git => 'https://github.com/chrisgonzgonz/GNZSlidingSegment.git'  #MIT

#Should review dependencies of these pods to ensure that all pods are compliant with their own licenses. e.g. Facebook Pop, etc.

end

target 'LeoTests' do

pod 'Expecta' #MIT
pod 'Specta', :git => 'https://github.com/specta/specta.git', :commit => 'c07c003cfe3a41fa510567e2e0a9fd7f5ae3b098' #MIT

pod 'OHHTTPStubs' #MIT

end


__END__

Additional dependencies and their associated licenses
Facebook Pop

BSD License

For Pop software

Copyright (c) 2014, Facebook, Inc. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

 * Neither the name Facebook nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
