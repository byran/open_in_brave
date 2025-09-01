const HOST_NAME = "uk.co.adgico.open-in-brave";

function createMenus() {
    chrome.contextMenus.create({
        id: "openWithBraveLink",
        title: "Open link in Brave",
        contexts: ["link"]
    });
    chrome.contextMenus.create({
        id: "openWithBravePage",
        title: "Open this page in Brave",
        contexts: ["page"]
    });
    chrome.contextMenus.create({
        id: "openWithBraveSelection",
        title: "Open selected URL in Brave",
        contexts: ["selection"]
    });
}

chrome.runtime.onInstalled.addListener(() => {
    createMenus();
});

chrome.contextMenus.onClicked.addListener((info, tab) => {
    let url = null;
    if (info.menuItemId === "openWithBraveLink" && info.linkUrl) {
        url = info.linkUrl;
    } else if (info.menuItemId === "openWithBravePage" && tab && tab.url) {
        url = tab.url;
    } else if (info.menuItemId === "openWithBraveSelection" && info.selectionText) {
        // naive URL extraction
        const maybe = info.selectionText.trim();
        if (/^https?:\/\//i.test(maybe)) url = maybe;
    }
    if (!url) return;

    chrome.runtime.sendNativeMessage(HOST_NAME, { url }, (response) => {
        if (chrome.runtime.lastError) {
            console.error("NativeMessaging error:", chrome.runtime.lastError.message);
            return;
        }
        if (!response || response.ok !== true) {
            console.error("Brave opener failed:", response && response.error);
        }
    });
});
