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
}, 0);
