const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('electron', {
    setLanguage: (lang) => ipcRenderer.send('set-language', lang),
});
