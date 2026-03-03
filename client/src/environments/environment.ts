// This file can be replaced during build by using the `fileReplacements` array.
// `ng build` replaces `environment.ts` with `environment.prod.ts`.
// The list of file replacements can be found in `angular.json`.

export const environment = {
    production: false,
    firebase: {
        apiKey: 'AIzaSyCIX3GxkioYqJn02yQbyl92wy9EPIMfIVk',
        authDomain: 'log3900-105.firebaseapp.com',
        projectId: 'log3900-105',
        storageBucket: 'log3900-105.firebasestorage.app',
        messagingSenderId: '93329584718',
        appId: '1:93329584718:web:5e214b2f3b60e64e68491f',
        measurementId: 'G-Y2307NYVWE',
    },
    // baseUrl: 'http://35.182.177.104:3000',
    baseUrl: 'http://localhost:3000',
    get serverUrl() {
        return `${this.baseUrl}/api`;
    },
    get socketUrl() {
        return this.baseUrl;
    },
};

/*
 * For easier debugging in development mode, you can import the following file
 * to ignore zone related error stack frames such as `zone.run`, `zoneDelegate.invokeTask`.
 *
 * This import should be commented out in production mode because it will have a negative impact
 * on performance if an error is thrown.
 */
// import 'zone.js/plugins/zone-error';  // Included with Angular CLI.
