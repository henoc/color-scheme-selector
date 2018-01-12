const app = Elm.Main.fullscreen();

// colorを取得してすべてのiconに適用する
const text = document.getElementById("sample");
const textCss = window.getComputedStyle(text);
setTimeout(() => {
  const icons = document.getElementsByTagName("i");
  for (let i = 0; i < icons.length; i++) {
    const icon = icons.item(i);
    icon.style.color = textCss.color;
  }
  text.remove();
}, 100);

// colorsの自動読み込み
const colors = document.getElementById("colors");
app.ports.loadColorScheme.send(JSON.parse(colors.textContent));
colors.remove();

// colorsの保存
app.ports.saveColorScheme.subscribe(function(colors) {
  const name = "colorSchemeSelector.saveColorScheme";
  const args = [colors];
  window.parent.postMessage(
    {
      command: "did-click-link",
      data: `command:${name}?${encodeURIComponent(JSON.stringify(args))}`
    },
    "file://"
  );
});
