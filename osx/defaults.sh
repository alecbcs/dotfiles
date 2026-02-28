#!/bin/bash

# See also:
# - https://macos-defaults.com
# - https://github.com/pawelgrzybek/dotfiles/blob/master/setup-macos.sh
# - https://github.com/mathiasbynens/dotfiles/blob/master/.macos
# - https://github.com/tgamblin/dotfiles/blob/master/osx/defaults

#
# Get readlink -f behavior when readlink doesn't support it
#
function readlink_f {
    _target_file=$1

    cd `dirname $_target_file`
    _target_file=`basename $_target_file`

    # Iterate down a (possible) chain of symlinks
    while [ -L "$_target_file" ]; do
    _target_file=`readlink $_target_file`
    cd `dirname $_target_file`
    _target_file=`basename $_target_file`
    done

    # Compute the canonicalized name by finding the physical path
    # for the directory we're in and appending the target file.
    _phys_dir=`pwd -P`
    _result=$_phys_dir/$_target_file
    echo $_result
}

# Directory this script lives in
script_dir=$(dirname $(readlink_f "$0"))

set -x

###############################################################################
# General UI/UX                                                               #
###############################################################################

# use function keys as standard function keys
defaults write com.apple.keyboard.fnState -int 1

# enable moving focus for keyboard navigation
defaults write NSGlobalDomain AppleKeyboardUIMode -int "2"

# dynamically show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"
# possible values: `WhenScrolling`, `Automatic` and `Always`

# save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# disable resume system-wide
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# disable app bouncing on the dock
defaults write com.apple.dock no-bouncing -bool true

# disable Tahoe menu icons that are everywhere
defaults write NSGlobalDomain NSMenuEnableActionImages -bool false

###############################################################################
# Trackpad, mouse, keyboard                                                   #
###############################################################################

# enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -int 1
sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -int 1
sudo defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# turn on secondary click with two fingers
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 0
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -int 1

# enable natural scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

# set a fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 3
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# install custom keybindings for additional emacs shortcuts
cp "$(dirname $0)/DefaultKeyBinding.dict" ~/Library/KeyBindings/DefaultKeyBinding.dict

###############################################################################
# Screen                                                                      #
###############################################################################

# require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# save screenshots with the date in their name
defaults write com.apple.screencapture "include-date" -bool "true"

# disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# set Home as the default location for new Finder windows
# for Desktop, use `PfDe` and `file://${HOME}/Desktop/`
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

# keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# view finder window as list
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# hide tags from finder
defaults write com.apple.finder ShowRecentTags -int 0

# avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# empty trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

# empty trash items automatically after 30 days
defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true"

# when performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# show the ~/Library folder
chflags nohidden ~/Library

# hide hard drives, external usb drives, and cds, and servers from desktop
defaults write com.apple.finder ShowHardDrivesOnDesktop -int 0
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -int 0
defaults write com.apple.finder ShowMountedServersOnDesktop -int 0
defaults write com.apple.finder ShowRemovableMediaOnDesktop -int 0

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# set the icon size of Dock items
defaults write com.apple.dock tilesize -int 58

# set the icon size of Dock items (magnified)
defaults write com.apple.dock largesize -int 65

# set the Dock to magnify on cursor hover
defaults write com.apple.dock magnification -bool true

# position Dock on the left-hand side of the screen
defaults write com.apple.dock orientation -string "left"

# automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# disable recently viewed applications on the Dock
defaults write com.apple.dock show-recents -bool false

# make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true


###############################################################################
# Safari & WebKit                                                             #
###############################################################################

# prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# hide Safari’s bookmarks bar by default
defaults write com.apple.Safari ShowFavoritesBar -bool false

# privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# make Safari’s search banners default to Contains instead of Starts With
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# disable AutoFill
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

# warn about fraudulent websites
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

###############################################################################
# Mail                                                                        #
###############################################################################

# copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# display emails in threaded mode, sorted by date (newest at the top)
defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "no"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

# disable inline attachments (just show the icons)
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

# automatically try sending later if outgoing server is unavailable
defaults write com.apple.mail SuppressDeliveryFailure -bool true

# include search results from encrypted messages
defaults write com.apple.mail IndexDecryptedMessages -bool true

# when quoting include all of the original message text
defaults write com.apple.mail AlwaysIncludeOriginalMessage -bool true

# place signature above quoted text
defaults write com.apple.mail SignaturePlacedAboveQuotedText -bool true

# show formatting bar in message compose window
defaults write com.apple.mail ShowComposeFormatInspectorBar -bool true

# set fixed-width font
defaults write com.apple.mail NSFixedPitchFont -string "Menlo-Regular"
defaults write com.apple.mail NSFixedPitchFontSize -int 14

# set message font
defaults write com.apple.mail NSFont -string Helvetica
defaults write com.apple.mail NSFontSize -int 14

###############################################################################
# Messages                                                                    #
###############################################################################

# disable automatic emoji substitution (i.e. use plain text smileys)
defaults write com.apple.messageshelper.MessageController SOInputLineSettings \
         -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false

# disable smart quotes as it’s annoying for messages that contain code
defaults write com.apple.messageshelper.MessageController SOInputLineSettings \
         -dict-add "automaticQuoteSubstitutionEnabled" -bool false

# disable continuous spell checking
defaults write com.apple.messageshelper.MessageController SOInputLineSettings \
         -dict-add "continuousSpellCheckingEnabled" -bool false

###############################################################################
# TextEdit                                                                    #
###############################################################################

# use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0

# open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

###############################################################################
# Activity Monitor                                                            #
###############################################################################

# show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# aort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Terminal                                                                    #
###############################################################################

# enable Secure Keyboard Entry in Terminal.app
# see: https://security.stackexchange.com/a/47786/8918
defaults write com.apple.terminal SecureKeyboardEntry -bool true

# disable the annoying line marks
defaults write com.apple.Terminal ShowLineMarks -int 0

# use my Terminal settings in Terminal.app
open "${script_dir}/default.terminal"
sleep 1 # Wait a bit to make sure the theme is loaded
defaults write com.apple.terminal "Default Window Settings" -string "default"
defaults write com.apple.terminal "Startup Window Settings" -string "default"

# set default iTerm2 profile
defaults write com.googlecode.iterm2 "PrefsCustomFolder" -string "${HOME}/src/${USER}/dotfiles/osx/"
defaults write com.googlecode.iterm2 "LoadPrefsFromCustomFolder" -bool true

###############################################################################
# Apple Intelligence                                                          #
###############################################################################

# disable Apple Intelligence by default
defaults write com.apple.CloudSubscriptionFeatures.optIn "545129924" -bool "false"

###############################################################################
# Time Machine                                                                #
###############################################################################

# prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# disable MacOS Unplugged Drive Notification
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.DiskArbitration.diskarbitrationd.plist \
     DADisableEjectNotification -bool YES && sudo pkill diskarbitrationd

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" "Dock" "Finder" "Mail" "Messages" "Safari" \
    "Safari" "SystemUIServer" "Terminal"; do
    killall "${app}" > /dev/null 2>&1
done
echo "Done. Note that some of these changes require a logout/restart to take effect."
