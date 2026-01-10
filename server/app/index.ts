import { AppModule } from '@app/app.module';
import { ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import * as bodyParser from 'body-parser';

const bootstrap = async () => {
    const app = await NestFactory.create(AppModule);

    // Configure body parser with increased limits
    app.use(bodyParser.json({ limit: '150kb' }));
    app.use(bodyParser.urlencoded({ limit: '150kb', extended: true }));

    app.setGlobalPrefix('api');
    app.useGlobalPipes(new ValidationPipe());
    app.enableCors();

    await app.listen(process.env.PORT);
};

bootstrap();
