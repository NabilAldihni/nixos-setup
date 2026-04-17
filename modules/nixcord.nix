{ ... }:
{
  programs.nixcord = {
    enable = true;
    vesktop.enable = true;

    config = {
      autoUpdate = true;

      plugins = {
        accountPanelServerProfile.enable = true;
        anonymiseFileNames.enable = true;
        betterGifAltText.enable = true;
        betterGifPicker.enable = true;
        betterSettings.enable = true;
        biggerStreamPreview.enable = true;
        copyFileContents.enable = true;
        crashHandler.enable = true;
        fixCodeblockGap.enable = true;
        friendsSince.enable = true;
        fullSearchContext.enable = true;
        gameActivityToggle.enable = true;
        imageFilename.enable = true;
        imageZoom.enable = true;
        implicitRelationships.enable = true;
        memberCount.enable = true;
        mentionAvatars.enable = true;
        messageClickActions.enable = true;
        messageLatency.enable = true;
        messageLinkEmbeds.enable = true;
        messageLogger = {
          enable = true;
          separatedDiffs = true;
          # showEditDiffs = true;
        };
        MutualGroupDMs.enable = true;
        newGuildSettings.enable = true;
        noF1.enable = true;
        noServerEmojis.enable = true;
        OnePingPerDM.enable = true;
        pictureInPicture.enable = true;
        PinDMs.enable = true;
        readAllNotificationsButton.enable = true;
        relationshipNotifier.enable = true;
        serverInfo.enable = true;
        serverListIndicators.enable = true;
        shikiCodeblocks.enable = true;
        showHiddenChannels.enable = true;
        showMeYourName.enable = true;
        silentTyping.enable = true;
        sortFriendRequests.enable = true;
        unindent.enable = true;
        unsuppressEmbeds.enable = true;
        viewIcons.enable = true;
        voiceMessages.enable = true;
        volumeBooster.enable = true;
        webKeybinds.enable = true;
        webScreenShareFixes.enable = true;
        whoReacted.enable = true;
      };
    };
  };
}
