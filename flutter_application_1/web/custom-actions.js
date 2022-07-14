function loadVideoCall(apikey, sessionId, sessionToken) {
    window.location.href = `videocall.html?apikey=${apikey}&session=${sessionId}&token=${sessionToken}`;
}