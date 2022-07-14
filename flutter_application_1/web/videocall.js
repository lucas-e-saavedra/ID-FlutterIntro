function readParams(){
    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);
    apiKey = urlParams.get('apikey')
    sessionId = urlParams.get('session')
    token = urlParams.get('token')

    let bla = `apikey:${apiKey}<br>session:${sessionId}<br>token:${token}`
    document.getElementById('info').innerHTML = bla;
    initializeSession()
}


// Handling all of our errors here by alerting them
function handleError(error) {
    if (error) {
      alert(error.message);
    }
  }
  
  function initializeSession() {
    var session = OT.initSession(apiKey, sessionId);
  
    // Subscribe to a newly created stream
  
    // Create a publisher
    var publisher = OT.initPublisher('publisher', {
      insertMode: 'append',
      width: '100%',
      height: '100%'
    }, handleError);
  
    // Connect to the session
    session.connect(token, function(error) {
      // If the connection is successful, publish to the session
      if (error) {
        handleError(error);
      } else {
        session.publish(publisher, handleError);
      }
    });


    session.on('streamCreated', function(event) {
        session.subscribe(event.stream, 'subscriber', {
          insertMode: 'append',
          width: '100%',
          height: '100%'
        }, handleError);
      });
  }