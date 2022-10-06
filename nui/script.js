// events
window.addEventListener("message", (event) => {
  switch (event.data.action) {
    case "open":
      Open(event.data);
      break;
    case "close":
      Close();
      break;
    case "setup":
      Setup(event.data);
      break;
  }
});

// functions
const Open = (data) => {
  $(".playerlist-toggle").fadeIn(0);
  $("#total-players").html("<p>" + data.players + " / " + data.maxPlayers + "</p>");
};

const Close = () => {
  $.post(`https://${GetParentResourceName()}/closelist`);
  $(".playerlist-toggle").fadeOut(0);      
};

const Setup = (data) => {
  let playerlistHtml = "";
  $.each(data.items, (index, value) => {
    if (index == 0) {
      index = 1;
    }    
    if (value != null) {
      playerlistHtml += `
        <div class="playerlist-data" data-type=${index}>
          <div class="data-title">
              <p>[${index}] ${value}</p>
          </div>
          <div class="data-value"></div>
        </div>
      `;
    }
  });  
  $(".playerlist-info").html(playerlistHtml);
};

// keypress (onkeydown)
document.onkeydown = function (event) {
  const charCode = event.key;
  if (charCode == "Escape") {
    Close();
  } else if (charCode == "u") {
    Close();
  } else if (charCode == "Backspace") {
    Close();
  }
};