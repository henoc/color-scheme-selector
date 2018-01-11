import * as vscode from "vscode";
import * as fs from "fs";
import * as path from "path";
import {render} from "ejs";

export function activate(context: vscode.ExtensionContext) {

  let previewUri = vscode.Uri.parse("color-scheme-selector://authority/color-scheme-selector");
  let readResource = (filename: string) => fs.readFileSync(path.join(__dirname, "..", "resources", filename), "UTF-8");
  let viewer = readResource("viewer.ejs");
  let bundle = readResource("bundle.js");
  let style = readResource("style.css");
  let externals = readResource("externals.js");

  class TextDocumentContentProvider implements vscode.TextDocumentContentProvider {
    public provideTextDocumentContent(uri: vscode.Uri): string {
      const html = render(viewer, {
        bundle: bundle,
        style: style,
        externals: externals
      });
      return html;
    }
  }

  let provider = new TextDocumentContentProvider();
  let disposables: vscode.Disposable[] = [];
  disposables.push(vscode.workspace.registerTextDocumentContentProvider("color-scheme-selector", provider));
  disposables.push(vscode.commands.registerCommand("colorSchemeSelector.openColorSchemeSelector", () => {
    return vscode.commands.executeCommand("vscode.previewHtml", previewUri, vscode.ViewColumn.One, "Color Scheme Selector").then((success) => undefined, (reason) => {
      vscode.window.showErrorMessage(reason);
    });
  }));

  context.subscriptions.push(...disposables);
}
