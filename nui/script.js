var closeInstantly = false;
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
  closeInstantly = data.closeInstantly;
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
    if (value != null) {
      playerlistHtml += `
        <div class="playerlist-data" data-type=${value.iden}>
          <div class="data-title">
              <p>[${value.src}] ${value.iden}</p>
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
  console.log(closeInstantly);
  if (charCode == "Escape") {
    Close();
  } else if (charCode == "Backspace") {
    Close();
  } else if (charCode == "u" && (closeInstantly == false)) {    
    Close();
  }   
};