export default () => ({
    port: parseInt(process.env.PORT, 10) || 3000,
    database: {
        connectionString: process.env.DATABASE_CONNECTION_STRING,
    },
    firebase: {
        serviceAccountPath: process.env.FIREBASE_SERVICE_ACCOUNT_PATH || './firebase-service-account.json',
    },
    game: {
        turnDuration: parseInt(process.env.TURN_DURATION, 10) || 120,
        turnBreak: parseInt(process.env.TURN_BREAK, 10) || 5,
        countdownInterval: parseInt(process.env.COUNTDOWN_INTERVAL, 10) || 1000,
    },
});
