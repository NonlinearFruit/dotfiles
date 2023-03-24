(function buttonFactory(){
  const MY_BUTTONS = {
    CronStatus: {
      html: `
        <button name="CronStatus" draggable="false" tabindex="-1" title="Cron Status" type="button" class="ToolbarButton-Button">
          &#128557;
        </button>
      `,
      onclick: () => {
        console.log('Hello from the button!')
      },
      placeAfter: ".ClockButton"
    }
  };

  function doContentScript(func){
    chrome.tabs.executeScript({
      code: `(${func})()`
    });
  }

  /** https://stackoverflow.com/a/6348597/4769802 */
  function addEvent(element, event, funct){
    if (element.attachEvent)
      return element.attachEvent('on'+event, funct);
    else
      return element.addEventListener(event, funct, false);
  }

  function makeButton(buttonDef) {
    const div = document.createElement("div");
    div.className = "button-toolbar panel-clickoutside-ignore clflngg0o000w3561y4csxmzo";
    div.innerHTML = buttonDef.html;
    const newBtn = div.firstChild;
    if(buttonDef.onclick)
      addEvent(newBtn, "click", buttonDef.onclick);
    if(buttonDef.contentScript)
      addEvent(newBtn, "click", () => {
        doContentScript(buttonDef.contentScript);
      });
    return div;
  }

  function createButton(buttonDef){
    const existingUi = document.querySelector(buttonDef.placeAfter);
    if(existingUi)
      existingUi.insertAdjacentElement("afterend", makeButton(buttonDef));
    else
      console.warn(`Can't add button as selector ${buttonDef.placeAfter} is not ready`);
  }

  function makeAllButtons(){
    for(const buttonKey in MY_BUTTONS)
      createButton(MY_BUTTONS[buttonKey]);
  }

  function init(){
    if(document.querySelector("#browser"))
      makeAllButtons();
    else
      setTimeout(init, 500);
  }

  init();
})();
