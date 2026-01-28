import { Injectable, OnModuleInit, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as admin from 'firebase-admin';
import * as fs from 'fs';
import * as path from 'path';

@Injectable()
export class FirebaseAdminService implements OnModuleInit {
    private readonly logger = new Logger(FirebaseAdminService.name);
    private firebaseApp: admin.app.App;

    constructor(private readonly configService: ConfigService) {}

    onModuleInit(): void {
        this.initializeFirebase();
    }

    getAuth(): admin.auth.Auth {
        return this.firebaseApp.auth();
    }

    getApp(): admin.app.App {
        return this.firebaseApp;
    }

    private initializeFirebase(): void {
        try {
            if (admin.apps.length > 0) {
                this.firebaseApp = admin.apps[0];
                this.logger.log('Firebase already initialized, reusing existing app');
                return;
            }

            const serviceAccountPath = this.configService.get<string>('firebase.serviceAccountPath');
            const absolutePath = path.resolve(process.cwd(), serviceAccountPath);
            const serviceAccount = JSON.parse(fs.readFileSync(absolutePath, 'utf8'));

            this.firebaseApp = admin.initializeApp({
                credential: admin.credential.cert(serviceAccount),
            });

            this.logger.log('Firebase Admin SDK initialized successfully');
        } catch (error) {
            this.logger.error('Failed to initialize Firebase Admin SDK', error);
            throw error;
        }
    }
}
