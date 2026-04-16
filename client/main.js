const { app, BrowserWindow, session, dialog, ipcMain } = require('electron');
const path = require('path');

let win;
let currentLang = 'fr';

const DIALOG_TRANSLATIONS = {
  fr: {
    buttons: ['Autoriser', 'Refuser'],
    title: 'Autorisation requise',
    message: 'Accès à la caméra',
    detail: 'Cette application souhaite utiliser votre caméra pour prendre une photo de profil. Voulez-vous l\u2019autoriser ?',
  },
  en: {
    buttons: ['Allow', 'Deny'],
    title: 'Permission required',
    message: 'Camera access',
    detail: 'This application would like to use your camera to take a profile picture. Do you want to allow it?',
  },
};

function registerMediaPermissionHandlers() {
  const ses = session.defaultSession;

  ses.setPermissionRequestHandler(async (webContents, permission, callback, details) => {
    const isMedia =
      permission === 'media' ||
      permission === 'camera' ||
      permission === 'microphone' ||
      (Array.isArray(details?.mediaTypes) && details.mediaTypes.includes('video'));

    if (!isMedia) {
      callback(false);
      return;
    }

    const t = DIALOG_TRANSLATIONS[currentLang] ?? DIALOG_TRANSLATIONS.fr;
    const parent = BrowserWindow.fromWebContents(webContents) ?? win;
    const { response } = await dialog.showMessageBox(parent, {
      type: 'question',
      buttons: t.buttons,
      defaultId: 0,
      cancelId: 1,
      noLink: true,
      title: t.title,
      message: t.message,
      detail: t.detail,
    });

    callback(response === 0);
  });

  ses.setPermissionCheckHandler(() => false);
}

function registerIpcHandlers() {
  ipcMain.on('set-language', (_event, lang) => {
    if (lang === 'fr' || lang === 'en') {
      currentLang = lang;
    }
  });
}

function createWindow() {
  win = new BrowserWindow({
    width: 800,
    height: 1000,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      preload: path.join(__dirname, 'preload.js'),
    },
  });

  // win.webContents.openDevTools();

  win.loadURL(
    `file://${path.join(__dirname, 'dist', 'client', 'index.html')}`
  );
}

app.whenReady().then(() => {
  registerMediaPermissionHandlers();
  registerIpcHandlers();
  createWindow();
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});
