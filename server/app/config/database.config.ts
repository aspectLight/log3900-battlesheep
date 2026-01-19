import { ConfigService } from '@nestjs/config';

export const databaseConfig = {
    useFactory: async (config: ConfigService) => ({
        uri: config.get<string>('DATABASE_CONNECTION_STRING'),
    }),
    inject: [ConfigService],
};
